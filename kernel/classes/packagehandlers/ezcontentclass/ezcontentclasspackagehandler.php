<?php
//
// Definition of eZContentClassPackageHandler class
//
// Created on: <23-Jul-2003 16:11:42 amos>
//
// SOFTWARE NAME: eZ Publish
// SOFTWARE RELEASE: 4.0.1
// BUILD VERSION: 22260
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
//

/*! \file ezcontentclasspackagehandler.php
*/

/*!
  \class eZContentClassPackageHandler ezcontentclasspackagehandler.php
  \brief Handles content classes in the package system

*/

//include_once( 'kernel/classes/ezcontentclass.php' );
//include_once( 'kernel/classes/ezpackagehandler.php' );

class eZContentClassPackageHandler extends eZPackageHandler
{
    const ERROR_EXISTS = 1;
    const ERROR_HAS_OBJECTS = 101;

    const ACTION_REPLACE = 1;
    const ACTION_SKIP = 2;
    const ACTION_NEW = 3;
    const ACTION_DELETE = 4;

    /*!
     Constructor
    */
    function eZContentClassPackageHandler()
    {
        $this->eZPackageHandler( 'ezcontentclass',
                                 array( 'extract-install-content' => true ) );
    }

    /*!
     \reimp
     Returns an explanation for the content class install item.
     Use $requestedInfo to request portion of info.
    */
    function explainInstallItem( $package, $installItem, $requestedInfo = array( 'name', 'identifier', 'description', 'language_info' ) )
    {
        if ( $installItem['filename'] )
        {
            $explainClassName = in_array( 'name', $requestedInfo );
            $explainClassIdentitier = in_array( 'identifier', $requestedInfo );
            $explainDescription = in_array( 'description', $requestedInfo );
            $explainLanguageInfo = in_array( 'language_info', $requestedInfo );

            $filename = $installItem['filename'];
            $subdirectory = $installItem['sub-directory'];
            if ( $subdirectory )
                $filepath = $subdirectory . '/' . $filename . '.xml';
            else
                $filepath = $filename . '.xml';

            $filepath = $package->path() . '/' . $filepath;

            $dom = $package->fetchDOMFromFile( $filepath );
            if ( $dom )
            {
                $languageInfo = array();

                $content = $dom->documentElement;
                $classIdentifier = $explainClassIdentitier ? $content->getElementsByTagName( 'identifier' )->item( 0 )->textContent : '';

                $className = '';
                if ( $explainClassName )
                {
                    // BC ( <= 3.8 )
                    $classNameNode = $content->getElementsByTagName( 'name' )->item( 0 );

                    if( $classNameNode )
                    {
                        $className = $classNameNode->textContent;
                    }
                    else
                    {
                        // get info about translations.
                        $serializedNameListNode = $content->getElementsByTagName( 'serialized-name-list' )->item( 0 );
                        if( $serializedNameListNode )
                        {
                            $serializedNameList = $serializedNameListNode->textContent;
                            $nameList = new eZContentClassNameList( $serializedNameList );
                            $languageInfo = $explainLanguageInfo ? $nameList->languageLocaleList() : array();
                            $className = $nameList->name();
                        }
                    }
                }

                $description = $explainDescription ? ezi18n( 'kernel/package', "Content class '%classname' (%classidentifier)", false,
                                                             array( '%classname' => $className,
                                                                    '%classidentifier' => $classIdentifier ) ) : '';
                $explainInfo = array( 'description' => $description,
                                      'language_info' => $languageInfo );
                return $explainInfo;
            }
        }
    }

    /*!
     \reimp
     Uninstalls all previously installed content classes.
    */
    function uninstall( $package, $installType, $parameters,
                      $name, $os, $filename, $subdirectory,
                      $content, &$installParameters,
                      &$installData )
    {
        $classRemoteID = $content->getElementsByTagName( 'remote-id' )->item( 0 )->textContent;

        $class = eZContentClass::fetchByRemoteID( $classRemoteID );

        if ( $class == null )
        {
            eZDebug::writeNotice( "Class having remote id '$classRemoteID' not found.", 'eZContentClassPackageHandler::uninstall()' );
            return true;
        }

        if ( $class->isRemovable() )
        {
            $choosenAction = $this->errorChoosenAction( self::ERROR_HAS_OBJECTS,
                                                        $installParameters, false, $this->HandlerType );
            if ( $choosenAction == self::ACTION_SKIP )
            {
                return true;
            }
            if ( $choosenAction != self::ACTION_DELETE )
            {
                $objectsCount = eZContentObject::fetchSameClassListCount( $class->attribute( 'id' ) );
                $name = $class->attribute( 'name' );
                if ( $objectsCount )
                {
                    $installParameters['error'] = array( 'error_code' => self::ERROR_HAS_OBJECTS,
                                                         'element_id' => $classRemoteID,
                                                         'description' => ezi18n( 'kernel/package',
                                                                                  "Removing class '%classname' will result in the removal of %objectscount object(s) of this class and all their sub-items. Are you sure you want to uninstall it?",
                                                                                  false,
                                                                                  array( '%classname' => $name,
                                                                                         '%objectscount' => $objectsCount ) ),
                                                         'actions' => array( self::ACTION_DELETE => "Uninstall class and object(s)",
                                                                             self::ACTION_SKIP => 'Skip' ) );
                    return false;
                }
            }

            eZDebug::writeNotice( sprintf( "Removing class '%s' (%d)", $class->attribute( 'name' ), $class->attribute( 'id' ) ) );

            //include_once( 'kernel/classes/ezcontentclassoperations.php' );
            eZContentClassOperations::remove( $class->attribute( 'id' ) );
        }

        return true;
    }

    /*!
     \reimp
     Creates a new contentclass as defined in the xml structure.
    */
    function install( $package, $installType, $parameters,
                      $name, $os, $filename, $subdirectory,
                      $content, &$installParameters,
                      &$installData )
    {
        $serializedNameListNode = $content->getElementsByTagName( 'serialized-name-list' )->item( 0 );
        $serializedNameList = $serializedNameListNode ? $serializedNameListNode->textContent : false;
        $classNameList = new eZContentClassNameList( $serializedNameList );
        if ( $classNameList->isEmpty() )
        {
            $classNameList->initFromString( $content->getElementsByTagName( 'name' )->item( 0 )->textContent ); // for backward compatibility( <= 3.8 )
        }
        $classNameList->validate( );

        $classIdentifier = $content->getElementsByTagName( 'identifier' )->item( 0 )->textContent;
        $classRemoteID = $content->getElementsByTagName( 'remote-id' )->item( 0 )->textContent;
        $classObjectNamePattern = $content->getElementsByTagName( 'object-name-pattern' )->item( 0 )->textContent;
        $classURLAliasPattern = is_object( $content->getElementsByTagName( 'url-alias-pattern' )->item( 0 ) ) ?
            $content->getElementsByTagName( 'url-alias-pattern' )->item( 0 )->textContent :
            null;
        $classIsContainer = $content->getAttribute( 'is-container' );
        if ( $classIsContainer !== false )
            $classIsContainer = $classIsContainer == 'true' ? 1 : 0;

        $classRemoteNode = $content->getElementsByTagName( 'remote' )->item( 0 );
        $classID = $classRemoteNode->getElementsByTagName( 'id' )->item( 0 )->textContent;
        $classGroupsNode = $classRemoteNode->getElementsByTagName( 'groups' )->item( 0 );
        $classCreated = $classRemoteNode->getElementsByTagName( 'created' )->item( 0 )->textContent;
        $classModified = $classRemoteNode->getElementsByTagName( 'modified' )->item( 0 )->textContent;
        $classCreatorNode = $classRemoteNode->getElementsByTagName( 'creator' )->item( 0 );
        $classModifierNode = $classRemoteNode->getElementsByTagName( 'modifier' )->item( 0 );

        $classAttributesNode = $content->getElementsByTagName( 'attributes' )->item( 0 );

        $dateTime = time();
        $classCreated = $dateTime;
        $classModified = $dateTime;

        $userID = false;
        if ( isset( $installParameters['user_id'] ) )
            $userID = $installParameters['user_id'];

        $class = eZContentClass::fetchByRemoteID( $classRemoteID );

        if ( $class )
        {
            $className = $class->name();
            $description = ezi18n( 'kernel/package', "Class '%classname' already exists.", false,
                                   array( '%classname' => $className ) );

            $choosenAction = $this->errorChoosenAction( self::ERROR_EXISTS,
                                                        $installParameters, $description, $this->HandlerType );
            switch( $choosenAction )
            {
            case eZPackage::NON_INTERACTIVE:
            case self::ACTION_REPLACE:
                //include_once( 'kernel/classes/ezcontentclassoperations.php' );
                if ( eZContentClassOperations::remove( $class->attribute( 'id' ) ) == false )
                {
                    eZDebug::writeWarning( "Unable to remove class '$className'." );
                    return true;
                }
                eZDebug::writeNotice( "Class '$className' will be replaced.", 'eZContentClassPackageHandler' );
                break;

            case self::ACTION_SKIP:
                return true;

            case self::ACTION_NEW:
                $class->setAttribute( 'remote_id', md5( (string)mt_rand() . (string)time() ) );
                $class->store();
                $classNameList->appendGroupName( " (imported)" );
                break;

            default:
                $installParameters['error'] = array( 'error_code' => self::ERROR_EXISTS,
                                                     'element_id' => $classRemoteID,
                                                     'description' => $description,
                                                     'actions' => array() );
                if ( $class->isRemovable() )
                {
                    $errorMsg = ezi18n( 'kernel/package', "Replace existing class" );
                    $objectsCount = eZContentObject::fetchSameClassListCount( $class->attribute( 'id' ) );
                    if ( $objectsCount )
                        $errorMsg .= ' ' . ezi18n( 'kernel/package', "(Warning! $objectsCount content object(s) and their sub-items will be removed)" );
                    $installParameters['error']['actions'][self::ACTION_REPLACE] = $errorMsg;
                }
                $installParameters['error']['actions'][self::ACTION_SKIP] = ezi18n( 'kernel/package', 'Skip installing this class' );
                $installParameters['error']['actions'][self::ACTION_NEW] = ezi18n( 'kernel/package', 'Keep existing and create a new one' );
                return false;
            }
        }

        unset( $class );

        // Try to create a unique class identifier
        $currentClassIdentifier = $classIdentifier;
        $unique = false;

        while( !$unique )
        {
            $classList = eZContentClass::fetchByIdentifier( $currentClassIdentifier );
            if ( $classList )
            {
                // "increment" class identifier
                if ( preg_match( '/^(.*)_(\d+)$/', $currentClassIdentifier, $matches ) )
                    $currentClassIdentifier = $matches[1] . '_' . ( $matches[2] + 1 );
                else
                    $currentClassIdentifier = $currentClassIdentifier . '_1';
            }
            else
                $unique = true;

            unset( $classList );
        }

        $classIdentifier = $currentClassIdentifier;

        // create class
        $class = eZContentClass::create( $userID,
                                         array( 'version' => 0,
                                                'serialized_name_list' => $classNameList->serializeNames(),
                                                'create_lang_if_not_exist' => true,
                                                'identifier' => $classIdentifier,
                                                'remote_id' => $classRemoteID,
                                                'contentobject_name' => $classObjectNamePattern,
                                                'url_alias_name' => $classURLAliasPattern,
                                                'is_container' => $classIsContainer,
                                                'created' => $classCreated,
                                                'modified' => $classModified ) );
        $class->store();

        $classID = $class->attribute( 'id' );

        if ( !isset( $installData['classid_list'] ) )
            $installData['classid_list'] = array();
        if ( !isset( $installData['classid_map'] ) )
            $installData['classid_map'] = array();
        $installData['classid_list'][] = $class->attribute( 'id' );
        $installData['classid_map'][$classID] = $class->attribute( 'id' );

        // create class attributes
        $classAttributeList = $classAttributesNode->getElementsByTagName( 'attribute' );
        foreach ( $classAttributeList as $classAttributeNode )
        {
            $isNotSupported = strtolower( $classAttributeNode->getAttribute( 'unsupported' ) ) == 'true';
            if ( $isNotSupported )
                continue;

            $attributeDatatype = $classAttributeNode->getAttribute( 'datatype' );
            $attributeIsRequired = strtolower( $classAttributeNode->getAttribute( 'required' ) ) == 'true';
            $attributeIsSearchable = strtolower( $classAttributeNode->getAttribute( 'searchable' ) ) == 'true';
            $attributeIsInformationCollector = strtolower( $classAttributeNode->getAttribute( 'information-collector' ) ) == 'true';
            $attributeIsTranslatable = strtolower( $classAttributeNode->getAttribute( 'translatable' ) ) == 'true';
            $attributeSerializedNameListNode = $classAttributeNode->getElementsByTagName( 'serialized-name-list' )->item( 0 );
            $attributeSerializedNameListContent = $attributeSerializedNameListNode ? $attributeSerializedNameListNode->textContent : false;
            $attributeSerializedNameList = new eZContentClassAttributeNameList( $attributeSerializedNameListContent );
            if ( $attributeSerializedNameList->isEmpty() )
                $attributeSerializedNameList->initFromString( $classAttributeNode->getElementsByTagName( 'name' )->item( 0 )->textContent ); // for backward compatibility( <= 3.8 )
            $attributeSerializedNameList->validate( );
            $attributeIdentifier = $classAttributeNode->getElementsByTagName( 'identifier' )->item( 0 )->textContent;
            $attributePlacement = $classAttributeNode->getElementsByTagName( 'placement' )->item( 0 )->textContent;
            $attributeDatatypeParameterNode = $classAttributeNode->getElementsByTagName( 'datatype-parameters' )->item( 0 );

            $classAttribute = $class->fetchAttributeByIdentifier( $attributeIdentifier );
            if ( !$classAttribute )
            {
                $classAttribute = eZContentClassAttribute::create( $class->attribute( 'id' ),
                                                                   $attributeDatatype,
                                                                   array( 'version' => 0,
                                                                          'identifier' => $attributeIdentifier,
                                                                          'serialized_name_list' => $attributeSerializedNameList->serializeNames(),
                                                                          'is_required' => $attributeIsRequired,
                                                                          'is_searchable' => $attributeIsSearchable,
                                                                          'is_information_collector' => $attributeIsInformationCollector,
                                                                          'can_translate' => $attributeIsTranslatable,
                                                                          'placement' => $attributePlacement ) );

                $dataType = $classAttribute->dataType();
                $classAttribute->store();
                $dataType->unserializeContentClassAttribute( $classAttribute, $classAttributeNode, $attributeDatatypeParameterNode );
                $classAttribute->sync();
            }
        }

        // add class to a class group
        $classGroupsList = $classGroupsNode->getElementsByTagName( 'group' );
        foreach ( $classGroupsList as $classGroupNode )
        {
            $classGroupName = $classGroupNode->getAttribute( 'name' );
            $classGroup = eZContentClassGroup::fetchByName( $classGroupName );
            if ( !$classGroup )
            {
                $classGroup = eZContentClassGroup::create();
                $classGroup->setAttribute( 'name', $classGroupName );
                $classGroup->store();
            }
            $classGroup->appendClass( $class );
        }
        return true;
    }

    /*!
     \reimp
    */
    function add( $packageType, $package, $cli, $parameters )
    {
        foreach ( $parameters['class-list'] as $classItem )
        {
            $classID = $classItem['id'];
            $classIdentifier = $classItem['identifier'];
            $classValue = $classItem['value'];
            $cli->notice( "Adding class $classValue to package" );
            $this->addClass( $package, $classID, $classIdentifier );
        }
    }

    /*!
     \static
     Adds the content class with ID \a $classID to the package.
     If \a $classIdentifier is \c false then it will be fetched from the class.
    */
    static function addClass( $package, $classID, $classIdentifier = false )
    {
        $class = false;
        if ( is_numeric( $classID ) )
            $class = eZContentClass::fetch( $classID );
        if ( !$class )
            return;
        $classNode = eZContentClassPackageHandler::classDOMTree( $class );
        if ( !$classNode )
            return;
        if ( !$classIdentifier )
            $classIdentifier = $class->attribute( 'identifier' );
        $package->appendInstall( 'ezcontentclass', false, false, true,
                                 'class-' . $classIdentifier, 'ezcontentclass',
                                 array( 'content' => $classNode ) );
        $package->appendProvides( 'ezcontentclass', 'contentclass', $class->attribute( 'identifier' ) );
        $package->appendInstall( 'ezcontentclass', false, false, false,
                                 'class-' . $classIdentifier, 'ezcontentclass',
                                 array( 'content' => false ) );
    }

    /*!
     \reimp
    */
    function handleAddParameters( $packageType, $package, $cli, $arguments )
    {
        return $this->handleParameters( $packageType, $package, $cli, 'add', $arguments );
    }

    /*!
     \private
    */
    function handleParameters( $packageType, $package, $cli, $type, $arguments )
    {
        $classList = false;
        foreach ( $arguments as $argument )
        {
            if ( $argument[0] == '-' )
            {
                if ( strlen( $argument ) > 1 and
                     $argument[1] == '-' )
                {
                }
                else
                {
                }
            }
            else
            {
                if ( $classList === false )
                {
                    $classList = array();
                    $classArray = explode( ',', $argument );
                    $error = false;
                    foreach ( $classArray as $classID )
                    {
                        if ( in_array( $classID, $classList ) )
                        {
                            $cli->notice( "Content class $classID already in list" );
                            continue;
                        }
                        if ( is_numeric( $classID ) )
                        {
                            if ( !eZContentClass::exists( $classID, 0, false, false ) )
                            {
                                $cli->error( "Content class with ID $classID does not exist" );
                                $error = true;
                            }
                            else
                            {
                                unset( $class );
                                $class = eZContentClass::fetch( $classID );
                                $classList[] = array( 'id' => $classID,
                                                      'identifier' => $class->attribute( 'identifier' ),
                                                      'value' => $classID );
                            }
                        }
                        else
                        {
                            $realClassID = eZContentClass::exists( $classID, 0, false, true );
                            if ( !$realClassID )
                            {
                                $cli->error( "Content class with identifier $classID does not exist" );
                                $error = true;
                            }
                            else
                            {
                                unset( $class );
                                $class = eZContentClass::fetch( $realClassID );
                                $classList[] = array( 'id' => $realClassID,
                                                      'identifier' => $class->attribute( 'identifier' ),
                                                      'value' => $classID );
                            }
                        }
                    }
                    if ( $error )
                        return false;
                }
            }
        }
        if ( $classList === false )
        {
            $cli->error( "No class ids chosen" );
            return false;
        }
        return array( 'class-list' => $classList );
    }

    /*!
     \static
     Creates the DOM tree for the content class \a $class and returns the root node.
    */
    static function classDOMTree( $class )
    {
        if ( !$class )
        {
            $retValue = false;
            return $retValue;
        }

        $dom = new DOMDocument( '1.0', 'utf-8' );
        $classNode = $dom->createElement( 'content-class' );
        $dom->appendChild( $classNode );
        $serializedNameListNode = $dom->createElement( 'serialized-name-list', $class->attribute( 'serialized_name_list' ) );
        $classNode->appendChild( $serializedNameListNode );
        $identifierNode = $dom->createElement( 'identifier', $class->attribute( 'identifier' ) );
        $classNode->appendChild( $identifierNode );
        $remoteIDNode = $dom->createElement( 'remote-id', $class->attribute( 'remote_id' ) );
        $classNode->appendChild( $remoteIDNode );
        $objectNamePatternNode = $dom->createElement( 'object-name-pattern', $class->attribute( 'contentobject_name' ) );
        $classNode->appendChild( $objectNamePatternNode );
        $urlAliasPatternNode = $dom->createElement( 'url-alias-pattern', $class->attribute( 'url_alias_name' ) );
        $classNode->appendChild( $urlAliasPatternNode );
        $isContainer = $class->attribute( 'is_container' ) ? 'true' : 'false';
        $classNode->setAttribute( 'is-container', $isContainer );

        // Remote data start
        $remoteNode = $dom->createElement( 'remote' );
        $classNode->appendChild( $remoteNode );

        $ini = eZINI::instance();
        $siteName = $ini->variable( 'SiteSettings', 'SiteURL' );

        $classURL = 'http://' . $siteName . '/class/view/' . $class->attribute( 'id' );
        $siteURL = 'http://' . $siteName . '/';

        $remoteNode->appendChild( $dom->createElement( 'site-url', $siteURL ) );
        $remoteNode->appendChild( $dom->createElement( 'url', $classURL ) );

        $classGroupsNode = $dom->createElement( 'groups' );

        $classGroupList = eZContentClassClassGroup::fetchGroupList( $class->attribute( 'id' ),
                                                                    $class->attribute( 'version' ) );
        foreach ( $classGroupList as $classGroupLink )
        {
            $classGroup = eZContentClassGroup::fetch( $classGroupLink->attribute( 'group_id' ) );
            if ( $classGroup )
            {
                unset( $groupNode );
                $groupNode = $dom->createElement( 'group' );
                $groupNode->setAttribute( 'id', $classGroup->attribute( 'id' ) );
                $groupNode->setAttribute( 'name', $classGroup->attribute( 'name' ) );
                $classGroupsNode->appendChild( $groupNode );
            }
        }
        $remoteNode->appendChild( $classGroupsNode );

        $idNode = $dom->createElement( 'id', $class->attribute( 'id' ) );
        $remoteNode->appendChild( $idNode );
        $createdNode = $dom->createElement( 'created', $class->attribute( 'created' ) );
        $remoteNode->appendChild( $createdNode );
        $modifiedNode = $dom->createElement( 'modified', $class->attribute( 'modified' ) );
        $remoteNode->appendChild( $modifiedNode );

        $creatorNode = $dom->createElement( 'creator' );
        $remoteNode->appendChild( $creatorNode );
        $creatorIDNode = $dom->createElement( 'user-id', $class->attribute( 'creator_id' ) );
        $creatorNode->appendChild( $creatorIDNode );
        $creator = $class->attribute( 'creator' );
        if ( $creator )
        {
            $creatorLoginNode = $dom->createElement( 'user-login', $creator->attribute( 'login' ) );
            $creatorNode->appendChild( $creatorLoginNode );
        }

        $modifierNode = $dom->createElement( 'modifier' );
        $remoteNode->appendChild( $modifierNode );
        $modifierIDNode = $dom->createElement( 'user-id', $class->attribute( 'modifier_id' ) );
        $modifierNode->appendChild( $modifierIDNode );
        $modifier = $class->attribute( 'modifier' );
        if ( $modifier )
        {
            $modifierLoginNode = $dom->createElement( 'user-login', $modifier->attribute( 'login' ) );
            $modifierNode->appendChild( $modifierLoginNode );
        }
        // Remote data end

        $attributesNode = $dom->createElementNS( 'http://ezpublish/contentclassattribute', 'ezcontentclass-attribute:attributes' );
        $classNode->appendChild( $attributesNode );

        $attributes = $class->fetchAttributes();
        foreach( $attributes as $attribute )
        {
            $attributeNode = $dom->createElement( 'attribute' );
            $attributeNode->setAttribute( 'datatype', $attribute->attribute( 'data_type_string' ) );
            $required = $attribute->attribute( 'is_required' ) ? 'true' : 'false';
            $attributeNode->setAttribute( 'required' , $required );
            $searchable = $attribute->attribute( 'is_searchable' ) ? 'true' : 'false';
            $attributeNode->setAttribute( 'searchable' , $searchable );
            $informationCollector = $attribute->attribute( 'is_information_collector' ) ? 'true' : 'false';
            $attributeNode->setAttribute( 'information-collector' , $informationCollector );
            $translatable = $attribute->attribute( 'can_translate' ) ? 'true' : 'false';
            $attributeNode->setAttribute( 'translatable' , $translatable );

            $attributeRemoteNode = $dom->createElement( 'remote' );
            $attributeNode->appendChild( $attributeRemoteNode );

            $attributeIDNode = $dom->createElement( 'id', $attribute->attribute( 'id' ) );
            $attributeRemoteNode->appendChild( $attributeIDNode );

            $attributeSerializedNameListNode = $dom->createElement( 'serialized-name-list', $attribute->attribute( 'serialized_name_list' ) );
            $attributeNode->appendChild( $attributeSerializedNameListNode );

            $attributeIdentifierNode = $dom->createElement( 'identifier', $attribute->attribute( 'identifier' ) );
            $attributeNode->appendChild( $attributeIdentifierNode );

            $attributePlacementNode = $dom->createElement( 'placement', $attribute->attribute( 'placement' ) );
            $attributeNode->appendChild( $attributePlacementNode );

            $attributeParametersNode = $dom->createElement( 'datatype-parameters' );
            $attributeNode->appendChild( $attributeParametersNode );

            $dataType = $attribute->dataType();
            if ( is_object( $dataType ) )
            {
                $dataType->serializeContentClassAttribute( $attribute, $attributeNode, $attributeParametersNode );
            }

            $attributesNode->appendChild( $attributeNode );
        }
        eZDebug::writeDebug( $dom->saveXML(), 'content class package XML' );
        return $classNode;
    }

    function contentclassDirectory()
    {
        return 'ezcontentclass';
    }
}

?>
