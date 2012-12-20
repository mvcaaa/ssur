<?php
/**
 * File containing module setup
 *
 * @copyright Copyright (C) 1999-2008 eZ Systems AS. All rights reserved.
 * @license http://ez.no/licenses/gnu_gpl GNU GPLv2
 * @package UrlAliasMigration
 *
 */

$Module = array( 'name' => 'eZ Url Alias Migration' );

$ViewList = array();

$ViewList['migrate'] = array(
                    'functions' => array(),
                    'default_navigation_part' => 'ezurlaliasnavigationpart',
                    'ui_context' => 'administration',
                    'script' => 'url_migrate.php',
                    'params' => array(),
                    'unordered_params' => array( 'offset' => 'Offset' ),
                    'single_post_actions' => array( 'MigrateAliasButton' => 'MigrateAlias',
                                                    'MigrateAllAliasesButton' => 'MigrateAllAliases' ),
                    'post_action_parameters' => array( 'MigrateAlias' => array( 'ElementList' => 'ElementList' ) )
                    );

$ViewList['restore'] = array(
                    'functions' => array(),
                    'default_navigation_part' => 'ezurlaliasnavigationpart',
                    'ui_context' => 'administration',
                    'script' => 'url_restore.php',
                    'params' => array(),
                    'unordered_params' => array( 'offset' => 'Offset' ),
                    'single_post_actions' => array( 'RestoreAliasButton' => 'RestoreAlias',
                                                    'RestoreAllAliasesButton' => 'RestoreAllAliases',
                                                    'RemoveButton' => 'Remove',
                                                    'RemoveAllButton' => 'RemoveAll',
                                                    'InsertMissingTableButton' => "InsertMissingTable" ),
                    'post_action_parameters' => array( 'MigrateAlias' => array( 'ElementList' => 'ElementList' ) )
                    );

$ViewList['overview'] = array(
                    'functions' => array(),
                    'default_navigation_part' => 'ezurlaliasnagivationpart',
                    'ui_context' => 'administration',
                    'script' => 'url_overview.php',
                    'params' => array()
                    );

$FunctionList = array();

?>
