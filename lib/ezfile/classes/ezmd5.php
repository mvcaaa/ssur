<?php
//
// Definition of eZMD5 class
//
// Created on: <04-Feb-2004 22:01:19 kk>
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

/*! \file ezmd5.php
*/

/*!
  \class eZMD5 ezmd5.php
  \brief Class handling MD5 file operations
*/

class eZMD5
{
    /*!
     \static

     Check MD5 sum file to check if files have changed. Return array of changed files.

     \param file name of md5 check sums

     \return array of missmatching files.
    */
    static function checkMD5Sums( $file )
    {
        //include_once( 'lib/ezfile/classes/ezfile.php' );
        $lines = eZFile::splitLines( $file );
        $result = array();

        if ( is_array( $lines ) )
        {
            foreach ( array_keys( $lines ) as $key )
            {
                $line =& $lines[$key];
                if ( strlen( $line ) > 34 )
                {
                    $md5Key = substr( $line, 0, 32 );
                    $filename = substr( $line, 34 );
                    if ( !file_exists( $filename ) || $md5Key != md5_file( $filename ) )
                    {
                        $result[] = $filename;
                    }
                }
            }
        }

        return $result;
    }
}
?>
