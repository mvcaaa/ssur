<?php
/**
 * File containing the ezpUrlAliasMigrationController class
 *
 * @copyright Copyright (C) 1999-2008 eZ Systems AS. All rights reserved.
 * @license http://ez.no/licenses/gnu_gpl GNU GPLv2
 * @package UrlAliasMigration
 *
 */

/**
 * Super class for controllers used in the url alias migration extension.
 * 
 * This class simply provide shared functionality between the controllers, such as
 * script progress output.
 *
 * @package UrlAliasMigration
 */
class ezpUrlAliasMigrationController
{
    /**
     * Name of the calllback method to use during migration operations.
     */
    protected static $callbackMethod = null;

    /**
     * Set callback function which can be used to get progess report from the controller
     * classes when doing migration oeprations.
     *
     * @param callback $callback
     * @return void
     */
    public static function setProgressCallback( $callback )
    {
        self::$callbackMethod = $callback;
    }

    /**
     * Set the number of iteration for the current operation to $count.
     * 
     * If no callback method have been defined for the class, e.g. the controller is
     * triggered from web gui, no call will be made to eZScript.
     * 
     * @param int $count
     * @return void
     */
    public static function setProgressCount( $count )
    {
        // self::$iterationMax = $count;
        if ( self::$callbackMethod !== null )
        {
            eZScript::instance()->resetIteration( $count );
        }
    }

    /**
     * Triggers the callback function is one has been defined, if not, no action will
     * be performed.
     *
     * @param boolean $result 
     * @return void
     */
    public static function doCallback( $result )
    {
        if ( self::$callbackMethod !== null )
        {
            call_user_func( self::$callbackMethod, $result );
        }
    }
}
?>
