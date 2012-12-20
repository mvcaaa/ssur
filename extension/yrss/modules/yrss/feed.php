<?php
//
// Created on: <19-Sep-2002 16:45:08 kk>
//
// SOFTWARE NAME: eZ Publish
// SOFTWARE RELEASE: 4.0.0
// BUILD VERSION: 20988
// COPYRIGHT NOTICE: Copyright (C) 1999-2007 eZ Systems AS
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

$Module = $Params['Module'];

if ( !isset ( $Params['RSSFeed'] ) )
{
    eZDebug::writeError( 'No RSS feed specified' );
    return $Module->handleError( eZError::KERNEL_NOT_AVAILABLE, 'kernel' );
}

include_once( 'extension/yrss/classes/yrssexport.php' );
//include_once( 'kernel/classes/ezrssexport.php' );

$feedName = $Params['RSSFeed'];
$RSSExport = yRSSExport::fetchByName( $feedName );

// Get and check if RSS Feed exists
if ( !$RSSExport )
{
    eZDebug::writeError( 'Could not find RSSExport : ' . $Params['RSSFeed'] );
    return $Module->handleError( eZError::KERNEL_NOT_AVAILABLE, 'kernel' );
}

//include_once( 'kernel/classes/ezrssexportitem.php' );

$config = eZINI::instance( 'site.ini' );
$cacheTime = intval( $config->variable( 'RSSSettings', 'CacheTime' ) );

if ( $cacheTime <= 0 )
{
    $xmlDoc = $RSSExport->attribute( 'rss-xml' );
    $rssContent = $xmlDoc->saveXML();
}
else
{
    $cacheDir = eZSys::cacheDirectory();
    $currentSiteAccessName = $GLOBALS['eZCurrentAccess']['name'];
    $cacheFilePath = $cacheDir . '/yrss/' . md5( $currentSiteAccessName . $feedName ) . '.xml';

    // If cache directory does not exist, create it. Get permissions settings from site.ini
    if ( !is_dir( $cacheDir.'/yrss' ) )
    {
        $mode = $config->variable( 'FileSettings', 'TemporaryPermissions' );
        if ( !is_dir( $cacheDir ) )
        {
            mkdir( $cacheDir );
            chmod( $cacheDir, octdec( $mode ) );
        }
        mkdir( $cacheDir.'/yrss' );
        chmod( $cacheDir.'/yrss', octdec( $mode ) );
    }

    // VS-DBFILE

    require_once( 'kernel/classes/ezclusterfilehandler.php' );
    $cacheFile = eZClusterFileHandler::instance( $cacheFilePath );

    if ( !$cacheFile->exists() or ( time() - $cacheFile->mtime() > $cacheTime ) )
    {
        $xmlDoc = $RSSExport->attribute( 'rss-xml' );
        // Get current charset
        //include_once( 'lib/ezi18n/classes/eztextcodec.php' );
        $charset = eZTextCodec::internalCharset();
        $rssContent = $xmlDoc->saveXML();
        $cacheFile->storeContents( $rssContent, 'rsscache', 'xml' );
    }
    else
    {
        $rssContent = $cacheFile->fetchContents();
    }
}

// Set header settings
$httpCharset = eZTextCodec::httpCharset();
header( 'Content-Type: text/xml; charset=' . $httpCharset );
header( 'Content-Length: '.strlen($rssContent) );
header( 'X-Powered-By: eZ Publish' );

while ( @ob_end_clean() );

echo $rssContent;

eZExecution::cleanExit();

?>
