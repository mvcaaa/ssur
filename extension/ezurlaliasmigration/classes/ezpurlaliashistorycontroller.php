<?php
/**
 * File containing the ezpUrlAliasHistoryController class
 *
 * @copyright Copyright (C) 1999-2008 eZ Systems AS. All rights reserved.
 * @license http://ez.no/licenses/gnu_gpl GNU GPLv2
 * @package UrlAliasMigration
 *
 */

/**
 * Controller class for migrationg and restoring url history entries
 *
 * @package UrlAliasMigration
 */
class ezpUrlAliasHistoryController extends ezpUrlAliasMigrationController
{
    /**
     * Action for migrating all existing url history entries to the migration table.
     * 
     * @return void
     */
    public static function migrateHistoryEntries()
    {
        $historyUrlCount = ezpUrlAliasMigrateTool::historyUrlCount();

        $migrateCount = 0;

        $fetchLimit = 50;
        $migrateOffset = 0;

        self::setProgressCount( $historyUrlCount );

        $db = eZDB::instance();

        while( $migrateCount < $historyUrlCount )
        {
            list( $historyUrlArray, $newOffset ) = ezpUrlAliasMigrateTool::historyUrl( $migrateOffset, $fetchLimit );

            foreach ( $historyUrlArray as &$entry )
            {
                $entry['extra_data'] = ezpUrlAliasMigrateTool::extractUrlData( $entry['parent'], $entry['text_md5'], null );
            }

            $historyCopyArray = ezpUrlAliasQueryStrict::makeList( $historyUrlArray, true );

            foreach ( $historyCopyArray as $historyEntry )
            {
                $db->begin();
                $result = $historyEntry->store();
                self::doCallback( !$result );
                $db->commit();
            }

            $migrateCount += count( $historyUrlArray );
            $migrateOffset = $newOffset;

            unset( $historyUrlArray, $historyCopyArray );
        }
    }

    /**
     * Action for restoring migrated url history entries.
     * 
     * @return void
     */
    public static function restoreHistoryEntries()
    {
        $cond = array();
        $cond = array( 'is_restored' => 0,
                       'is_original'=> 0 );

        $historyMigrateCount = eZPersistentObject::count( ezpMigratedUrlAlias::definition(), $cond );
        $restoreCount = 0;

        $fetchLimit = 50;
        $restoreOffset = 0;

        self::setProgressCount( $historyMigrateCount );

        $db = eZDB::instance();

        while ( $restoreCount < $historyMigrateCount )
        {
            list( $historyArray, $newOffset ) = ezpUrlAliasMigrateTool::migratedUrlAlias( $cond, 0, $fetchLimit );

            foreach ( $historyArray as $entry )
            {
                $db->begin();
                $result = $entry->analyse();
                self::doCallback( $result );
                $db->commit();
            }

            $restoreCount += count( $historyArray );
            $restoreOffset = $newOffset;

            unset( $historyArray );
        }
    }
}
?>
