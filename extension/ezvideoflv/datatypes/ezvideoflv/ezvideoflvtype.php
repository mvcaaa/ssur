<?php

//
// SOFTWARE NAME: eZ Video FLV
// SOFTWARE RELEASE: 0.2
// COPYRIGHT NOTICE: Copyright (C) 1999-2006 eZ Systems AS
// 								   2007 Damien POBEL
// BASED ON: ezmediatype.php from eZ Publish 3.10rc1
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

/*!
  \class eZVideoFLVType ezvideoflvtype.php
  \ingroup eZDatatype
  \brief The class eZVideoFLVType handles storage, convertion to flv and playback of media files

*/
include_once( 'extension/ezvideoflv/datatypes/ezvideoflv/ezvideoflv.php' );

class eZVideoFLVType extends eZDataType
{
    const VIDEOFLV = 'ezvideoflv';
    const MAX_VIDEOFLV_FILESIZE_FIELD = 'data_int1';
    const MAX_VIDEOFLV_FILESIZE_VARIABLE = '_ezvideoflv_max_filesize_';

    function eZVideoFLVType()
    {
        $this->eZDataType( eZVideoFLVType::VIDEOFLV, ezi18n( 'kernel/classes/datatypes', "Video FLV", 'Datatype name' ),
                           array( 'serialize_supported' => true ) );
    }


    /*!
     Sets value according to current version
    */
    function postInitializeObjectAttribute( $contentObjectAttribute, $currentVersion, $originalContentObjectAttribute )
    {
        if ( $currentVersion != false )
        {
            $contentObjectAttributeID = $originalContentObjectAttribute->attribute( "id" );
            $version = $contentObjectAttribute->attribute( "version" );
            $oldfile = eZVideoFLV::fetchVideo( $contentObjectAttributeID, $currentVersion );
            if( $oldfile != null )
            {
                $oldfile->setAttribute( 'contentobject_attribute_id', $contentObjectAttribute->attribute( 'id' ) );
                $oldfile->setAttribute( "version",  $version );
                $oldfile->store();
            }
        }
        else
        {
            $contentObjectAttributeID = $contentObjectAttribute->attribute( 'id' );
            $version = $contentObjectAttribute->attribute( 'version' );

            $video = eZVideoFLV::create( $contentObjectAttributeID, $version );

            $contentClassAttribute = $contentObjectAttribute->contentClassAttribute();
            $video->store();
        }
    }

    /*!
     Delete stored attribute
    */
    function deleteStoredObjectAttribute( $contentObjectAttribute, $version = null )
    {
        $contentObjectAttributeID = $contentObjectAttribute->attribute( "id" );
        $mediaFiles = eZVideoFLV::fetchVideo( $contentObjectAttributeID, null );
        $storage_dir = eZSys::storageDirectory();
        if ( $version == null )
        {
			// delete all versions
			//require_once( 'kernel/classes/ezclusterfilehandler.php' );
			$iniVideo = eZINI::instance( 'ezvideoflv.ini' );
			$preview_dir = $orig_dir . '/' . $iniVideo->variable( 'Preview', 'Path' );
			$format = strtolower( $iniVideo->variable( 'Preview', 'Format' ) );

            foreach ( $mediaFiles as $mediaFile )
            {
                $mimeType =  $mediaFile->attribute( "mime_type" );
                list( $prefix, $suffix ) = split ('[/]', $mimeType );
                $orig_dir = $storage_dir . '/original/' . $prefix;

                $fileName = $mediaFile->attribute( "filename" );
                if ( $fileName != '' )
				{
					// VS-DBFILE
					$file = eZClusterFileHandler::instance( $orig_dir . "/" . $fileName );
					if ( $file->exists() )
						$file->delete();
					$preview_file = $preview_dir . '/' . $fileName . '.' . $format;
					$file = eZClusterFileHandler::instance( $preview_file );
					if ( $file->exists() )
						$file->delete();
				}

				$fileNameFLV = $mediaFile->attribute( 'flv' );
                if ( $fileNameFLV == '' )
                    continue;
                $fileflv = eZClusterFileHandler::instance( $orig_dir . "/" . $fileNameFLV );
                if ( $fileflv->exists() )
                    $fileflv->delete();
            }
        }
        else
        {
            $count = 0;
            $currentBinaryFile = eZVideoFLV::fetchVideo( $contentObjectAttributeID, $version );
            if ( $currentBinaryFile != null )
            {
                $mimeType =  $currentBinaryFile->attribute( "mime_type" );
                $currentFileName = $currentBinaryFile->attribute( "filename" );
				$currentFileNameFLV = $currentBinaryFile->attribute( 'flv' );
                list( $prefix, $suffix ) = is_string( $mimeType ) && $mimeType ? split ( '[/]', $mimeType ) : array( null, null );
                $orig_dir = $storage_dir . '/original/' . $prefix;
                foreach ( $mediaFiles as $mediaFile )
                {
                    $fileName = $mediaFile->attribute( "filename" );
					$fileNameFLV = $mediaFile->attribute( 'flv' );
                    if( ( $currentFileName == $fileName ) && ( $currentFileNameFLV == $fileNameFLV ) )
                        $count += 1;
                }
                if ( $count == 1 && $currentFileName != '' && $currentFileNameFLV != '' )
                {
					$iniVideo = eZINI::instance( 'ezvideoflv.ini' );
					$preview_dir = $orig_dir . '/' . $iniVideo->variable( 'Preview', 'Path' );
					$format = strtolower( $iniVideo->variable( 'Preview', 'Format' ) );
					$preview_file = $preview_dir . '/' . $currentFileName . '.' . $format;
                    // VS-DBFILE
                    //require_once( 'kernel/classes/ezclusterfilehandler.php' );
                    $file = eZClusterFileHandler::instance( $orig_dir . "/" . $currentFileName );
                    if ( $file->exists() )
                        $file->delete();
                    $file = eZClusterFileHandler::instance( $orig_dir . "/" . $currentFileNameFLV );
                    if ( $file->exists() )
                        $file->delete();
					$file = eZClusterFileHandler::instance( $preview_file );
					if ( $file->exists() )
						$file->delete();
                }
            }
        }
        eZVideoFLV::removeVideo( $contentObjectAttributeID, $version );
    }

    /*!
     Validates the input and returns true if the input was
     valid for this datatype.
    */
    function validateObjectAttributeHTTPInput( $http, $base, $contentObjectAttribute )
    {
        $classAttribute = $contentObjectAttribute->contentClassAttribute();
        $httpFileName = $base . "_data_videoflvfilename_" . $contentObjectAttribute->attribute( "id" );
        $maxSize = 1024 * 1024 * $classAttribute->attribute( eZVideoFLVType::MAX_VIDEOFLV_FILESIZE_FIELD );
        $mustUpload = false;

        if ( $contentObjectAttribute->validateIsRequired() )
        {
            $contentObjectAttributeID = $contentObjectAttribute->attribute( "id" );
            $version = $contentObjectAttribute->attribute( "version" );
            $media = eZVideoFLV::fetchVideo( $contentObjectAttributeID, $version );
            if ( $media === null || !$media->attribute( 'filename' ) )
            {
                $mustUpload = true;
            }
        }

        $canFetchResult = eZHTTPFile::canFetch( $httpFileName, $maxSize );
        if ( $mustUpload && $canFetchResult == eZHTTPFile::UPLOADEDFILE_DOES_NOT_EXIST )
        {
            $contentObjectAttribute->setValidationError( ezi18n( 'kernel/classes/datatypes',
                'A valid media file is required.' ) );
            return eZInputValidator::STATE_INVALID;
        }
        if ( $canFetchResult == eZHTTPFile::UPLOADEDFILE_EXCEEDS_PHP_LIMIT )
        {
            $contentObjectAttribute->setValidationError( ezi18n( 'kernel/classes/datatypes',
                'The size of the uploaded file exceeds the limit set by upload_max_filesize directive in php.ini. Please contact the site administrator.') );
            return eZInputValidator::STATE_INVALID;
        }
        if ( $canFetchResult == eZHTTPFile::UPLOADEDFILE_EXCEEDS_MAX_SIZE )
        {
            $contentObjectAttribute->setValidationError( ezi18n( 'kernel/classes/datatypes',
                'The size of the uploaded file exceeds site maximum: %1 bytes.' ), $maxSize );
            return eZInputValidator::STATE_INVALID;
        }

        return eZInputValidator::STATE_ACCEPTED;
    }

    /*!
     Checks if file uploads are enabled, if not it gives a warning.
    */
    function checkFileUploads()
    {
        $isFileUploadsEnabled = ini_get( 'file_uploads' ) != 0;
        if ( !$isFileUploadsEnabled )
        {
            $isFileWarningAdded =& $GLOBALS['eZVideoFLVTypeWarningAdded'];
            if ( !isset( $isFileWarningAdded ) or
                 !$isFileWarningAdded )
            {
                eZAppendWarningItem( array( 'error' => array( 'type' => 'kernel',
                                                              'number' => eZError::KERNEL_NOT_AVAILABLE ),
                                            'text' => ezi18n( 'kernel/classes/datatypes',
                                                              'File uploading is not enabled. Please contact the site administrator to enable it.' ) ) );
                $isFileWarningAdded = true;
            }
        }
    }

    /*!
     Fetches input and stores it in the data instance.
    */
    function fetchObjectAttributeHTTPInput( $http, $base, $contentObjectAttribute )
    {
        eZVideoFLVType::checkFileUploads();

        $classAttribute = $contentObjectAttribute->contentClassAttribute();

        $contentObjectAttributeID = $contentObjectAttribute->attribute( "id" );
        $version = $contentObjectAttribute->attribute( "version" );

        $media = eZVideoFLV::fetchVideo( $contentObjectAttributeID, $version );
        if ( $media == null )
           $media = eZVideoFLV::create( $contentObjectAttributeID, $version );

        $media->setAttribute( "contentobject_attribute_id", $contentObjectAttributeID );
        $media->setAttribute( "version", $version );

        $mediaFilePostVarName = $base . "_data_videoflvfilename_" . $contentObjectAttribute->attribute( "id" );
        if ( eZHTTPFile::canFetch( $mediaFilePostVarName ) )
            $mediaFile = eZHTTPFile::fetch( $mediaFilePostVarName );
        else
            $mediaFile = null;

        if ( $mediaFile instanceof eZHTTPFile )
        {
            $mimeData = eZMimeType::findByFileContents( $mediaFile->attribute( "original_filename" ) );
            $mime = $mimeData['name'];

            if ( $mime == '' )
            {
                $mime = $mediaFile->attribute( "mime_type" );
            }
            $extension = preg_replace('/.*\.(.+?)$/', '\\1', $mediaFile->attribute( "original_filename" ) );
            $mediaFile->setMimeType( $mime );
            if ( !$mediaFile->store( "original", $extension ) )
            {
                eZDebug::writeError( "Failed to store http-file: " . $mediaFile->attribute( "original_filename" ),
                                     "eZVideoFLVType" );
                return false;
            }

            $orig_dir = $mediaFile->storageDir( "original" );
            $media->setAttribute( "filename", basename( $mediaFile->attribute( "filename" ) ) );
            $media->setAttribute( "original_filename", $mediaFile->attribute( "original_filename" ) );
            $media->setAttribute( "mime_type", $mime );


			$ffmpeg = eZVideoFLV::getFFMPEGObject( $mediaFile->attribute( "filename" ) );
			$width = $ffmpeg->getFrameWidth();
			$height = $ffmpeg->getFrameHeight();
			$media->setAttribute( "width", $width );
			$media->setAttribute( "height", $height );

			$flvFile = eZVideoFLV::convert( $mediaFile->attribute( 'filename'), $orig_dir );
			if ( is_null( $flvFile ) )
				$flvFile = '';

			$media->setAttribute( "flv", $flvFile );

            // VS-DBFILE
            //require_once( 'kernel/classes/ezclusterfilehandler.php' );
            $filePath = $mediaFile->attribute( 'filename' );
            $fileHandler = eZClusterFileHandler::instance();
            $fileHandler->fileStore( $filePath, 'media', true, $mime );
			if ( $flvFile != '' )
				$fileHandler->fileStore( $flvFile, 'media', true, 'video/x-flv' );
        }

        $media->store();
        $contentObjectAttribute->setContent( $media );
        return true;
    }

    function storeObjectAttribute( $contentObjectAttribute )
    {
    }

    function customObjectAttributeHTTPAction( $http, $action, $contentObjectAttribute, $parameters )
    {
        if ( $action == "delete_videoflv" )
        {
            $contentObjectAttributeID = $contentObjectAttribute->attribute( "id" );
            $version = $contentObjectAttribute->attribute( "version" );
            $this->deleteStoredObjectAttribute( $contentObjectAttribute, $version );
            $media = eZVideoFLV::create( $contentObjectAttributeID, $version );
            $contentObjectAttribute->setContent( $media );
        }
    }

    /*!
     \reimp
     HTTP file insertion is supported.
    */
    function isHTTPFileInsertionSupported()
    {
        return true;
    }

    /*!
     \reimp
     Regular file insertion is supported.
    */
    function isRegularFileInsertionSupported()
    {
        return true;
    }

    /*!
     \reimp
     Inserts the file using the eZVideoFLV class.
    */
    function insertHTTPFile( $object, $objectVersion, $objectLanguage,
                             $objectAttribute, $httpFile, $mimeData,
                             &$result )
    {
        $result = array( 'errors' => array(),
                         'require_storage' => false );
        $errors =& $result['errors'];
        $attributeID = $objectAttribute->attribute( 'id' );

        $media = eZVideoFLV::fetchVideo( $attributeID, $objectVersion );
        if ( $media === null )
            $media = eZVideoFLV::create( $attributeID, $objectVersion );

        $httpFile->setMimeType( $mimeData['name'] );
        if ( !$httpFile->store( "original", false, false ) )
        {
            $errors[] = array( 'description' => ezi18n( 'kernel/classes/datatypes/ezmedia',
                                                        'Failed to store media file %filename. Please contact the site administrator.', null,
                                                        array( '%filename' => $httpFile->attribute( "original_filename" ) ) ) );
            return false;
        }

        $classAttribute =& $objectAttribute->contentClassAttribute();

        $media->setAttribute( "contentobject_attribute_id", $attributeID );
        $media->setAttribute( "version", $objectVersion );
        $media->setAttribute( "filename", basename( $httpFile->attribute( "filename" ) ) );
        $media->setAttribute( "original_filename", $httpFile->attribute( "original_filename" ) );
        $media->setAttribute( "mime_type", $mimeData['name'] );
		$flvFile = eZVideoFLV::convert( $httpFile->attribute( 'filename' ), dirname( $httpFile->attribute( 'filename' ) ) );
		if ( is_null( $flvFile ) )
			$flvFile = '';


		$ffmpeg = eZVideoFLV::getFFMPEGObject( $http->attribute( 'filename' ) );
        $width = $ffmpeg->getFrameWidth();
		$height = $ffmpeg->getFrameHeight();

        $media->setAttribute( "width", $width );
        $media->setAttribute( "height", $height );
		$media->setAttribute( "flv", $flvFile );

        //require_once( 'kernel/classes/ezclusterfilehandler.php' );
        $filePath = $httpFile->attribute( 'filename' );
        $fileHandler = eZClusterFileHandler::instance();
        $fileHandler->fileStore( $filePath, 'mediafile', true, $mimeData['name'] );
		if ( $flvFile != '' )
		{
			$flvPath = dirname( $httpFile->attribute( 'filename' ) ). '/' . $flvFile;
			$fileHandler->fileStore( $flvPath, 'mediafile', true, 'video/x-flv' );
		}


        $media->store();

        $objectAttribute->setContent( $media );
        return true;
    }

    /*!
     \reimp
     Inserts the file using the eZVideoFLV class.
    */
    function insertRegularFile( $object, $objectVersion, $objectLanguage,
                                $objectAttribute, $filePath,
                                &$result )
    {
        $result = array( 'errors' => array(),
                         'require_storage' => false );
        $errors =& $result['errors'];
        $attributeID = $objectAttribute->attribute( 'id' );

        $media = eZVideoFLV::fetchVideo( $attributeID, $objectVersion );
        if ( $media === null )
            $media = eZVideoFLV::create( $attributeID, $objectVersion );

        $fileName = basename( $filePath );
        $mimeData = eZMimeType::findByFileContents( $filePath );
        $storageDir = eZSys::storageDirectory();
        list( $group, $type ) = explode( '/', $mimeData['name'] );
        $destination = $storageDir . '/original/' . $group;
		$destinationFLV = $destination;
        $oldumask = umask( 0 );
        if ( !eZDir::mkdir( $destination, false, true ) )
        {
            umask( $oldumask );
            return false;
        }
        umask( $oldumask );

        // create dest filename in the same manner as eZHTTPFile::store()
        // grab file's suffix
        $fileSuffix = eZFile::suffix( $fileName );
        // prepend dot
        if( $fileSuffix )
            $fileSuffix = '.' . $fileSuffix;
        // grab filename without suffix
        $fileBaseName = basename( $fileName, $fileSuffix );
        // create dest filename
        $destination = $destination . '/' . md5( $fileBaseName . microtime() . mt_rand() ) . $fileSuffix;

        copy( $filePath, $destination );
		$flvFile = eZVideoFLV::convert( $destination, $destinationFLV );

        // SP-DBFILE
        require_once( 'kernel/classes/ezclusterfilehandler.php' );
        $fileHandler = eZClusterFileHandler::instance();
        $fileHandler->fileStore( $destination, 'mediafile', true, $mimeData['name'] );
		if ( !is_null( $flvFile ) )
			$fileHandler->fileStore( $destinationFLV.'/'.$flvFile, 'mediafile', true, 'video/x-flv' );
		else
			$flvFile = '';

        $classAttribute =& $objectAttribute->contentClassAttribute();

        $media->setAttribute( "contentobject_attribute_id", $attributeID );
        $media->setAttribute( "version", $objectVersion );
        $media->setAttribute( "filename", basename( $destination ) );
        $media->setAttribute( "original_filename", $fileName );
        $media->setAttribute( "mime_type", $mimeData['name'] );
		$media->setAttribute( "flv", $flvFile );

		$ffmpeg = eZVideoFLV::getFFMPEGObject( $destination );
        $width = $ffmpeg->getFrameWidth();
		$height = $ffmpeg->getFrameHeight();

        $media->setAttribute( "width", $width );
        $media->setAttribute( "height", $height );

        $media->store();

        $objectAttribute->setContent( $media );
        return true;
    }

    /*!
      \reimp
      We support file information
    */
    function hasStoredFileInformation( $object, $objectVersion, $objectLanguage,
                                       $objectAttribute )
    {
        return true;
    }

    /*!
      \reimp
      Extracts file information for the media entry.
    */
    function storedFileInformation( $object, $objectVersion, $objectLanguage,
                                    $objectAttribute )
    {
        $mediaFile = eZVideoFLV::fetchVideo( $objectAttribute->attribute( "id" ),
                                      $objectAttribute->attribute( "version" ) );
        if ( $mediaFile )
        {
            return $mediaFile->storedFileInfo();
        }
        return false;
    }

    function storeClassAttribute( $attribute, $version )
    {
    }

    function storeDefinedClassAttribute( $attribute )
    {
    }

    /*!
     \reimp
    */
    function validateClassAttributeHTTPInput( $http, $base, $classAttribute )
    {
        return eZInputValidator::STATE_ACCEPTED;
    }

    /*!
     \reimp
    */
    function fixupClassAttributeHTTPInput( $http, $base, $classAttribute )
    {
    }

    /*!
     \reimp
    */
    function fetchClassAttributeHTTPInput( $http, $base, $classAttribute )
    {
        $filesizeName = $base . eZVideoFLVType::MAX_VIDEOFLV_FILESIZE_VARIABLE . $classAttribute->attribute( 'id' );
        if ( $http->hasPostVariable( $filesizeName ) )
        {
            $filesizeValue = $http->postVariable( $filesizeName );
            $classAttribute->setAttribute( eZVideoFLVType::MAX_VIDEOFLV_FILESIZE_FIELD, $filesizeValue );
        }
    }

    /*!
     Returns the object title.
    */
    function title( $contentObjectAttribute,  $name = "original_filename" )
    {
        $mediaFile = eZVideoFLV::fetchVideo( $contentObjectAttribute->attribute( "id" ),
                                      $contentObjectAttribute->attribute( "version" ) );

        if ( $mediaFile != null )
            $value = $mediaFile->attribute( $name );
        else
            $value = "";
        return $value;
    }

    function hasObjectAttributeContent( $contentObjectAttribute )
    {
        $mediaFile = eZVideoFLV::fetchVideo( $contentObjectAttribute->attribute( "id" ),
                                      $contentObjectAttribute->attribute( "version" ) );
        if ( !$mediaFile )
            return false;
        if( $mediaFile->attribute( "filename" ) == "" )
            return false;
       return true;
    }

    function objectAttributeContent( $contentObjectAttribute )
    {
        $mediaFile = eZVideoFLV::fetchVideo( $contentObjectAttribute->attribute( "id" ),
                                      $contentObjectAttribute->attribute( "version" ) );
        if ( !$mediaFile )
        {
            $retValue = false;
            return $retValue;
        }
        return $mediaFile;
    }

    function metaData( $contentObjectAttribute )
    {
        return "";
    }

    /*!
     \return string representation of an contentobjectattribute data for simplified export

    */
    function toString( $objectAttribute )
    {
        $mediaFile = $objectAttribute->content();

        if ( is_object( $mediaFile ) )
        {
            return implode( '|', array( $mediaFile->attribute( 'filepath' ), $mediaFile->attribute( 'original_filename' ) ) );
        }
        else
            return '';
    }



    function fromString( $objectAttribute, $string )
    {
        if( !$string )
            return true;

        $result = array();
        return $this->insertRegularFile( $objectAttribute->attribute( 'object' ),
                                         $objectAttribute->attribute( 'version' ),
                                         $objectAttribute->attribute( 'language_code' ),
                                         $objectAttribute,
                                         $string,
                                         $result );

    }

    /*!
     \reimp
    */
    function serializeContentClassAttribute( $classAttribute, $attributeNode, $attributeParametersNode )
    {
        $maxSize = $classAttribute->attribute( eZVideoFLVType::MAX_VIDEOFLV_FILESIZE_FIELD );
        $attributeParametersNode->appendChild( eZDOMDocument::createElementTextNode( 'max-size', $maxSize,
                                                                                     array( 'unit-size' => 'mega' ) ) );
    }

    /*!
     \reimp
    */
    function unserializeContentClassAttribute( $classAttribute, $attributeNode, $attributeParametersNode )
    {
        $maxSize = $attributeParametersNode->elementTextContentByName( 'max-size' );
        $sizeNode = $attributeParametersNode->elementByName( 'max-size' );
        $unitSize = $sizeNode->attributeValue( 'unit-size' );
        $classAttribute->setAttribute( eZVideoFLVType::MAX_VIDEOFLV_FILESIZE_FIELD, $maxSize );
    }

    /*!
     \param package
     \param content attribute

     \return a DOM representation of the content object attribute
    */
    function serializeContentObjectAttribute( $package, $objectAttribute )
    {

        $node = $this->createContentObjectAttributeDOMNode( $objectAttribute );

        $mediaFile = $objectAttribute->attribute( 'content' );
        if ( !$mediaFile )
        {
            // Media type content could not be found.
            return $node;
        }

        $fileKey = md5( mt_rand() );
		$fileKeyFLV = md5( mt_rand().'flv' );

        $fileInfo = $mediaFile->storedFileInfo();
        $package->appendSimpleFile( $fileKey, $fileInfo['filepath'] );
		$package->appendSimpleFile( $fileKeyFLV, $fileInfo['filepath_flv'] );

        $mediaNode = eZDOMDocument::createElementNode( 'videoflv-file' );
        $mediaNode->appendAttribute( eZDOMDocument::createAttributeNode( 'filesize', $mediaFile->attribute( 'filesize' ) ) );
        $mediaNode->appendAttribute( eZDOMDocument::createAttributeNode( 'flv', $mediaFile->attribute( 'flv' ) ) );
        $mediaNode->appendAttribute( eZDOMDocument::createAttributeNode( 'filename', $mediaFile->attribute( 'filename' ) ) );
        $mediaNode->appendAttribute( eZDOMDocument::createAttributeNode( 'original-filename', $mediaFile->attribute( 'original_filename' ) ) );
        $mediaNode->appendAttribute( eZDOMDocument::createAttributeNode( 'mime-type', $mediaFile->attribute( 'mime_type' ) ) );
        $mediaNode->appendAttribute( eZDOMDocument::createAttributeNode( 'filekey', $fileKey ) );
        $mediaNode->appendAttribute( eZDOMDocument::createAttributeNode( 'filekeyflv', $fileKeyFLV ) );

        $mediaNode->appendAttribute( eZDOMDocument::createAttributeNode( 'width', $mediaFile->attribute( 'width' ) ) );
        $mediaNode->appendAttribute( eZDOMDocument::createAttributeNode( 'height', $mediaFile->attribute( 'height' ) ) );
        $node->appendChild( $mediaNode );

        return $node;
    }

    /*!
     \reimp
     \param package
     \param contentobject attribute object
     \param ezdomnode object
    */
    function unserializeContentObjectAttribute( $package, $objectAttribute, $attributeNode )
    {
        $mediaNode = $attributeNode->elementByName( 'videoflv-file' );
        if ( !$mediaNode )
        {
            // No media type data found.
            return;
        }

        $mediaFile = eZVideoFLV::create( $objectAttribute->attribute( 'id' ), $objectAttribute->attribute( 'version' ) );

        $sourcePath = $package->simpleFilePath( $mediaNode->attributeValue( 'filekey' ) );
        $sourcePathFLV = $package->simpleFilePath( $mediaNode->attributeValue( 'filekeyflv' ) );

        $ini = eZINI::instance();
        $mimeType = $mediaNode->attributeValue( 'mime-type' );
        list( $mimeTypeCategory, $mimeTypeName ) = explode( '/', $mimeType );
        $destinationPath = eZSys::storageDirectory() . '/original/' . $mimeTypeCategory . '/';
        if ( !file_exists( $destinationPath ) )
        {
            $oldumask = umask( 0 );
            if ( !eZDir::mkdir( $destinationPath, eZDir::directoryPermission(), true ) )
            {
                umask( $oldumask );
                return false;
            }
            umask( $oldumask );
        }

        $basename = basename( $mediaNode->attributeValue( 'filename' ) );
        while ( file_exists( $destinationPath . $basename ) )
        {
            $basename = substr( md5( mt_rand() ), 0, 8 ) . '.' . eZFile::suffix( $mediaNode->attributeValue( 'filename' ) );
        }
		$basenameFLV = '';
        while ( file_exists( $destinationPath . $basenameFLV ) )
        {
            $basenameFLV = substr( md5( mt_rand() ), 0, 8 ) . '.flv';
        }

        eZFileHandler::copy( $sourcePath, $destinationPath . $basename );
        eZFileHandler::copy( $sourcePathFLV, $destinationPath . $basenameFLV );
        eZDebug::writeNotice( 'Copied: ' . $sourcePath . ' to: ' . $destinationPath . $basename,
                              'eZVideoFLVType::unserializeContentObjectAttribute()' );

        $mediaFile->setAttribute( 'contentobject_attribute_id', $objectAttribute->attribute( 'id' ) );
        $mediaFile->setAttribute( 'filename', $basename );
        $mediaFile->setAttribute( 'original_filename', $mediaNode->attributeValue( 'original-filename' ) );
        $mediaFile->setAttribute( 'flv', $basenameFLV );
        $mediaFile->setAttribute( 'mime_type', $mediaNode->attributeValue( 'mime-type' ) );

        $mediaFile->setAttribute( 'width', $mediaNode->attributeValue( 'width' ) );
        $mediaFile->setAttribute( 'height', $mediaNode->attributeValue( 'height' ) );

        // VS-DBFILE

        require_once( 'kernel/classes/ezclusterfilehandler.php' );
        $fileHandler = eZClusterFileHandler::instance();
        $fileHandler->fileStore( $destinationPath . $basename, 'mediafile', true );
        $fileHandler->fileStore( $destinationPath . $basenameFLV, 'mediafile', true );

        $mediaFile->store();
    }
}

eZDataType::register( eZVideoFLVType::VIDEOFLV, "ezvideoflvtype" );

?>
