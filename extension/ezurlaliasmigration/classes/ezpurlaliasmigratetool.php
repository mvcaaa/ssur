<?php
/**
 * File containing ezpUrlAliasMigrateTool class
 *
 * @copyright Copyright (C) 1999-2008 eZ Systems AS. All rights reserved.
 * @license http://ez.no/licenses/gnu_gpl GNU GPLv2
 * @package UrlAliasMigration
 *
 */

/**
 * ezpUrlAliasMigrateTool contains utility methods which are shared within the Url
 * Alias migration extension
 *
 * @package UrlAliasMigration
 */
class ezpUrlAliasMigrateTool
{
    /**
     * Returns count custom url aliases.
     * 
     * Checks for the number for manually entered url aliases in the system
     * ezurlalias_ml table
     * 
     * @return string
     */
    public static function customUrlAliasCount()
    {
        $db = eZDB::instance();
        $sql = 'SELECT count(*) AS count FROM ezurlalias_ml
                WHERE action_type IN ("eznode", "module") AND is_original = 1 AND is_alias = 1';
        $rows = $db->arrayQuery( $sql );
        return $rows[0]['count'];
    }

    /**
     * Returns manually entered url aliases from the system ezurlalias_ml table.
     * 
     * Method can be used to fetch many entries, with the <var>$offset</var> and <var>$fetchLimit</var>
     * parameters.
     *
     * @param string $offset 
     * @param string $fetchLimit 
     * @return mixed
     */
    public static function customUrlAlias( $offset, $fetchLimit )
    {
        $db = eZDB::instance();
        $sql = 'SELECT * FROM ezurlalias_ml
                WHERE action_type IN ("eznode", "module") AND is_original = 1 AND is_alias = 1';
        $rows = $db->arrayQuery( $sql,
                                 array( 'offset' => $offset,
                                        'limit' => $fetchLimit ) );
        return array( $rows, $offset + count( $rows ) );
    }

    /**
     * Returns the count of history url entries in the system
     *
     * @return string
     */
    public static function historyUrlCount()
    {
        $db = eZDB::instance();
        $sql = 'SELECT count(*) AS count FROM ezurlalias_ml
                WHERE action_type != "nop" AND is_original = 0 AND is_alias = 0';
        $rows = $db->arrayQuery( $sql );
        return $rows[0]['count'];
    }

    /**
     * Returns history url entries
     *
     * @return mixed
     */
    public static function historyUrl( $offset, $fetchLimit )
    {
        $db = eZDB::instance();
        $sql = 'SELECT * FROM ezurlalias_ml
                WHERE action_type != "nop" AND is_original = 0 AND is_alias = 0';
        $rows = $db->arrayQuery( $sql,
                                 array( 'offset' => $offset,
                                        'limit' => $fetchLimit ) );
        return array( $rows, $offset + count( $rows ) );
    }

    /**
     * Returns migrated url aliases which are stored in the ezurlalias_ml_migrate table.
     * 
     * It is possible to use conditions the same as in eZPersistentObject
     * @see eZPersistentObject::fetchObjectList()
     *
     * @param array $conditions 
     * @param string $offset 
     * @param string $limit 
     * @return mixed
     */
    public static function migratedUrlAlias( $conditions = null, $offset = false, $limit = false )
    {
        $limitParam = null;
        $asObject = false;

        if ( $offset !== false or $limit !== false )
        {
            $limitParam = array( 'offset' => $offset,
                                 'length' => $limit );
        }

        $sorting = array( 'text' => 'asc' );

        $aliases = eZPersistentObject::fetchObjectList( ezpMigratedUrlAlias::definition(),
                                                        null,
                                                        $conditions, $sorting, $limitParam,
                                                        $asObject );

        // We want to pass the database rows, through our makeList() which
        // prepares the objects for viewing.
        // This is a slightly sub-optimal workflow currently as
        // eZPersistentObject::handleRows is now currently called twice
        $aliases = ezpUrlAliasQueryStrict::makeList( $aliases );
        return array( $aliases, $offset + count( $aliases ) );

    }

    /**
     * Calculates the real path, and the action path for migration
     *
     * @param int $parentId 
     * @return void
     */
    public static function extractUrlData( $parentId, $textMD5, $language )
    {
        $db = eZDB::instance();
        $id = (int)$parentId;

        $rows = $db->arrayQuery( "SELECT * FROM ezurlalias_ml WHERE parent = {$id} AND text_md5 = '" . $db->escapeString( $textMD5 ) . "'" );

        $text = $rows[0]['text'];
        $action = $rows[0]['action'];

        $realPath = array( $text );
        $actionPath = array( $action );
        $path = array( $rows[0] );

        while ( $id != 0 )
        {
            $query = "SELECT * FROM ezurlalias_ml WHERE id={$id}";
            $rows = $db->arrayQuery( $query );
            if ( count( $rows ) == 0 )
            {
                break;
            }
            $result = eZURLAliasML::choosePrioritizedRow( $rows );
            if ( !$result )
            {
                $result = $rows[0];
            }
            $id = (int)$result['parent'];
            array_unshift( $path, $result );
            array_unshift( $realPath, $result['text'] );
            array_unshift( $actionPath, $result['action'] );
        }
        $realPath = implode( '/', $realPath );
        $ret = array( 'real_path' => $realPath,
                      'action_path'=> $actionPath,
                      'url_data' => $path,
                      'lang' => $language );
        return serialize( $ret );
    }

    /**
     * Makes eZINI reload its cache of debug.ini to get information from override files
     * in extensions
     *
     * @return void
     */
    public static function setupDebug()
    {
        // We are reloading the debug.ini settings here to get overrided values from extensions
        $ini = eZINI::instance( 'debug.ini' );
        $ini->loadCache();
    }
}

?>
