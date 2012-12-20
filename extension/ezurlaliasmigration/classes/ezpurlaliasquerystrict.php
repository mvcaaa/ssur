<?php
/**
 * File containing the ezpUrlAliasQueryStrict class
 *
 * @copyright Copyright (C) 1999-2008 eZ Systems AS. All rights reserved.
 * @license http://ez.no/licenses/gnu_gpl GNU GPLv2
 * @package UrlAliasMigration
 *
 */

/**
 * The ezpUrlAliasQueryStrict class simply provides the same functionality as
 * eZURLAliasQuery, with one difference, it does more checks to verify that the
 * source data is valid, and provide fallbacks to system default values where
 * prudent.
 *
 * One example of this is the lang_mask field of url alias entries, should this
 * contain corrupted data, this class will fall back to the system's default
 * language.
 *
 * @package UrlAliasMigration
 */
class ezpUrlAliasQueryStrict extends eZURLAliasQuery
{
    /**
     * Constructor
     *
     */
    public function ezpUrlAliasQueryStrict()
    {
    }

    /**
     * Fetches the items in the current range (offset/limit) using the current
     * filters as specified with the properties.
     * 
     * Can also be fetched from templates by using the 'items' property.
     * 
     * Overridden to make sure the correct method is being called
     */
    public function fetchAll()
    {
        if ( $this->items !== null )
            return $this->items;

        if ( $this->query === null )
        {
            $this->query = $this->generateSQL();
        }
        if ( $this->query === false )
            return array();
        $query = "SELECT * {$this->query} ORDER BY {$this->order}";
        $params = array( 'offset' => $this->offset,
                         'limit'  => $this->limit );
        $db = eZDB::instance();
        $rows = $db->arrayQuery( $query, $params );
        if ( count( $rows ) == 0 )
            $this->items = array();
        else
            $this->items = ezpUrlAliasQueryStrict::makeList( $rows );
        return $this->items;
    }


    /**
     * Takes an array with database data in $row and turns them into
     * eZPathElement objects. Entries which have multiple languages will be
     * turned into multiple objects.
     *
     * Language masks which does not contain correct data will not cause
     * multiple path element objects to be created.
     *
     * @static
     * @return mixed
     */
    public static function makeList( $rows, $storageMode = false )
    {
        if ( !is_array( $rows ) || count( $rows ) == 0 )
            return array();

        $list = array();

        $maxNumberOfLanguges = eZContentLanguage::MAX_COUNT;
        $maxInteger = pow( 2, $maxNumberOfLanguges );
        $defaultLanguage = eZContentLanguage::topPriorityLanguage();

        foreach ( $rows as $row )
        {
            // Applying this bit-logic on negative numbers, will have unexpected results.
            if ( $row['lang_mask'] < 0 or $row['lang_mask'] > $maxInteger or $row['lang_mask'] == 1 )
            {
                // we fallback on default language
                $row['lang_mask'] = $defaultLanguage->attribute( 'id' );

                // And we make the element always available, this to help for
                // situations where the real original language was something
                // else than the system default language.
                $row['lang_mask'] |= 1;

                // Finally we mark the lang_mask as being adjusted so feedback
                // can be given about this change to the user in the UI
                $row['lang_mask_adjusted'] = 1;
            }

            if ( !$storageMode )
            {
                $row['always_available'] = $row['lang_mask'] % 2;
                $mask = $row['lang_mask'] & ~1;

                for ( $i = 1; $i < $maxNumberOfLanguges; ++$i )
                {
                    $newMask = 1 << $i;
                    if ( ($newMask & $mask) > 0 )
                    {
                        $row['lang_mask'] = $newMask;
                        $list[] = $row;
                    }
                }
            }
            else
            {
                $list[] = $row;
            }
        }

        $objectList = eZPersistentObject::handleRows( $list, 'ezpMigratedUrlAlias', true );
        return $objectList;
    }
}
?>
