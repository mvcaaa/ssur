<?php

//
// SOFTWARE NAME: eZ Video FLV
// SOFTWARE RELEASE: 0.2
// COPYRIGHT NOTICE: Copyright (C)	1999-2006 eZ Systems AS
// 									2007 Damien POBEL
// BASED ON: ezbinaryfilehander.php
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


class eZFLVPreviewHandler extends eZBinaryFileHandler
{
    const PREVIEW_ID = 'ezflvpreview';

    function eZFLVPreviewHandler()
    {
        $this->eZBinaryFileHandler( eZFLVPreviewHandler::PREVIEW_ID,
						"PHP FLV Preview passtrough", eZBinaryFileHandler::HANDLE_DOWNLOAD );
    }

    function handleFileDownload( $contentObject, $contentObjectAttribute, $type,
                                 $fileInfo )
    {
		$video = eZVideoFLV::fetchVideo( $contentObjectAttribute->attribute( 'id' ),
									$contentObjectAttribute->attribute( 'version' ) );
		$fileName = $video->attribute( 'preview' );

        // VS-DBFILE
        //require_once( 'kernel/classes/ezclusterfilehandler.php' );
        $file = eZClusterFileHandler::instance( $fileName );

        if ( $fileName != "" and $file->exists() )
        {
            $file->fetch();
            $fileSize = $file->size();
			$mimeData = eZMimeType::findByFileContents( $fileName );
            $mimeType = $mimeData['name'];
            $contentLength = $fileSize;
            $fileModificationTime = filemtime( $fileName );

            ob_clean();
            header( "Last-Modified: ". gmdate( 'D, d M Y H:i:s T', $fileModificationTime ) . ' GMT' );
            header( "Content-Length: $contentLength" );
            header( "Content-Type: $mimeType" );
            header( "X-Powered-By: eZ publish" );

            $fh = fopen( "$fileName", "rb" );
            ob_end_clean();
            fpassthru( $fh );
            fclose( $fh );

            eZExecution::cleanExit();
        }
        return eZBinaryFileHandler::RESULT_UNAVAILABLE;
    }
}

?>
