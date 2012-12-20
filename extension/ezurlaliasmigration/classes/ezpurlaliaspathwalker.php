<?php
/**
 * File containing the ezpUrlAliasPathWalker class
 *
 * @copyright Copyright (C) 1999-2008 eZ Systems AS. All rights reserved.
 * @license http://ez.no/licenses/gnu_gpl GNU GPLv2
 * @package UrlAliasMigration
 *
 */

/**
* The ezpUrlAliasPathWalker class represents a full url alias path, it contains
* methods to verify and add missing path elements.
* 
* This class represents the full extent of an url alias path. Internally the
* the top nodes (leaf-nodes) are separated out, and an representation of the parent
* path is made. This path can this way be validated recursively until the root element
* is found.
* 
* Url aliases may consist of virtual path elements, or nop-elements. Such elements
* cannot be automically regenerated from the node tree data structure, and this
* class provides a way to recreate them from migrated url alias data. This is done
* by inspecting the action values, and by check parent paths of virtual path elements
* recursively.
* 
* @package UrlAliasMigration
*/
class ezpUrlAliasPathWalker
{
    /**
     * The full path of an url alias, as it appeared when it was migrated,
     * before urls were reset.
     *
     * @var string
     */
    public $realPath = null;

    /**
     * The full array of of action values for <var>$realPath</var>. Values ordered by
     * root element first, and top element last.
     *
     * @var array
     */
    public $actionPath = null;

    /**
     * A container for the extra url data, which was stored upon url alias migration.
     * This is not used for now.
     *
     * @var mixed
     */
    public $urlData = null;

    /**
     * The alias text of the top element / leaf node from <var>$realPath</var>. That
     * is the actualy alias element of the path.
     *
     * @var string
     */
    public $aliasText = null;

    /**
     * Holds the action value for <var>$aliasText</var>
     *
     * @var string
     */
    public $aliasAction = null;

    /**
     * Holds the parent path of $realPath. That is <var>$realPath</var>,
     * except the top element.
     *
     * @var string
     */
    public $parentPath = null;

    /**
     * Holds the action values for <var>$parentPath</var>.
     *
     * @var array
     */
    public $parentActionPath = null;

    /**
     * Holds a reference to the ezpUrlAliasPathWalker object for the $parentPath of this
     * object.
     *
     * @var ezpUrlAliasPathWalker
     */
    public $parent = null;

    /**
     * Holds thew new element id to be used as root for the current alias of this object.
     *
     * @var int
     */
    public $root = null;

    /**
     * Holds the url alias element for <var>$parentPath</var>
     * 
     * @var eZURLAliasML
     */
    public $urlElement = null;

    /**
     * Constructor
     * 
     * Creates an ezpUrlAliasPathWalker object out of the extra url data which
     * was saved in the migration process.
     * 
     * Example:
     * <code>
     * $params = array( 'real_path' => '/TestRoot/Alias',
     *                  'action_path' => array( 'eznode:200', 'eznode:201' ) );
     * $pathWalker = new ezpUrlAliasPathWalker( $params );
     * </code>
     *
     * @param array $urlData 
     */
    public function ezpUrlAliasPathWalker( $urlData = null )
    {
        if ( is_array( $urlData ) )
        {
            $this->realPath = $urlData['real_path'];
            $this->actionPath = $urlData['action_path'];
            // Not setting the url data variable yet, as it might not be needed.
            // $this->urlData = $urlData['url_data'];
        }
    }

    /**
     * Returns the parent path of the real path provided to the constructor at object
     * initialisation.
     * 
     * Example:
     * <pre>
     * /example/subfolder/alias ==> /example/subfolder
     * </pre>
     *
     * @return string
     */
    public function parentPath()
    {
        if ( !is_null( $this->parentPath ) )
        {
            return $this->parentPath;
        }
        $this->init();
        return $this->parentPath;
    }

    /**
     * Returns an array of the action values for the parent path elements for the alias
     * which was provided to the constructor.
     * 
     * @return array
     */
    public function parentActionPath()
    {
        if ( !is_null( $this->parentActionPath ) )
        {
            return $this->parentActionPath;
        }
        $this->init();
        return $this->parentActionPath;
    }

    /**
     * Sets up the internal data structures which are required for to perform several
     * of the operations in the class.
     * 
     * This method is meant to be used internally in the class.
     * 
     * Specifically this method sets up the parent path, and parent action path information.
     *
     * @return void
     */
    protected function init()
    {
        // Ready infomration about paths
        if ( !empty( $this->realPath ) )
        {
            $pathArray = split( '/', $this->realPath );
            $this->aliasText = array_pop( $pathArray );
            $this->parentPath = join( $pathArray, '/' );
        }

        // Ready information about action paths
        if ( is_array( $this->actionPath ) )
        {
            $this->parentActionPath = $this->actionPath;
            $this->aliasAction = array_pop( $this->parentActionPath );
        }
    }

    /**
     * checkPath() checks the path the class was initialised with from top element to
     * the root, and verifies the path is a valid path.
     * 
     * The methods finds the live value of the migrated path entries, since id numbers
     * most likely change after a reset of the url table. It then compares the action
     * values of the migrated path and the live one. If all elements match, the alias
     * can be restored to the given path.
     * 
     * In case of virtual path elements it checks the path recursively above such elements,
     * and recreates them, if the path is valid.
     *
     * @return boolean
     */
    public function checkPath()
    {
        $ret = true;
        $pp = $this->parentPath();
        $pa = $this->parentActionPath();
        // eZDebugSetting::writeDebug( "urlalias-migration-pathwalker-debug", $this, "path walker object [" . __FUNCTION__ . "]" );

        // Check if we are at the root of the url tree, if so we exit recursion
        if ( $pp == null and $pa == null )
        {
            return $ret;
        }

        // Check if the given path exist in the real system
        $this->initUrlElement();

        if ( $this->urlElement )
        {
            // We get the live url path element data so we can compare action values
            $realPathArray = $this->getPathArray( $this->urlElement );
            eZDebugSetting::writeDebug( "urlalias-migration-pathwalker-debug", $realPathArray, __FUNCTION__ );

            $nReal = count( $realPathArray );
            $nMigrated = count( $pa );

            if ( $nReal === $nMigrated )
            {
                eZDebugSetting::writeDebug( "urlalias-migration-pathwalker-debug", "Number of action elements match, comparing.", __FUNCTION__ );
                for ($i=$nReal-1; $i >= 0;  $i--)
                {
                    $realAction = $realPathArray[$i]->attribute( 'action' );
                    $storedAction = array_pop( $pa );

                    eZDebugSetting::writeDebug( "urlalias-migration-pathwalker-debug", "Real action: " . $realAction, __FUNCTION__ );
                    eZDebugSetting::writeDebug( "urlalias-migration-pathwalker-debug", "Stored action: " . $storedAction, __FUNCTION__ );

                    if ( $realAction != $storedAction )
                    {
                        $message = "Actions do not match\n";
                        $message .= "The stored action pointed to: {$storedAction}\n";
                        $message .= "The real action is pointing to: {$realAction}";
                        eZDebugSetting::writeDebug( "urlalias-migration-pathwalker", $message, __FUNCTION__ );
                        $ret = false;
                    }
                }
            }
        }
        else
        {
            // We need to check for nops. if element is a nop we still need to
            // check the path above the nop element, to see if that and its
            // parents are also valid.

            $params = array( 'real_path' => $pp, 'action_path'=> $pa );
            $this->parent = new ezpUrlAliasPathWalker( $params );

            if ( $this->parent->isVirtualPathElement() )
            {
                eZDebugSetting::writeDebug( "urlalias-migration-pathwalker-debug", $this, "Starting check for virtual path elements [" . __FUNCTION__ . "]" );

                if ( $this->parent->checkPath() )
                {
                    eZDebugSetting::writeDebug( "urlalias-migration-pathwalker", "Recursive path check OK for virtual path element creation", __FUNCTION__ );
                    // We have a good parent path, can recreate nop element
                    // create a new nop for virtual path element

                    $nopRoot = $this->parent->newAliasRoot();
                    eZDebugSetting::writeDebug( "urlalias-migration-pathwalker-debug", $nopRoot, "Parent for new virtual path element" );

                    // The root element is a special case, if we hit it, we
                    // have to change the parent from 1 to 0
                    if ( $nopRoot == 1 )
                        $nopRoot = 0;

                    // We don't associate the virtual path element with any
                    // specific language, but make it always available to all
                    $virtualPathElement = eZURLAliasML::create( $this->parent->aliasText, $this->parent->aliasAction, $nopRoot, 1 );
                    $virtualPathElement->store();
                    eZDebugSetting::writeDebug( "urlalias-migration-pathwalker-debug", $virtualPathElement, "New virtual path element object" );
                    eZDebugSetting::writeDebug( "urlalias-migration-pathwalker-debug", $virtualPathElement->getPath(), "New virtual path string" );
                    return true;
                }
            }

            // We don't have a valid path
            $ret = false;
        }
        return $ret;
    }

    /**
     * Calculates full path for given <var>$topElement</var> and returns an array of
     * eZURLAliasML objects from <var>$topElement</var> to the root.
     *
     * @param eZURLAliasML $topElement 
     * @return mixed
     */
    public function getPathArray( $topElement )
    {
        if ( !$topElement instanceof eZURLAliasML )
        {
            return array();
        }

        $path = array( $topElement );
        $id = $topElement->attribute( 'parent' );

        $db = eZDB::instance();
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
            array_unshift( $path, new eZURLAliasML( $result ) );
        }
        return $path;
    }


    /**
     * Fetches and initialises the class' url element. This element is the element
     * of parent path.
     *
     * @return void
     */
    protected function initUrlElement()
    {
        $urlEntries = eZURLAliasML::fetchByPath( $this->parentPath() );
        if ( count( $urlEntries ) > 0 )
        {
            eZDebugSetting::writeDebug( "urlalias-migration-pathwalker-debug", $urlEntries, __FUNCTION__ );
            $this->urlElement = $urlEntries[0];
        }
    }

    /**
     * When a restoration is being done, this method returns the new parent id to use
     * for the alias being restored, with value from the live data.
     *
     * @return int
     */
    public function newAliasRoot()
    {
        // if this method is called a success for restoration of path elements should have occured, try to refetch, the correct value
        if ( is_null( $this->urlElement ) )
        {
            $this->initUrlElement();
        }
        return $this->urlElement->attribute( 'id' );
    }

    /**
     * Checks if the current alias being inspected is a virtual path element
     *
     * @return boolean
     */
    protected function isVirtualPathElement()
    {
        $this->init();
        return $this->aliasAction == "nop:";
    }

    /**
     * A convenience method to easily get the text of the alias and the action of the
     * alias which was just checked.
     *
     * @return mixed
     */
    public function newAliasInfo()
    {
        return array( $this->aliasText, $this->aliasAction );
    }
}

?>
