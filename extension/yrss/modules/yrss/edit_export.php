<?php
//
// eZSetup - init part initialization
//
// Created on: <18-Sep-2003 14:49:54 kk>
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

include_once( 'extension/yrss/modules/yrss/edit_functions.php' );
require_once( 'kernel/common/template.php' );
include_once( 'extension/yrss/classes/yrssexport.php' );
include_once( 'extension/yrss/classes/yrssexportitem.php' );
//include_once( 'kernel/classes/ezrssexport.php' );
//include_once( 'kernel/classes/ezrssexportitem.php' );
//include_once( 'lib/ezutils/classes/ezhttppersistence.php' );

$http = eZHTTPTool::instance();

$valid = true;
$validationErrors = array();

if ( isset( $Params['RSSExportID'] ) )
    $RSSExportID = $Params['RSSExportID'];
else
    $RSSExportID = false;

if ( $http->hasPostVariable( 'RSSExport_ID' ) )
    $RSSExportID = $http->postVariable( 'RSSExport_ID' );

if ( $Module->isCurrentAction( 'Store' ) )
{

    $storeResult = yRSSEditFunction::storeRSSExport( $Module, $http, true );

    if ( $storeResult['valid'] && $storeResult['published'] )
        return $Module->redirectTo( '/yrss/list' );
    if ( !$storeResult['valid'] )
    {
        $valid = false;
        $validationErrors = $storeResult['validation_errors'];
    }
}
else if ( $Module->isCurrentAction( 'UpdateItem' ) )
{
    yRSSEditFunction::storeRSSExport( $Module, $http );
}
else if ( $Module->isCurrentAction( 'AddItem' ) )
{
    $rssExportItem = yRSSExportItem::create( $RSSExportID );
    $rssExportItem->store();
    yRSSEditFunction::storeRSSExport( $Module, $http );
}
else if ( $Module->isCurrentAction( 'Cancel' ) )
{
    $rssExport = yRSSExport::fetch( $RSSExportID, true, yRSSExport::STATUS_DRAFT );
    if ( $rssExport )
        $rssExport->removeThis();
    return $Module->redirectTo( '/yrss/list' );
}
else if ( $Module->isCurrentAction( 'BrowseImage' ) )
{
    yRSSEditFunction::storeRSSExport( $Module, $http );
    //include_once( 'kernel/classes/ezcontentbrowse.php' );
    eZContentBrowse::browse( array( 'action_name' => 'RSSExportImageBrowse',
                                    'description_template' => 'design:rss/browse_image.tpl',
                                    'from_page' => '/yrss/edit_export/'. $RSSExportID .'/0/ImageSource' ),
                             $Module );
}
else if ( $Module->isCurrentAction( 'RemoveImage' ) )
{
    $rssExport = yRSSExport::fetch( $RSSExportID, true, yRSSExport::STATUS_DRAFT );
    $rssExport->setAttribute( 'image_id', 0 );
    $rssExport->store();
}


if ( $http->hasPostVariable( 'Item_Count' ) )
{

    $db = eZDB::instance();
    $db->begin();
    for ( $itemCount = 0; $itemCount < $http->postVariable( 'Item_Count' ); $itemCount++ )
    {
        if ( $http->hasPostVariable( 'SourceBrowse_'.$itemCount ) )
        {
            yRSSEditFunction::storeRSSExport( $Module, $http );
            //include_once( 'kernel/classes/ezcontentbrowse.php' );
            eZContentBrowse::browse( array( 'action_name' => 'RSSObjectBrowse',
                                            'description_template' => 'design:rss/browse_source.tpl',
                                            'from_page' => '/yrss/edit_export/'. $RSSExportID .'/'. $http->postVariable( 'Item_ID_'.$itemCount ) .'/NodeSource' ),
                                     $Module );
            break;
        }

        // remove selected source (if any)
        if ( $http->hasPostVariable( 'RemoveSource_'.$itemCount ) )
        {
            $itemID = $http->postVariable( 'Item_ID_'.$itemCount );
            if ( ( $rssExportItem = yRSSExportItem::fetch( $itemID, true, yRSSExport::STATUS_DRAFT ) ) )
            {
                // remove the draft version
                $rssExportItem->remove();
                // remove the published version
                $rssExportItem->setAttribute( 'status', yRSSExport::STATUS_VALID );
                $rssExportItem->remove();
                yRSSEditFunction::storeRSSExport( $Module, $http );
            }

            break;
        }
    }
    $db->commit();
}

if ( is_numeric( $RSSExportID ) )
{
    $rssExportID = $RSSExportID;
    $rssExport = yRSSExport::fetch( $RSSExportID, true, yRSSExport::STATUS_DRAFT );

    if ( $rssExport )
    {
        //include_once( 'lib/ezlocale/classes/ezdatetime.php' );
        $user = eZUser::currentUser();
        $contentIni = eZINI::instance( 'content.ini' );
        $timeOut = $contentIni->variable( 'RSSExportSettings', 'DraftTimeout' );
        if ( $rssExport->attribute( 'modifier_id' ) != $user->attribute( 'contentobject_id' ) &&
             $rssExport->attribute( 'modified' ) + $timeOut > time() )
        {
            // locked editing
            $tpl = templateInit();

            $tpl->setVariable( 'rss_export', $rssExport );
            $tpl->setVariable( 'rss_export_id', $rssExportID );
            $tpl->setVariable( 'lock_timeout', $timeOut );

            $Result = array();
            $Result['content'] = $tpl->fetch( 'design:rss/edit_export_denied.tpl' );
            $Result['path'] = array( array( 'url' => false,
                                            'text' => ezi18n( 'kernel/rss', 'Really Simple Syndication' ) ) );
            return $Result;
        }
        else if ( $timeOut > 0 && $rssExport->attribute( 'modified' ) + $timeOut < time() )
        {
            $rssExport->removeThis();
            $rssExport = false;
        }
    }
    if ( !$rssExport )
    {
        $rssExport = yRSSExport::fetch( $RSSExportID, true, yRSSExport::STATUS_VALID );
        if ( $rssExport )
        {
            $db = eZDB::instance();
            $db->begin();
            $rssItems = $rssExport->fetchItems();
            $rssExport->setAttribute( 'status', yRSSExport::STATUS_DRAFT );
            $rssExport->store();
            foreach( $rssItems as $rssItem )
            {
                $rssItem->setAttribute( 'status', yRSSExport::STATUS_DRAFT );
                $rssItem->store();
            }
            $db->commit();
        }
        else
        {
            return $Module->handleError( eZError::KERNEL_NOT_AVAILABLE, 'kernel' );
        }
    }

    //include_once( 'kernel/classes/ezcontentbrowse.php' );

    switch ( $Params['BrowseType'] )
    {
        case 'NodeSource':
        {
            $nodeIDArray = $http->hasPostVariable( 'SelectedNodeIDArray' ) ? $http->postVariable( 'SelectedNodeIDArray' ) : null;
            if ( isset( $nodeIDArray ) && !$http->hasPostVariable( 'BrowseCancelButton' ) )
            {
                $rssExportItem = yRSSExportItem::fetch( $Params['RSSExportItemID'], true, yRSSExport::STATUS_DRAFT );
                $rssExportItem->setAttribute( 'source_node_id', $nodeIDArray[0] );
                $rssExportItem->store();
            }
        } break;

        case 'ImageSource':
        {
            $imageNodeIDArray = $http->hasPostVariable( 'SelectedNodeIDArray' ) ? $http->postVariable( 'SelectedNodeIDArray' ) : null;
            if ( isset( $imageNodeIDArray ) && !$http->hasPostVariable( 'BrowseCancelButton' ) )
            {
                $rssExport->setAttribute( 'image_id', $imageNodeIDArray[0] );
            }
        } break;
    }
}
else // New RSSExport
{
    //include_once( "kernel/classes/datatypes/ezuser/ezuser.php" );
    $user = eZUser::currentUser();
    $user_id = $user->attribute( "contentobject_id" );


    $db = eZDB::instance();
    $db->begin();

    // Create default rssExport object to use
    $rssExport = yRSSExport::create( $user_id );
    $rssExport->store();
    $rssExportID = $rssExport->attribute( 'id' );

    // Create One empty export item
    $rssExportItem = yRSSExportItem::create( $rssExportID );
    $rssExportItem->store();

    $db->commit();
}

$tpl = templateInit();
$config = eZINI::instance( 'site.ini' );

$numberOfObjectsArray = $config->variable( 'RSSSettings', 'NumberOfObjectsList' );
$numberOfObjectsDefault = $config->variable( 'RSSSettings', 'NumberOfObjectsDefault' );

// Get Classes and class attributes
$classArray = eZContentClass::fetchList();

$tpl->setVariable( 'number_of_objects_array', $numberOfObjectsArray );
$tpl->setVariable( 'number_of_objects_default', $numberOfObjectsDefault );

$tpl->setVariable( 'rss_class_array', $classArray );
$tpl->setVariable( 'rss_export', $rssExport );
$tpl->setVariable( 'rss_export_id', $rssExportID );

// BC for old templates
$tpl->setVariable( 'validaton', !$valid );
// New validation handling
$tpl->setVariable( 'valid', $valid );
$tpl->setVariable( 'validation_errors', $validationErrors );

$Result = array();
$Result['content'] = $tpl->fetch( "design:yrss/edit_export.tpl" );
$Result['path'] = array( array( 'url' => false,
                                'text' => ezi18n( 'kernel/rss', 'Really Simple Syndication' ) ) );


?>
