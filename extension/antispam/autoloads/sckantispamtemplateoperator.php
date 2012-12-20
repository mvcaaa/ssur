<?php

/*
    Antispam extension for eZ publish 3.x
    Copyright (C) 2005  SCK/CEN (Belgian Nuclear Research Centre)

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
*/

/*!
  \class   SckAntispamTemplateOperator sckantispamtemplateoperator.php
  \ingroup eZTemplateOperators
  \brief   Handles template operator SckAntispamTemplateOperator
  \version 1.0
  \date    Monday 19 September 2005 8:20:34 am
  \author  Hans Melis <hmelis@sckcen.be>
  \author  Tom Couwberghs <tcouwber@sckcen.be>

  Example:
\code
{antispam($challenge_word, $ini_block)}
\endcode
\code
{challenge($contentObjectAttribute)}
\endcode
\code
{antispam(challenge($contentObjectAttribute), $ini_block)}
\endcode
*/
include_once( 'lib/ezutils/classes/ezhttptool.php' );
include_once( "lib/ezutils/classes/ezini.php" );
include_once( "lib/ezutils/classes/ezsys.php");
include_once( "lib/ezfile/classes/ezfile.php");

class SckAntispamTemplateOperator
{
    /*!
      Constructor, does nothing by default.
    */
    function SckAntispamTemplateOperator()
    {
    }

    /*!
     \return an array with the template operator name.
    */
    function operatorList()
    {
        return array( 'antispam', 'challenge' );
    }
    /*!
     \return true to tell the template engine that the parameter list exists per operator type,
             this is needed for operator classes that have multiple operators.
    */
    function namedParameterPerOperator()
    {
        return true;
    }

    /*!
     See eZTemplateOperator::namedParameterList
    */
    function namedParameterList()
    {
        return array( 'antispam' => array( 'challenge' => array( 'type' => 'string',
                                                                 'required' => true,
                                                                 'default' => false ),
                                           'ini_header' => array( 'type' => 'string',
                                                                  'required' => false,
                                                                  'default' => 'DefaultImageSettings' ) ),
                       'challenge' => array( 'co_attribute' => array(   'type' => 'object',
                                                                        'required' => true,
                                                                        'default' => false ) )
                       );
    }

    /*!
     Executes the PHP function for the operator cleanup and modifies \a $operatorValue.
    */
    function modify( &$tpl, &$operatorName, &$operatorParameters, &$rootNamespace, &$currentNamespace, &$operatorValue, &$namedParameters )
    {
        switch ( $operatorName )
        {
            case 'antispam':
            {
                $challenge = $namedParameters['challenge'];
                $iniHeader = $namedParameters['ini_header'];
                $ini = eZINI::instance( 'antispam.ini' );

                $settings =& $ini->group( 'DefaultImageSettings' );
                
                if( $ini->hasGroup( $iniHeader ) )
                {
                    unset( $settings );
                    $settings =& $ini->group( $iniHeader );
                }
                else
                {
                    $iniHeader = 'DefaultImageSettings';
                }
                
                $spacePerChar = $settings['Width'] / ( strlen( $challenge ) + 1 );
                
                $bgColor =& $ini->variableArray( $iniHeader, 'BackgroundColor' );
                $borderColor =& $ini->variableArray( $iniHeader, 'BorderColor' );
                $colors =& $ini->variableArray( $iniHeader, 'Colors' );
                $lineColors =& $ini->variableArray( $iniHeader, 'LineColors' );
                
                $img = imagecreatetruecolor( $settings['Width'], $settings['Height'] );
                
                $NamedColors = array( 'background' => imagecolorallocate( $img, $bgColor[0], $bgColor[1], $bgColor[2] ),
                                      'border' => imagecolorallocate( $img, $borderColor[0], $borderColor[1], $borderColor[2] )
                                    );
                $Colors = array();
                $LineColors = array();
                
                foreach( $colors as $color )
                {
                    $Colors[] = imagecolorallocate( $img, $color[0], $color[1], $color[2] );
                }
                
                foreach( $lineColors as $lineColor )
                {
                    $LineColors[] = imagecolorallocate( $img, $lineColor[0], $lineColor[1], $lineColor[2] );
                }
                
                // Fill the background
                imagefilledrectangle( $img, 1, 1, $settings['Width'] - 2, $settings['Height'] - 2, $NamedColors['background'] );
                imagerectangle( $img, 0, 0, $settings['Width'] - 1, $settings['Height'] - 1, $NamedColors['border'] );
                
                $yFactor = rand( 0 + ( $settings['MinimumFontSize'] * 1.3 ), $settings['Height'] - ( $settings['MinimumFontSize'] * 1.3 ) );
                
                // Draw the text
                for( $i = 0; $i < strlen( $challenge ); $i++ )
                {
                    $color = $Colors[rand( 0, count( $Colors ) - 1 )];
                    $fontsize = intval( $settings['MinimumFontSize'] ) + rand( 0, 8 );
                    $angle = intval( $settings['MinimumAngle'] ) + rand( 0, abs( intval( $settings['MinimumAngle'] ) ) * 2 );
                    $x = ( $i + 0.3 ) * $spacePerChar;
                    $base_y = $yFactor + rand( 0, 20 );

                    imagettftext( $img,
                                  $fontsize,
                                  $angle,
                                  $x,
                                  $base_y,
                                  $color,
                                  $settings['FontName'],
                                  $challenge[$i]
                                );
                }
                
                imageantialias( $img, true );
                
                for( $i = 0; $i < intval( $settings['NumberOfLines'] ); $i++ )
                {
                    $x1 = rand( 5, $settings['Width'] - 5 );
                    $y1 = rand( 5, $settings['Height'] - 5 );
                    
                    $x2 = $x1 - 4 + rand( 0, 8 );
                    $y2 = $y1 - 4 + rand( 0, 8 );
                    
                    imageline( $img, $x1, $y1, $x2, $y2, $LineColors[rand( 0, count( $LineColors ) - 1 )] );
                }
                
                // Generate filename
                $filename = sha1( $challenge ) . '.png';
                $path = eZSys::cacheDirectory() . '/'. $ini->variable( 'GeneralSettings', 'CacheDir' ) .'/';
                
                // check whether directory exists where we put image
                if( !eZDir::isWriteable( $path ) )
                {
                    eZDir::mkdir( $path );
                }
                
                $filepath = "$path$filename";
                
                imagepng( $img, $filepath );
                
                //print( $buffer );
                $operatorValue = $filepath;
                
            } break;
            case 'challenge':
            {
                $contentObjectAttribute =& $namedParameters['co_attribute'];
                $challenge = $this->generateChallenge($contentObjectAttribute);
                
                //store challenge in attribute and return
                
                //$contentObjectAttribute->setAttribute( 'data_text' , $challenge );
                //$contentObjectAttribute->store();
		eZHTTPTool::setSessionVariable('mysecretcode',md5($challenge));
                
                $operatorValue = $challenge;
                
            } break;
        }
    }
    
    function generateChallenge( &$objectAttribute )
    {
        $class_content = $objectAttribute->classContent();

        $length = $class_content['length'];

        $allowedSets = array();

        if($class_content['uppercase'] == true)
            $allowedSets[] = 'uppercase';

        if($class_content['lowercase'] == true)
            $allowedSets[] = 'lowercase';

        if($class_content['numeric'] == true)
            $allowedSets[] = 'numeric';

        if($class_content['custom'] == true)
        {
            for( $i=0; $i < strlen($class_content['customchars']) ; $i++)
            {
                $allowedSets[] = $class_content['customchars'][$i];
            }
        }

        return $this->generateChallengeData( $length, $allowedSets, $class_content['ignore'] );
    }

    function generateChallengeData( $length, $allowedSets, $ignore )
    {
        $possibleChars = array();

        foreach( $allowedSets as $set )
        {
            $charSet = array();

            switch($set)
            {
                case 'lowercase':
                {
                    for( $i=0; $i<26; $i++ )
                    {
                      $charSet[]=chr( $i+97 );
                    }
                } break;
                case 'uppercase':
                {
                    for( $i=0; $i<26; $i++ )
                    {
                      $charSet[]=chr( $i+65 );
                    }
                } break;
                case 'numeric':
                {
                    for( $i=0; $i<10; $i++ )
                    {
                      $charSet[]=$i;
                    }
                } break;
                default:
                {
                    $charSet = $set;
                } break;
            }

            $possibleChars = array_merge( $possibleChars, $charSet );
        }

        $ignore_chars = array();

        for($i=0; $i < strlen( $ignore ); $i++)
        {
            $ignore_chars[] = $ignore[$i];
        }

        foreach( $possibleChars as $key => $char )
        {
            if( in_array( $char, $ignore_chars ) )
                unset( $possibleChars[$key] );
        }

        sort( $possibleChars );

        $totalChars = count( $possibleChars );

        $challenge='';

        for( $i=0; $i < $length; $i++ )
        {
            $key = rand ( 0, $totalChars-1 );
            $challenge .= $possibleChars[$key];
        }

        return $challenge;
    }

    var $Operators;
}

?>
