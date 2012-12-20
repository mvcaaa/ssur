<?php
/**
 * File containing the ezpMigratedUrlAlias class
 *
 * @copyright Copyright (C) 1999-2008 eZ Systems AS. All rights reserved.
 * @license http://ez.no/licenses/gnu_gpl GNU GPLv2
 * @package UrlAliasMigration
 *
 */

/**
 * ezpMigratedUrlAlias handles operations and persistence of migrated url
 * aliases.
 * 
 * This class is based on eZPathElement, but contains extra functionality
 * and tweaks which makes it more helpful for migration purposes.
 *
 * @package UrlAliasMigration
 */
class ezpMigratedUrlAlias extends eZPersistentObject
{
    /**
     * Denotes an url alias located on the root.
     */
    const PLACEMENT_ROOT = 0;

    /**
     * Denotes an url alias located under other nodes in a subtree.
     */
    const PLACEMENT_SUBTREE = 1;

    /**
     * Initializes a new migrated URL alias from database row.
     * If 'path' is set it will be cached in $Path.
     */
    public function ezpMigratedUrlAlias( $row )
    {
        $this->Path = null;
        $this->PathArray = null;
        $this->AlwaysAvailable = null;
        if ( array_key_exists( 'always_available', $row )  )
        {
            $this->AlwaysAvailable = $row['always_available'];
        }
        $this->ExtraUrlData = null;
        $this->RealPathStored = null;
        $this->NewRoot = null;
        if ( isset( $row['path'] ) )
        {
            $this->Path = $row['path'];
        }
        $this->eZPersistentObject( $row );
    }

    /**
     * Returns definition of the object
     *
     * @return array
     */
    public static function definition()
    {
        return array( "fields" => array( "id" => array( 'name' => 'ID',
                                                        'datatype' => 'integer',
                                                        'default' => 0,
                                                        'required' => true ),
                                         "parent" => array( 'name' => 'Parent',
                                                            'datatype' => 'integer',
                                                            'default' => 0,
                                                            'required' => true ),
                                         "lang_mask" => array( 'name' => 'LangMask',
                                                               'datatype' => 'integer',
                                                               'default' => 0,
                                                               'required' => true ),
                                         "text" => array( 'name' => 'Text',
                                                          'datatype' => 'string',
                                                          'default' => '',
                                                          'required' => true ),
                                         "text_md5" => array( 'name' => 'TextMD5',
                                                              'datatype' => 'string',
                                                              'default' => '',
                                                              'required' => true ),
                                         "action" => array( 'name' => 'Action',
                                                            'datatype' => 'string',
                                                            'default' => '',
                                                            'required' => true ),
                                         "action_type" => array( 'name' => 'ActionType',
                                                                 'datatype' => 'string',
                                                                 'default' => '',
                                                                 'required' => true ),
                                         "link" => array( 'name' => 'Link',
                                                          'datatype' => 'integer',
                                                          'default' => 0,
                                                          'required' => true ),
                                         "is_alias" => array( 'name' => 'IsAlias',
                                                                 'datatype' => 'integer',
                                                                 'default' => 0,
                                                                 'required' => true ),
                                         "is_original" => array( 'name' => 'IsOriginal',
                                                                 'datatype' => 'integer',
                                                                 'default' => 0,
                                                                 'required' => true ),
                                         "is_restored" => array( 'name' => 'IsRestored',
                                                                 'datatype' => 'integer',
                                                                 'default' => 0,
                                                                 'required' => true ),
                                         "lang_mask_adjusted" => array( 'name' => 'LangMaskAdjusted',
                                                                 'datatype' => 'integer',
                                                                 'default' => 0,
                                                                 'required' => true ),
                                         "alias_redirects" => array( 'name' => 'AliasRedirects',
                                                                     'datatype' => 'integer',
                                                                     'default' => 1,
                                                                     'required' => true ),
                                         "extra_data" => array( 'name' => 'ExtraData',
                                                                          'datatype' => 'string',
                                                                          'default' => '',
                                                                          'required' => true ), ),

                      "keys" => array( "parent", "text_md5" ),
                      "function_attributes" => array( 'path' => 'getPath',
                                                      'path_array' => 'getPathArray',
                                                      'real_path_stored' => 'realPathStored',
                                                      'always_available' => 'alwaysAvailable',
                                                      'action_url' => 'actionURL',
                                                      'language_object' => 'getLanguage',
                                                      'url_data' => 'urlData',
                                                     ),
                      "class_name" => "ezpMigratedUrlAlias",
                      "name" => "ezurlalias_ml_migrate" );
    }

    /**
     * Calculates the full path for the current url path element and returns this.
     * If $id is provided the path is calcaulated starting form that id instead of the
     * object property 'parent' this is needed when calculating live path values of migrated
     * url aliases.
     *
     * @param int $id urlalias id to start path calculation at (top-element).
     * @return string
     */
    public function getPath( $id = false )
    {
        if ( $id === false and $this->Path !== null )
            return $this->Path;

        // Fetch path 'text' elements of correct parent path
        $path = array( $this->Text );
        if ( !$id )
        {
            $id = (int)$this->Parent;
        }
        $db = eZDB::instance();
        while ( $id != 0 )
        {
            $query = "SELECT parent, lang_mask, text FROM ezurlalias_ml WHERE id={$id}";
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
            array_unshift( $path, $result['text'] );
        }
        $this->Path = implode( '/', $path );
        return $this->Path;
    }

    /**
     * Calculates the full path of the current url path element, and returns this as
     * an array of ezpMigratedUrlAlias objects, for each element of the path.
     *
     * @param int $id The id to start the path calculation at, i.e. the top-element.
     * @return mixed (array=>ezpMigratedUrlAlias)
     */
    public function getPathArray( $id = false )
    {
        if ( $id === false and $this->PathArray !== null )
            return $this->PathArray;

        // Fetch path 'text' elements of correct parent path
        $path = array( $this );
        if ( !$id )
            $id = (int)$this->Parent;
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
            array_unshift( $path, new ezpMigratedUrlAlias( $result ) );
        }
        $this->PathArray = $path;
        return $this->PathArray;
    }

    /**
     * Returns a 1 if the current element is flagged for always being available
     * or returns a 0 if it is only available in the specified lang_mask
     *
     * @return int
     */
    public function alwaysAvailable()
    {
        if ( !is_null( $this->AlwaysAvailable ) )
        {
            return $this->AlwaysAvailable;
        }

        $this->AlwaysAvailable = $this->LangMask % 2;
        return $this->AlwaysAvailable;
    }

    /**
     * Converts the action property into a real url which responds to the
     * module/view on the site.
     * 
     * @return string
     */
    public function actionURL()
    {
        return eZURLAliasML::actionToUrl( $this->Action );
    }

    /**
     * Returns the eZContentLanguage object which maches the element language mask.
     * @return eZContentLanguage|false
     */
    public function getLanguage()
    {
        return eZContentLanguage::fetch( $this->LangMask );
    }

    /**
     * Returns extra url information which was stored in the url alias migration process.
     * 
     * This information includes the full path of the alias at migration-time,
     * information about the action values for each element in the path, as well
     * as copies of of eZURLAliasML objects for each path element, also from migration
     * time.
     *
     * @return array
     */
    public function urlData()
    {
        if ( is_null( $this->ExtraUrlData ) )
        {
            $this->ExtraUrlData = unserialize( $this->ExtraData );
        }
        return $this->ExtraUrlData;
    }

    /**
     * Checks where the current alias is placed in the URL tree.
     *
     * @return int
     */
    public function checkAliasPlacement()
    {
        $parent = $this->attribute( 'parent' );
        $realPath = $this->attribute( 'real_path_stored' );

        if ( $parent == 0 )
        {
            eZDebugSetting::writeDebug( "urlalias-migration-checks", "Alias is placed on root [{$realPath}]", __FUNCTION__ );
            return self::PLACEMENT_ROOT;
        }
        else
        {
            eZDebugSetting::writeDebug( "urlalias-migration-checks", "Alias is placed under a subtree [{$realPath}]", __FUNCTION__ );
            return self::PLACEMENT_SUBTREE;
        }
    }

    /**
     * Checks if an alias is already defined in the live url alias table
     *
     * @return boolean
    */
    public function checkAliasExists()
    {
        $path = $this->attribute( 'real_path_stored' );
        $ret = eZURLAliasML::fetchByPath( $path );
        if ( count( $ret ) > 0 )
        {
            eZDebugSetting::writeDebug( "urlalias-migration-checks", "Alias exists [{$path}]", __FUNCTION__ );
            return false;
        }
        else
        {
            eZDebugSetting::writeDebug( "urlalias-migration-checks", "Alias does not already exist [{$path}]", __FUNCTION__ );
            return true;
        }
    }


    /**
     * Checks if the node destination for eznode actions are present in the system.
     * Next if the node is present, the content object is checked to verify it
     * is in a published state.
     * 
     * For module actions the function checks if the specified module exists
     * in the system.
     *
     * @return boolean
     */
    public function checkDestinationExists()
    {
        $ret = false;
        $nodeId = eZURLAliasML::nodeIDFromAction( $this->attribute( 'action' ) );
        if ( $nodeId )
        {
            $node = eZContentObjectTreeNode::fetch( $nodeId );
            if ( $node )
            {
                eZDebugSetting::writeDebug( "urlalias-migration-checks", "Node exists [node_id={$nodeId}]", __FUNCTION__ );
                // Check that content object is published
                $object = $node->attribute( 'object' );

                if ( $object )
                {
                    if ( $object->attribute( 'status' ) == eZContentObject::STATUS_PUBLISHED )
                    {
                        eZDebugSetting::writeDebug( "urlalias-migration-checks", "Object is published [id={$object->attribute( 'id' )}]", __FUNCTION__ );
                        $ret = true;
                    }
                    else
                    {
                        eZDebugSetting::writeDebug( "urlalias-migration-checks", "Object is not published [id={$object->attribute( 'id' )}]", __FUNCTION__ );
                    }
                }

            }
            else
            {
                eZDebugSetting::writeDebug( "urlalias-migration-checks", "Node does not exist [node_id={$nodeId}]", __FUNCTION__ );
            }
        }
        else if ( $this->attribute( 'action_type' ) == 'module' )
        {
            $actionPattern = "#^([a-zA-Z0-9_]+):(.+)?$#";
            if ( preg_match( $actionPattern, $this->attribute( 'action' ), $matches ) )
            {
                $actionType = $matches[1];
                $destination = $matches[2];

                if ( $actionType == 'module' )
                {
                    $moduleUrlPattern = "#^([a-zA-Z0-9]+)/#";
                    if ( preg_match( $moduleUrlPattern, $destination, $moduleMatches ) )
                    {
                        $moduleName = $moduleMatches[1];
                        $module = eZModule::exists( $moduleName );
                        if ( $module instanceof eZModule )
                        {
                            $ret = true;
                            eZDebugSetting::writeDebug( "urlalias-migration-checks", "Module exists [name={$module->attribute( 'name' )}]", __FUNCTION__ );
                        }
                        else
                        {
                            eZDebugSetting::writeDebug( "urlalias-migration-checks", "Module does not exist [name={$module->attribute( 'name' )}]", __FUNCTION__ );
                        }
                    }
                }
            }
        }

        return $ret;
    }

    /**
     * Check if the provided language is a valid language in the live system
     * if it exists, this language true returned, if not false is returned.
     *
     * @return boolean
     */
    public function checkLanguage()
    {
        $ret = false;
        $oldLocale = $this->attribute( 'lang_mask');

        $languageObject = eZContentLanguage::fetch( $oldLocale );

        if ( $languageObject instanceof eZContentLanguage )
        {
            eZDebugSetting::writeDebug( "urlalias-migration-checks", "Language exists [id={$oldLocale}]", __FUNCTION__ );
            $ret = true;
        }
        else
        {
            eZDebugSetting::writeDebug( "urlalias-migration-checks", "Language does not exist [id={$oldLocale}]", __FUNCTION__ );
        }

        return $ret;
    }

    /**
     * Performs checks on the current ezpMigratedUrlAlias instance to see if
     * it is possible to restore the migrated alias, if restoration is possible
     * this will be attempted.
     * 
     * For aliases which are placed in subtrees, this subtree will be validated
     * and if virtual path elements are found to be missing these will be recreated.
     *
     * @return boolean
     */
    public function analyse()
    {
        $ret = false;
        $aliasExtraData = $this->attribute( 'url_data' );
        eZDebugSetting::writeDebug( "urlalias-migration-extra", $aliasExtraData, "Extra url data [". __FUNCTION__ . "]" );

        $aliasPlacement = $this->checkAliasPlacement();
        $isHistoryEntry = $this->isHistoryEntry();

        if ( $this->checkAliasExists()
             and $this->checkDestinationExists()
             and $this->checkLanguage()
           )
        {
            if ( $aliasPlacement == self::PLACEMENT_SUBTREE )
            {
                $pathWalker = new ezpUrlAliasPathWalker( $aliasExtraData );

                $pathResult = $pathWalker->checkPath();
                eZDebugSetting::writeDebug( "urlalias-migration-extra", $pathWalker, __FUNCTION__ );
                if ( $pathResult )
                {
                    eZDebugSetting::writeDebug( "urlalias-migration-checks", "Restore for subtree possible", __FUNCTION__ );
                    $newRoot = $pathWalker->newAliasRoot();
                    $this->NewRoot = $newRoot;
                    eZDebugSetting::writeDebug( "urlalias-migration-checks", "New root for alias will be: {$newRoot}", __FUNCTION__ );

                    list( $alias, $action ) = $pathWalker->newAliasInfo();
                    eZDebugSetting::writeDebug( "urlalias-migration-checks", "$alias pointing to $action can be recreated at {$pathWalker->parentPath()}" );

                    $ret = true;
                    $this->restore( $isHistoryEntry );
                }
                else
                {
                    eZDebugSetting::writeDebug( "urlalias-migration-checks", "Restore not possible, skipping", __FUNCTION__ );
                }
            }
            else if ( $aliasPlacement == self::PLACEMENT_ROOT )
            {
                eZDebugSetting::writeDebug( "urlalias-migration-checks", "Alias valid for restoration", __FUNCTION__ );
                $ret = true;
                $this->restore( $isHistoryEntry );
            }
        }
        return $ret;
    }

    /**
     * Restores a migrated custom url alias with metadata calculated in the 
     * ezpMigratedUrlAlias class.
     * 
     * If the <var>$restoreHistoryEntry</var> is set to true, the method will recreate
     * an url alias history entri instead of a custom url alias.
     *
     * @param boolean $restoreHistoryEntry
     * @return void
     */
    public function restore( $restoreHistoryEntry = false )
    {
        // Set up data for re-integration
        $parentID = 0;
        $linkID   = true;
        $action = $this->attribute( 'action' );

        if ( $this->attribute( 'action_type' ) != 'module' )
        {
            $node = eZContentObjectTreeNode::fetch( eZURLAliasML::nodeIDFromAction( $action ) );
            $contentObject = $node->object();
            $alwaysMask = ( $contentObject->attribute( 'language_mask' ) & 1 );

            //include_once( 'kernel/classes/ezurlaliasquery.php' );
            $filter = new eZURLAliasQuery();
            $filter->actions = array( $action );
            $filter->type = 'name';
            $filter->limit = false;
            $existingElements = $filter->fetchAll();

            if ( count( $existingElements ) > 0 )
            {
                $linkID   = (int)$existingElements[0]->attribute( 'id' );
            }
        }
        else
        {
            $alwaysMask = (int)$this->attribute( 'always_available' );
        }
        $aliasText = $this->attribute( 'text' );
        $aliasRedirects = $this->attribute( 'alias_redirects' );

        // We should rely on the info in the migrated alias to be correct
        $language = $this->attribute( 'language_object' );
        $mask = $language->attribute( 'id' );
        $mask |= $alwaysMask;
        $parentID = ( $this->NewRoot == null )? 0 : $this->NewRoot;

        if ( !$restoreHistoryEntry )
        {

            $result = eZURLAliasML::storePath( $aliasText, $action,
                                               $language, $linkID, $alwaysMask, $parentID,
                                               true, false, false, $aliasRedirects );

            eZDebugSetting::writeDebug( "urlalias-migration-extra", $result, __FUNCTION__ );
            if ( $result['status'] == true )
            {
                // When the alias is successfully restored we mark it as such in the db
                $this->setAttribute( 'is_restored', 1 );
                $this->store();
            }
        }
        else
        {
            $options = array(
                                'link' => $linkID,
                                'parent' => $parentID,
                                'text' => $aliasText,
                                'text_md5' => $this->attribute( 'text_md5' ),
                                'lang_mask' => $mask,
                                'action' => $action,
                                'alias_redirects' => ( $aliasRedirects? 1 : 0 ),
                                'is_original' => 0,
                                'is_alias' => 0,
                            );

            $element = new eZURLAliasML( $options );
            $element->store();

            $this->setAttribute( 'is_restored', 1 );
            $this->store();
        }
    }

    /**
     * Checks whether the current object is a url alias history entry
     *
     * @return boolean
     */
    public function isHistoryEntry()
    {
        // Checks to put in the analyse method to filter out history entries
        $actionType = $this->attribute( 'action_type' );
        $isOriginal = $this->attribute( 'is_original' );
        $isAlias = $this->attribute( 'is_alias' );
        $isHistoryEntry = ( $isOriginal == 0 and $isAlias == 0 and $actionType != 'nop' );
        $isHistoryOutput = $isHistoryEntry? "History element" : "Not history element";
        eZDebugSetting::writeDebug( "urlalias-migration-checks", $isHistoryOutput, __FUNCTION__ );
        return $isHistoryEntry;
    }

    /**
     * Return the flattened full path of the migrated url alias
     *
     * @return string
     */
    public function realPathStored()
    {
        if ( !is_null( $this->RealPathStored ) )
        {
            return $this->RealPathStored;
        }

        $urlExtraData = $this->attribute( 'url_data' );
        $this->RealPathStored = $urlExtraData['real_path'];
        return $this->RealPathStored;
    }
}
?>
