<?php

//
// SOFTWARE NAME: eZ Video FLV
// SOFTWARE RELEASE: 0.2
// COPYRIGHT NOTICE: Copyright (C) 2007 Damien POBEL
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

include_once( 'extension/ezvideoflv/datatypes/ezvideoflv/ezvideoflv.php' );

$cli = eZCLI::instance();

$storageDir = eZSys::storageDirectory();
$destinationDir = $storageDir . '/original/video';


if ( in_array('-all', $_SERVER['argv'] ) )
	$videoFiles = eZVideoFLV::fetchAll();
else
	$videoFiles = eZVideoFLV::fetchNotConverted();

$nbFiles = count( $videoFiles );


eZDebug::writeDebug( $nbFiles . ' files to convert' );
foreach( $videoFiles as $video )
{
	$filename = $video->attribute( 'filename' );
	if ( $filename == '' )
		continue ;
	eZDebug::writeDebug( "Converting " . $filename );
	$flv = eZVideoFLV::doConvert( $video->attribute( 'filepath' ), $destinationDir );
	if ( is_null( $flv ) )
	{
		eZDebug::writeDebug( "Can't convert " . $video->attribute( 'filepath' ) . ' to FLV', 'eZVideoFLV Cronjob' );
		$flv = '';
	}
	else
	{
		eZDebug::writeDebug( ' --> convert done in ' . $flv );
        $fileHandler = eZClusterFileHandler::instance();
		$fileHandler->fileStore( $flv, 'mediafile', true, 'video/x-flv' );
		$video->setAttribute( 'flv', $flv );
		$video->store();
		$attributeID = $video->attribute( 'contentobject_attribute_id' );
		$version = $video->attribute( 'version' );
		$attribute = eZContentObjectAttribute::fetch( $attributeID, $version );
		if ( is_object( $attribute ) )
		{
			$contentObjectID = $attribute->attribute( 'contentobject_id' );
			eZDebug::writeDebug( 'Clearing cache for objectID: '. $contentObjectID );
			eZContentCacheManager::clearContentCache( $contentObjectID );
		}
	}

}

?>
