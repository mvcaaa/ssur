<?php
/**
 * File containing url migrate controller
 *
 * @copyright Copyright (C) 1999-2008 eZ Systems AS. All rights reserved.
 * @license http://ez.no/licenses/gnu_gpl GNU GPLv2
 * @package UrlAliasMigration
 *
 */

ezpUrlAliasMigrateTool::setupDebug();

require_once 'kernel/common/template.php';

// Setting up module information
$path = array();
$path[] = array( 'url'  => false,
                 'text' => ezi18n( 'urlalias/urlalias_migrate', 'Custom Url alias migration' ) );

$Result['path'] = $path;
$Result['left_menu'] = 'design:urlalias/url_migrate_menu.tpl';

// Setting up module values
$http = eZHTTPTool::instance();
$Module = $Params['Module'];
$offset = $Params['Offset'];
$viewParameters = array( 'offset' => $offset );

$limitList = array( 1 => 10,
                    2 => 25,
                    3 => 50,
                    4 => 100 );
$limit = 10;
$limitId = eZPreferences::value( 'admin_urlalias_migrate_list_limit' );

if ( $limitId and isset( $limitList[$limitId] ) )
{
    $limit = $limitList[$limitId];
}

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

if ( $Module->isCurrentAction( 'MigrateAlias' ) )
{
    if ( $http->hasPostVariable( 'ElementList' ) )
    {
        $elementList = $http->postVariable( 'ElementList' );
    }
    else
    {
        $elementList = array();
    }
    eZDebugSetting::writeDebug( "urlalias-migration-extra", $elementList );
    ezpUrlAliasController::migrateAlias( $elementList );
    $infoCode = 'feedback-migrate';

}
else if ( $Module->isCurrentAction( 'MigrateAllAliases' ) )
{
    ezpUrlAliasController::migrateAllAliases();
    $infoCode = "feedback-migrate-all";
}


// Default action list all custom aliases
// $urlQuery = new eZURLAliasQuery();
$urlQuery = new ezpUrlAliasQueryStrict();
$urlQuery->type = "alias";
$urlQuery->limit = $limit;
$urlQuery->offset = $offset;

$tpl = templateInit();
$tpl->setVariable( 'filter', $urlQuery );
$tpl->setVariable( 'limitList', $limitList );
$tpl->setVariable( 'limit', $limit );
$tpl->setVariable( 'view_parameters', $viewParameters );
$tpl->setVariable( 'info_code', $infoCode );
$tpl->setVariable( 'info_data', $infoData );

$Result['content'] = $tpl->fetch( 'design:urlalias/url_migrate.tpl' );

?>
