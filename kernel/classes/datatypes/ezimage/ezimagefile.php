<?php
//
// Definition of eZImageFile class
//
// Created on: <30-Apr-2002 16:47:08 bf>
//
// SOFTWARE NAME: eZ Publish
// SOFTWARE RELEASE: 4.0.1
// BUILD VERSION: 22260
// COPYRIGHT NOTICE: Copyright (C) 1999-2008 eZ Systems AS
// SOFTWARE LICENSE: GNU General Public License v2.0
// NOTICE: >
//   This program is free software; you can redistribute it and/or
//   modify it under the terms of version 2.0  of the GNU General
//   Public License as published by the Free Software Foundation.
//
//   This program is distributed in the hope that it will be useful,
//   but WITHOUT ANY WARRANTY; without even the implied warranty of
//   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//   GNU General Public License for more details.
//
//   You should have received a copy of version 2.0 of the GNU General
//   Public License along with this program; if not, write to the Free
//   Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
//   MA 02110-1301, USA.
//
//

/*!
  \class eZImageFile ezimagefile.php
  \ingroup eZDatatype
  \brief The class eZImageFile handles registered images

*/

//include_once( 'lib/ezdb/classes/ezdb.php' );
//include_once( 'kernel/classes/ezpersistentobject.php' );

class eZImageFile extends eZPersistentObject
{
    function eZImageFile( $row )
    {
        $this->eZPersistentObject( $row );
    }

    static function definition()
    {
        return array( 'fields' => array( 'id' => array( 'name' => 'id',
                                                        'datatype' => 'integer',
                                                        'default' => 0,
                                                        'required' => true ),
                                         'contentobject_attribute_id' => array( 'name' => 'ContentObjectAttributeID',
                                                                                'datatype' => 'integer',
                                                                                'default' => 0,
                                                                                'required' => true,
                                                                                'foreign_class' => 'eZContentObjectAttribute',
                                                                                'foreign_attribute' => 'id',
                                                                                'multiplicity' => '1..*' ),
                                         'filepath' => array( 'name' => 'Filepath',
                                                              'datatype' => 'string',
                                                              'default' => '',
                                                              'required' => true ) ),
                      'keys' => array( 'id' ),
                      'class_name' => 'eZImageFile',
                      'name' => 'ezimagefile' );
    }

    static function create( $contentObjectAttributeID, $filepath  )
    {
        $row = array( "contentobject_attribute_id" => $contentObjectAttributeID,
                      "filepath" => $filepath );
        return new eZImageFile( $row );
    }

    static function fetchForContentObjectAttribute( $contentObjectAttributeID, $asObject = false )
    {
        $rows = eZPersistentObject::fetchObjectList( eZImageFile::definition(),
                                                      null,
                                                      array( "contentobject_attribute_id" => $contentObjectAttributeID ),
                                                      null,
                                                      null,
                                                      $asObject );
        if ( !$asObject )
        {
            $files = array();
            foreach ( $rows as $row )
            {
                $files[] = $row['filepath'];
            }
            return array_unique( $files );
        }
        else
            return $rows;
    }
    /*!
      \return An array of ids and versions of ezimage ezcontentobject_attributes have \a $filepath.
    */
    static function fetchImageAttributesByFilepath( $filepath, $contentObjectAttributeID )
    {
       $db = eZDB::instance();
       $filepath = $db->escapeString( $filepath );
       $contentObjectAttributeID =(int) $contentObjectAttributeID;
       $query = "SELECT id, version
                 FROM   ezcontentobject_attribute
                 WHERE  id = $contentObjectAttributeID and
                        data_text like '%url=\"$filepath\"%'";

       $rows = $db->arrayQuery( $query );
       return $rows;
    }

    static function fetchByFilepath( $contentObjectAttributeID, $filepath, $asObject = true )
    {
        // Fetch by file path without $contentObjectAttributeID
        if ( $contentObjectAttributeID === false )
            return eZPersistentObject::fetchObject( eZImageFile::definition(),
                                                    null,
                                                    array( 'filepath' => $filepath ),
                                                    $asObject );

        return eZPersistentObject::fetchObject( eZImageFile::definition(),
                                                null,
                                                array( 'contentobject_attribute_id' => $contentObjectAttributeID,
                                                       'filepath' => $filepath ),
                                                $asObject );
    }

    static function moveFilepath( $contentObjectAttributeID, $oldFilepath, $newFilepath )
    {
        $db = eZDB::instance();
        $db->begin();

        eZImageFile::removeFilepath( $contentObjectAttributeID, $oldFilepath );
        $result = eZImageFile::appendFilepath( $contentObjectAttributeID, $newFilepath );

        $db->commit();
        return $result;
    }

    static function appendFilepath( $contentObjectAttributeID, $filepath, $ignoreUnique = false )
    {
        if ( empty( $filepath ) )
            return false;

        if ( !$ignoreUnique )
        {
            // Fetch ezimagefile objects having the $filepath
            $imageFiles = eZImageFile::fetchByFilePath( false, $filepath, false );
            // Checking If the filePath already exists in ezimagefile table
            if ( isset( $imageFiles[ 'contentobject_attribute_id' ] ) )
                return false;
        }
        $fileObject = eZImageFile::fetchByFilePath( $contentObjectAttributeID, $filepath );
        if ( $fileObject )
            return false;
        $fileObject = eZImageFile::create( $contentObjectAttributeID, $filepath );
        $fileObject->store();
        return true;
    }

    static function removeFilepath( $contentObjectAttributeID, $filepath )
    {
        if ( empty( $filepath ) )
            return false;
        $fileObject = eZImageFile::fetchByFilePath( $contentObjectAttributeID, $filepath );
        if ( !$fileObject )
            return false;
        $fileObject->remove();
        return true;
    }

    static function removeForContentObjectAttribute( $contentObjectAttributeID )
    {
        eZPersistentObject::removeObject( eZImageFile::definition(), array( 'contentobject_attribute_id' => $contentObjectAttributeID ) );
    }


    /// \privatesection
    public $ID;
    public $ContentObjectAttributeID;
    public $Filepath;
}

?>
