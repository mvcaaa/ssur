<?php
//
// eZSetup - init part initialization
//
// Created on: <17-Sep-2003 11:00:54 kk>
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

require_once( "kernel/common/template.php" );
include_once( 'extension/yrss/classes/yrssexport.php' );
//include_once( 'kernel/classes/ezrssimport.php' );
//include_once( 'lib/ezutils/classes/ezhttppersistence.php' );

$http = eZHTTPTool::instance();

if ( $http->hasPostVariable( 'NewExportButton' ) )
{
    return $Module->run( 'edit_export', array() );
}
else if ( $http->hasPostVariable( 'RemoveExportButton' ) )
{
    $deleteArray = $http->postVariable( 'DeleteIDArray' );
    foreach ( $deleteArray as $deleteID )
    {
        $rssExport = yRSSExport::fetch( $deleteID, true, yRSSExport::STATUS_DRAFT );
        if ( $rssExport )
        {
            $rssExport->remove();
        }
        $rssExport = yRSSExport::fetch( $deleteID, true, yRSSExport::STATUS_VALID );
        if ( $rssExport )
        {
            $rssExport->remove();
        }
    }
}


// Get all RSS Exports
$exportArray = yRSSExport::fetchList();
$exportList = array();
foreach( $exportArray as $export )
{
    $exportList[$export->attribute( 'id' )] = $export;
}

$tpl = templateInit();

$tpl->setVariable( 'rssexport_list', $exportList );

$Result = array();
$Result['content'] = $tpl->fetch( "design:yrss/list.tpl" );
$Result['path'] = array( array( 'url' => 'yrss/list',
                                'text' => ezi18n( 'kernel/rss', 'Really Simple Syndication' ) ) );


?>
