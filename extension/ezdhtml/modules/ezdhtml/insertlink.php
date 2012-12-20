<?php
//
//
// SOFTWARE NAME: eZ Online Editor
// SOFTWARE RELEASE: 4.1.4
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
include_once( "lib/ezutils/classes/ezini.php" );
include_once( 'kernel/classes/ezcontentbrowse.php' );
require_once( 'kernel/common/i18n.php' );

include_once( 'lib/version.php' );
$eZPublishVersion = eZPublishSDK::majorVersion() + eZPublishSDK::minorVersion() * 0.1;

include_once( 'extension/ezdhtml/lib/commonfunctions.php' );

$ini = eZINI::instance( 'content.ini' );
if ( $ini->hasVariable( 'link', 'AvailableClasses' ) )
{
    $classList = $ini->variable( 'link', 'AvailableClasses' );
}
else
{
    $classList = null;
}

$siteIni = eZINI::instance( 'site.ini' );
if ( $siteIni->hasVariable( 'LinkViewModeSettings', 'AvailableViewModes' ) )
{
    $viewList = $siteIni->variable( 'LinkViewModeSettings', 'AvailableViewModes' );
}
else
{
    $viewList = null;
}

$module = $Params["Module"];

$http = eZHTTPTool::instance();

// Do we insert a new link or display parameters ?
if ( $http->hasVariable( 'isNew' ) )
    $isAddingNewLink = $http->variable( 'isNew' );
else
    $isAddingNewLink = $Params["New"];

if ( $http->hasPostVariable( 'BrowseButton' ) )
{
    $browseArray = $http->postVariable( 'BrowseButton' );
    if ( preg_match( "/node/", key( $browseArray ) ) )
        $browseType = "BrowseNode";
    if ( preg_match( "/object/", key( $browseArray ) ) )
        $browseType = "BrowseObject";
    $linkText = $http->postVariable( 'linkText' );
    $linkClass = $http->postVariable( 'linkClass' );
    $linkTitle = $http->postVariable( 'linkTitle' );
    $linkID = $http->postVariable( 'linkID' );

    if ( $http->hasPostVariable( 'linkWindow' ) )
    {
        $linkWindow = true;
    }
    else
    {
        $linkWindow = false;
    }

    if ( $browseType == "BrowseNode" )
    {
        eZContentBrowse::browse( array( 'action_name' => 'SelectLinkNodeID',
                                        'description_template' => 'design:ezdhtml/browse_node.tpl',
                                        'persistent_data' => array( 'linkText' => $linkText,
                                                                    'linkClass' => $linkClass,
                                                                    'linkTitle' => $linkTitle,
                                                                    'linkID' => $linkID,
                                                                    'linkWindow' => $linkWindow,
                                                                    'isNew' => $isAddingNewLink ),
                                        'from_page' => "/ezdhtml/insertlink/" ),
                                 $module );
        return;
    }

    if ( $browseType == "BrowseObject" )
    {
        eZContentBrowse::browse( array( 'action_name' => 'SelectLinkObjectID',
                                        'description_template' => 'design:ezdhtml/browse_object.tpl',
                                        'persistent_data' => array( 'linkText' => $linkText,
                                                                    'linkClass' => $linkClass,
                                                                    'linkTitle' => $linkTitle,
                                                                    'linkID' => $linkID,
                                                                    'linkWindow' => $linkWindow,
                                                                    'isNew' => $isAddingNewLink ),
                                        'from_page' => "/layout/set/dialog/ezdhtml/insertlink/" ),
                                 $module );
        return;
    }
}

$linkText = "";
$linkURL = "";
$linkClass = "";
$linkType = "";
$linkTitle = "";
$linkID = "";
$linkWindow = "";

$browseActionName = false;

if ( $http->hasPostVariable( 'BrowseActionName' ) and
     ( $http->postVariable( 'BrowseActionName' ) == 'SelectLinkNodeID' or
       $http->postVariable( 'BrowseActionName' ) == 'SelectLinkObjectID' ) )
{
    if ( $http->postVariable( 'BrowseActionName' ) == 'SelectLinkNodeID' )
    {
        $selectedNodeIDArray = eZContentBrowse::result( 'SelectLinkNodeID' );
        $nodeID = $selectedNodeIDArray[0];
        $linkURL = "eznode://";
        if ( is_numeric( $nodeID ) )
        {
            $linkURL = "eznode://" . $nodeID;
        }
        $linkType = "eznode://";
        $browseActionName = "browseNode";
    }

    if ( $http->postVariable( 'BrowseActionName' ) == 'SelectLinkObjectID' )
    {
        $selectedObjectIDArray = eZContentBrowse::result( 'SelectLinkObjectID' );
        $objectID = $selectedObjectIDArray[0];
        $linkURL = "ezobject://";
        if ( is_numeric( $objectID ) )
        {
            $linkURL = "ezobject://" . $objectID;
        }
        $linkType = "ezobject://";
        $browseActionName = "browseObject";
    }

    $linkText = $http->variable( 'linkText' );
    $linkClass = $http->variable( 'linkClass' );
    $linkTitle = $http->variable( 'linkTitle' );
    $linkID = $http->variable( 'linkID' );
    $linkWindow = $http->variable( 'linkWindow' );
    $isAddingNewLink = $http->variable( 'isNew' );
}

if ( $isAddingNewLink )
    $title = ezx18n( 'extension/ezdhtml', 'design/standard/ezdhtml', 'Insert link' );
else
    $title = ezx18n( 'extension/ezdhtml', 'design/standard/ezdhtml', 'Link properties' );

$module->setTitle( $title );

$tpl = templateInit();

getCustomAttributes( 'link', $customAttributes, $customDefaults );
$tpl->setVariable( "custom_attributes", $customAttributes );
$tpl->setVariable( "custom_defaults", $customDefaults );

$tpl->setVariable( "class_list", $classList );
$tpl->setVariable( "view_list", $viewList );
//$tpl->setVariable( "module", $module );
$tpl->setVariable( "link_class", $linkClass );
$tpl->setVariable( "link_text", $linkText );
$tpl->setVariable( "link_url", $linkURL );
$tpl->setVariable( "link_type", $linkType );
$tpl->setVariable( "link_title", $linkTitle );
$tpl->setVariable( "link_id", $linkID );
$tpl->setVariable( "link_window", $linkWindow );
$tpl->setVariable( "browse_action_name", $browseActionName );

$tpl->setVariable( "ezpublish_version", $eZPublishVersion );
$tpl->setVariable( "is_new", $isAddingNewLink );

$Result = array();
$userAgent = eZSys::serverVariable( 'HTTP_USER_AGENT' );
if ( preg_match ("/gecko/i", $userAgent ) )
{
    $Result['content'] = $tpl->fetch( "design:ezdhtml/insertlink_gecko.tpl" );
}
else
{
    $Result['content'] = $tpl->fetch( "design:ezdhtml/insertlink.tpl" );
}
$Result['path'] = array( array( 'url' => '/ezdhtml/insertlink/',
                                'text' => $title ) );
?>
