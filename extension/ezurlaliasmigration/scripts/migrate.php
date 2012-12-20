#!/usr/bin/env php
<?php
/**
 * Script to migrate url aliases
 *
 * @copyright Copyright (C) 1999-2008 eZ Systems AS. All rights reserved.
 * @license http://ez.no/licenses/gnu_gpl GNU GPLv2
 * @package UrlAliasMigration
 *
 */

set_time_limit( 0 );

/**
 * Autoload system
 */
require_once 'autoload.php';

$cli = eZCLI::instance();
$script = eZScript::instance( array( 'description' => ( "eZ Publish url alias migration tool\n\n" .
                                                        "Running this script with no options will display the number of custom url aliases\n" .
                                                        "and url history elements, it will also check if the migration table exists on the system.\n" .
                                                        "\n" .
                                                        "migrate.php" ),
                                      'use-session' => false,
                                      'use-modules' => true,
                                      'use-extensions' => true,
                                    ) );

$script->startup();

$config = '[migrate][migrate-alias][migrate-history][restore][restore-alias][restore-history][create-migration-table]';
$argumentConfig = '';
$optionHelp = array(
                    "migrate" => "Migrate both custom url aliases and url history elements, to the migration table.",
                    "migrate-alias" => "Migrate custom url aliases to the migration table.",
                    "migrate-history" => "Migrate url history entries to the migration table",
                    "restore" => "Restores all migrated custom url aliases and history entries, where they can be automatically restored.",
                    "restore-alias" => "Restores migrated custom url aliases which can be automatically restored.",
                    "restore-history" => "Restores migrated history entries which can be automatically restored.",
                    "create-migration-table" => "Inserts the migration table into the database, which is required for migrating url alias and history entries."
                   );
$arguments = false;
$useStandardOptions = true;

$options = $script->getOptions( $config, $argumentConfig, $optionHelp, $arguments, $useStandardOptions );
$script->initialize();
$script->setIterationData( '.', 'F' );

eZContentLanguage::setCronjobMode( true );

// Set up run mode

// Default values go here for when no options are used.
$doMigrate = false;
$doMigrateAlias = false;
$doMigrateHistory = false;

$doRestore = false;
$doRestoreAlias = false;
$doRestoreHistory = false;

$doMigrationTable = false;
$doOverviewOutput = true;

if ( $options['migrate'] )
{
    $doMigrateAlias = true;
    $doMigrateHistory = true;
    $doOverviewOutput = false;
}

if ( $options['migrate-alias'] )
{
    $doMigrateAlias = true;
    $doOverviewOutput = false;
}

if ( $options['migrate-history'] )
{
    $doMigrateHistory = true;
    $doOverviewOutput = false;
}

if ( $options['restore'] )
{
    $doRestoreAlias = true;
    $doRestoreHistory = true;
    $doOverviewOutput = false;
}

if ( $options['restore-alias'] )
{
    $doRestoreAlias = true;
    $doOverviewOutput = false;
}

if ( $options['restore-history'] )
{
    $doRestoreHistory = true;
    $doOverviewOutput = false;
}

if ( $options['create-migration-table'] )
{
    $doMigrationTable = true;
}

// Perform actions selected by user
if( $doMigrationTable )
{
    ezpUrlAliasController::insertMissingTable();
}

// Setting up the callback to get feedback to the script about the progress in the controller.
ezpUrlAliasMigrationController::setProgressCallback( 'progressOutput' );

if ( $doOverviewOutput )
{
    $numberOfCustomUrlAliases = ezpUrlAliasMigrateTool::customUrlAliasCount();
    $numberOfHistoryEntries = ezpUrlAliasMigrateTool::historyUrlCount();

    $cli->output( "" );
    $cli->output( "The number of custom url aliases are: {$numberOfCustomUrlAliases}" );
    $cli->output( "The number of history entries are: {$numberOfHistoryEntries}" );
    $cli->output( "" );

    // Check the site has the migration table present
    $db = eZDB::instance();
    $tables = $db->eZTableList();
    if ( !array_key_exists( "ezurlalias_ml_migrate", $tables ) )
    {
        $cli->output( "The ezurlalias_ml_migrate table does not exist, please add it to your system." );
    }
}

if ( $doMigrateAlias )
{
    $cli->output( "Migrating custom url aliases" );
    ezpUrlAliasController::migrateAllAliases();
}

if ( $doMigrateHistory )
{
    $cli->output( "Migrating url history entries" );
    ezpUrlAliasHistoryController::migrateHistoryEntries();
}

if ( $doRestoreAlias )
{
    $cli->output( "Restoring migrated url aliases" );
    ezpUrlAliasController::restoreAllAliases();
}

if ( $doRestoreHistory )
{
    $cli->output( "Restoring migrated url history entries" );
    ezpUrlAliasHistoryController::restoreHistoryEntries();
}

$script->shutdown();

/**
 * Callback for progress report
 * 
 * The <var>$result</var> parameter says whether the current iteration was a success or not.
 *
 * @param boolean $result 
 * @return void
 */
function progressOutput( $result )
{
    global $script;
    global $cli;

    $script->iterate( $cli, $result );
}

?>
