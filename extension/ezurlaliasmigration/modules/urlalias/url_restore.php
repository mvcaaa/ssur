<?php
/**
 * File containing url restore controller
 *
 * @copyright Copyright (C) 1999-2008 eZ Systems AS. All rights reserved.
 * @license http://ez.no/licenses/gnu_gpl GNU GPLv2
 * @package UrlAliasMigration
 *
 */

ezpUrlAliasMigrateTool::setupDebug();

require_once 'kernel/common/template.php';

// Set up module information
$path = array();
$path[] = array( 'url'  => false,
                 'text' => ezi18n( 'urlalias/urlalias_restore', 'Restore custom URL aliases' ) );

$Result['path'] = $path;
$Result['left_menu'] = 'design:urlalias/url_migrate_menu.tpl';

// Set up module values
$http = eZHTTPTool::instance();

$Module = $Params['Module'];
$offset = $Params['Offset'];
$viewParameters = array( 'offset' => $offset );

$limitList = array( 1 => 10,
                    2 => 25,
                    3 => 50,
                    4 => 100 );
$limit = 10;
$limitId = eZPreferences::value( 'admin_urlalias_restore_list_limit' );

if ( $limitId and isset( $limitList[$limitId] ) )
{
    $limit = $limitList[$limitId];
}

$showRestoredAliases = eZPreferences::value( 'admin_urlalias_show_restored' );

$infoCode = 'no-errors';
$infoData = array();

// Check the site has the migration table present
$db = eZDB::instance();
$tables = $db->eZTableList();

if ( !array_key_exists( "ezurlalias_ml_migrate", $tables ) and !$Module->isCurrentAction( 'InsertMissingTable' ) )
{
    $tpl = templateInit();
    $Result['content'] = $tpl->fetch( 'design:urlalias/url_db_missing.tpl' );
    return;
}

// Start processing actions from here on

if ( $Module->isCurrentAction( 'RestoreAlias' ) )
{
    $infoCode = 'feedback-restore';
    $infoData['message'] = "No changes were made to the database.";
    if ( $http->hasPostVariable( 'ElementList' ) )
    {
        $elementList = $http->postVariable( 'ElementList' );
    }
    else
    {
        $elementList = array();
    }
    eZDebugSetting::writeDebug( "urlalias-migration", $elementList );

    ezpUrlAliasController::restoreAlias( $elementList );
}
else if ( $Module->isCurrentAction( 'RestoreAllAliases') )
{
    $infoCode = 'feedback-restore-all';
    ezpUrlAliasController::restoreAllAliases();
}
else if ( $Module->isCurrentAction( 'Remove' ) )
{
    if ( $http->hasPostVariable( 'ElementList' ) )
    {
        $elementList = $http->postVariable( 'ElementList' );
    }
    else
    {
        $elementList = array();
    }

    ezpUrlAliasController::removeAlias( $elementList );
}
else if ( $Module->isCurrentAction( 'RemoveAll' ) )
{
    ezpUrlAliasController::removeAllAliases();
}
else if ( $Module->isCurrentAction( 'InsertMissingTable' ) )
{
    ezpUrlAliasController::insertMissingTable();
    $Module->redirectToView( "restore" );
}

// Fetch migrated aliases
$cond = array( 'is_original' => 1 );
if ( !$showRestoredAliases )
{
    $cond = array( 'is_restored' => 0,
                   'is_original' => 1 );
}

$aliasList = ezpUrlAliasMigrateTool::migratedUrlAlias( $cond, $offset, $limit );
$count = eZPersistentObject::count( ezpMigratedUrlAlias::definition(), $cond );

$tpl = templateInit();
// We are only sending the objects to the template, the new offset is not needed here.
$tpl->setVariable( 'aliasList', $aliasList[0] );
$tpl->setVariable( 'count', $count );
$tpl->setVariable( 'limitList', $limitList );
$tpl->setVariable( 'limit', $limit );
$tpl->setVariable( 'view_parameters', $viewParameters );
$tpl->setVariable( 'info_code', $infoCode );
$tpl->setVariable( 'info_data', $infoData );
$tpl->setVariable( 'show_restored', $showRestoredAliases );

$Result['content'] = $tpl->fetch( 'design:urlalias/url_restore.tpl' );

?>
