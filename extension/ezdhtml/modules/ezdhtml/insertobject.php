<?php
//
//
// SOFTWARE NAME: eZ Online Editor
// COPYRIGHT NOTICE: Copyright (C) 1999-2008 eZ Systems AS
// SOFTWARE LICENSE: GNU General Public License v2.0
// NOTICE: >
//   This program is free software; you can redistribute it and/or
//   modify it under the terms of version 2.0  of the GNU General
//   Public License as published by the Free Software Foundation.
//
//   This program is distributed in the hope that it will be useful,
//   but WITHOUT ANY WARRANTY; without even the implied warranty of
//   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//   GNU General Public License for more details.
//
//   You should have received a copy of version 2.0 of the GNU General
//   Public License along with this program; if not, write to the Free
//   Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
//   MA 02110-1301, USA.
//
require_once( "kernel/common/template.php" );
include_once( "lib/ezdb/classes/ezdb.php" );
/*include_once( "kernel/classes/datatypes/ezimage/ezimagevariation.php");
include_once( "kernel/classes/datatypes/ezimage/ezimage.php");
include_once( "lib/ezimage/classes/ezimagelayer.php" );
include_once( "lib/ezimage/classes/ezimagetextlayer.php" );
include_once( "lib/ezimage/classes/ezimagefont.php" );
include_once( "lib/ezimage/classes/ezimageobject.php" );
include_once( "lib/eztemplate/classes/eztemplateimageoperator.php" );
*/
include_once( "lib/ezutils/classes/ezini.php" );
include_once( "lib/ezutils/classes/ezsys.php" );
include_once( "kernel/classes/ezcontentobject.php");
include_once( "lib/ezutils/classes/ezhttptool.php" );
include_once( "lib/ezutils/classes/ezhttpfile.php" );
include_once( 'lib/ezlocale/classes/ezdatetime.php' );
include_once( "kernel/classes/datatypes/ezuser/ezuser.php" );
include_once( 'kernel/classes/ezcontentbrowse.php' );

include_once( 'extension/ezdhtml/lib/commonfunctions.php' );
include_once( 'extension/ezdhtml/lib/system.php' );

include_once( 'lib/version.php' );
$eZPublishVersion = eZPublishSDK::majorVersion() + eZPublishSDK::minorVersion() * 0.1;
$eZPublishRelease = eZPublishSDK::release();

$Module = $Params["Module"];
$ObjectID = null;
if ( isset( $Params["ObjectID"] ) )
    $ObjectID = $Params["ObjectID"];
$ObjectVersion = null;
if ( isset( $Params["ObjectVersion"] ) )
    $ObjectVersion = $Params["ObjectVersion"];
$object = eZContentObject::fetch( $ObjectID );

$isUpload = false;

$http = eZHTTPTool::instance();
$newObjectID = false;

$ini = eZINI::instance();

/*if ( $http->hasPostVariable( 'cancelButton' ) )
{
    // do nothing
}*/

if ( $http->hasPostVariable( 'uploadFile' ) )
{
    $isUpload = true;
}
else
{

    if ( $http->hasPostVariable( 'BrowseButton' ) )
    {
        eZContentBrowse::browse( array( 'action_name' => 'AddRelatedObjectToOE',
                                        'description_template' => 'design:ezdhtml/browse_related_object.tpl',
                                        'persistent_data' => array(),
                                        'from_page' => "ezdhtml/insertobject/$ObjectID/$ObjectVersion" ),
                                 $Module );
        //return;
    }
    if ( $http->hasPostVariable( 'BrowseActionName' ) and $http->postVariable( 'BrowseActionName' ) == 'AddRelatedObjectToOE' )
    {
        $selectedObjectIDArray = eZContentBrowse::result( 'AddRelatedObjectToOE' );
        if ( $selectedObjectIDArray != null )
        {
            $relatedObjects = $object->relatedContentObjectArray( $ObjectVersion );
            $relatedObjectIDArray = array();
            $objectID = $object->attribute( 'id' );

            foreach ( $relatedObjects as  $relatedObject )
                $relatedObjectIDArray[] = $relatedObject->attribute( 'id' );

            foreach ( $selectedObjectIDArray as $selectedObjectID )
            {
                if ( $selectedObjectID != $objectID && !in_array( $selectedObjectID, $relatedObjectIDArray ) )
                {
                    $object->addContentObjectRelation( $selectedObjectID, $ObjectVersion, 0, eZContentObject::RELATION_EMBED );
                    $newObjectID = $selectedObjectID;
                }
            }
        }
    }

    if ( $http->hasPostVariable( 'uploadButton' ) )
    {
        include_once( 'kernel/classes/ezcontentupload.php' );
        $upload = new eZContentUpload();
        $location = false;
        if ( $http->hasPostVariable( 'location' ) )
        {
            $location = $http->postVariable( 'location' );
        }

        $objectName = '';
        if ( $http->hasPostVariable( 'objectName' ) )
        {
            $objectName = $http->postVariable( 'objectName' );
        }
        $uploadedOk = $upload->handleUpload( $result, 'fileName', $location, false, $objectName );

        if ( $uploadedOk )
        {
            $newObject = $result['contentobject'];
            $newObjectID = $newObject->attribute( 'id' );

            $object->addContentObjectRelation( $newObjectID, $ObjectVersion, 0, eZContentObject::RELATION_EMBED );
        }
        else
        {
            $errors = $result['errors'];
        }
    }
    $contentIni = eZINI::instance( 'content.ini' );

    $classesVariableName = 'embed';

    if ( $contentIni->hasVariable( $classesVariableName, 'AvailableClasses' ) )
        $classList = $contentIni->variable( $classesVariableName, 'AvailableClasses' );
    else
        $classList = null;

    if ( $contentIni->hasVariable( 'embed-inline', 'AvailableClasses' ) )
        $classListInline = $contentIni->variable( 'embed-inline', 'AvailableClasses' );
    else
        $classListInline = null;

    $siteIni = eZINI::instance( 'site.ini' );
    if ( $siteIni->hasVariable( 'EmbedViewModeSettings', 'AvailableViewModes' ) )
    {
        $viewList = $siteIni->variable( 'EmbedViewModeSettings', 'AvailableViewModes' );
    }
    else
    {
        $viewList = null;
    }
    if ( $siteIni->hasVariable( 'EmbedViewModeSettings', 'InlineViewModes' ) )
    {
        $inlineViewList = $siteIni->variable( 'EmbedViewModeSettings', 'InlineViewModes' );
    }
    else
    {
        $inlineViewList = null;
    }

    $mediaRootID = $contentIni->variable( 'NodeSettings', 'MediaRootNode' );

    $relatedObjects = $object->relatedContentObjectArray( $ObjectVersion );

    $relatedObjectArray = array();
    $sizeTypeArray = array();
    $imageIni = eZINI::instance( 'image.ini' );
    if ( $imageIni->hasVariable( 'AliasSettings', 'AliasList' ) )
        $aliasList = $imageIni->variable( 'AliasSettings', 'AliasList' );

    if ( $aliasList != null )
    {
        foreach ( $aliasList as $alias )
        {
            if ( $aliasList != "original" )
            {
                $sizeTypeArray[] = $alias;
            }
        }
    }

    $sizeTypeArray[] = 'original';

    $URL = serverURL();

    $imageDatatypeArray = $siteIni->variable( "ImageDataTypeSettings", "AvailableImageDataTypes" );

    $groups = $contentIni->variable( 'RelationGroupSettings', 'Groups' );
    $defaultGroup = $contentIni->variable( 'RelationGroupSettings', 'DefaultGroup' );

    $groupedRelatedObjects = array();
    $groupClassLists = array();
    $classGroupMap = array();
    foreach ( $groups as $groupName )
    {
        $groupedRelatedObjects[$groupName] = array();
        $setting = strtoupper( $groupName[0] ) . substr( $groupName, 1 ) . 'ClassList';
        $groupClassLists[$groupName] = $contentIni->variable( 'RelationGroupSettings', $setting );
        foreach ( $groupClassLists[$groupName] as $classIdentifier )
        {
            $classGroupMap[$classIdentifier] = $groupName;
        }
    }
    $groupedRelatedObjects[$defaultGroup] = array();

    foreach ( $relatedObjects as $relatedObjectKey => $relatedObject )
    {
        $objectID = $relatedObject->attribute( 'id' );
        $objectIsSelected = false;
        $contentObjectAttributes = $relatedObject->contentObjectAttributes();
        foreach ( $contentObjectAttributes as $contentObjectAttribute )
        {
            $isImage = false;
            $classAttribute = $contentObjectAttribute->contentClassAttribute();
            $dataTypeString = $classAttribute->attribute( 'data_type_string' );
            if ( in_array ( $dataTypeString, $imageDatatypeArray ) )
            {
                $contentObjectAttributeID = $contentObjectAttribute->attribute( 'id' );
                $contentObjectAttributeVersion = $contentObjectAttribute->attribute( 'version' );
                $content = $contentObjectAttribute->content();

                if ( $content != null )
                {
                    $imageAlias = $content->imageAlias( 'small' );
                    $srcString = $URL . '/' . $imageAlias['url'];
                    $objectIDString = "id='eZObject_" . $objectID . "' src='" . $srcString . "'";
                    foreach ( $sizeTypeArray as $sizeType )
                    {
                        $imageAlias = $content->attribute( $sizeType );
                    }
                    if ( $newObjectID == $objectID )
                    {
                        $objectIsSelected = true;
                    }
                    $isImage = true;
                }
                else
                {
                    $objectIDString = "id='eZObject_" . $objectID . "' src=''";
                }
            }
            else
            {
                $imgSrc = $URL . "/";
                $imgSrc .= extension_path( 'ezdhtml', false, false, false );
                $imgSrc .= '/design/standard/images/ezdhtml/object_insert.png';
                $objectIDString = "id='eZObject_" . $objectID . "' src='" . $imgSrc  . "'";
                if ( $newObjectID == $objectID )
                {
                    $objectIsSelected = true;
                }
            }
            if ( count( $relatedObjects ) == 1 )
            {
                $objectIsSelected = true;
            }
            $item = array( "RelatedObject" => $relatedObjects[$relatedObjectKey],
                           "ObjectIDString" => $objectIDString,
                           "ObjectIsSelected" => $objectIsSelected );
            if ( $isImage )
            {
                break;
            }
        }
        $classIdentifier = $relatedObject->attribute( 'class_identifier' );
        if ( isset( $classGroupMap[$classIdentifier] ) )
        {
            $groupName = $classGroupMap[$classIdentifier];
            $groupedRelatedObjects[$groupName][] = $item;
        }
        else
        {
            $groupedRelatedObjects[$defaultGroup][] = $item;
        }
    }
}

$Module->setTitle( "Insert Object" );

$tpl = templateInit();

$tpl->setVariable( "module", $Module );
$tpl->setVariable( "object_id", $ObjectID );
$tpl->setVariable( "object_version", $ObjectVersion );
$tpl->setVariable( 'is_upload', $isUpload );

if ( !$isUpload )
{
    // Create custom attributes list

    getCustomAttributes( 'embed', $embedAttributes, $embedAttrDefaults );
    getCustomAttributes( 'embed-inline', $embedInlineAttributes, $embedInlineAttrDefaults );

    $tpl->setVariable( "embed_attributes", $embedAttributes );
    $tpl->setVariable( "embed_defaults", $embedAttrDefaults );

    $tpl->setVariable( "embed_inline_attributes", $embedInlineAttributes );
    $tpl->setVariable( "embed_inline_defaults", $embedInlineAttrDefaults );

    $tpl->setVariable( "class_list", $classList );
    $tpl->setVariable( "class_list_inline", $classListInline );
    $tpl->setVariable( "view_list", $viewList );
    $tpl->setVariable( "inline_view_list", $inlineViewList );
    $tpl->setVariable( "object_array", $relatedObjectArray );
    $tpl->setVariable( "size_type_list", $sizeTypeArray );

    $contentIni = eZINI::instance( 'content.ini' );
    $defaultSize = $contentIni->variable( 'ImageSettings', 'DefaultEmbedAlias' );
    $tpl->setVariable( "default_size", $defaultSize );

    $tpl->setVariable( 'related_contentobjects', $relatedObjects );
    $tpl->setVariable( 'grouped_related_contentobjects', $groupedRelatedObjects );

    $tpl->setVariable( "ezpublish_version", $eZPublishVersion );
}
else
{
    $tpl->setVariable( 'support_object_naming', true );
}

$Result = array();
$userAgent = eZSys::serverVariable( 'HTTP_USER_AGENT' );
if ( preg_match ("/gecko/i", $userAgent ) )
{
    $Result['content'] = $tpl->fetch( "design:ezdhtml/insertobject_gecko.tpl" );
}
else
{
    $Result['content'] = $tpl->fetch( "design:ezdhtml/insertobject.tpl" );
}
$Result['path'] = array( array( 'url' => '/ezdhtml/insertobject',
                                'text' => 'Insert object' ) );
?>
