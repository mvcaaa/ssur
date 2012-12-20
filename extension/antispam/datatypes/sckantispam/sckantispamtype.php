<?php

/*
    Antispam extension for eZ publish 3.x
    Copyright (C) 2005  SCK•CEN (Belgian Nuclear Research Centre)

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
  \class   SckAntispamType sckantispamtype.php
  \ingroup eZDatatypes
  \brief   Contains datatype for antispam
  \version 1.0
  \date    Monday 19 September 2005 8:20:34 am
  \author  Tom Couwberghs <tcouwber@sckcen.be>
  \author  Hans Melis <hmelis@sckcen.be>

  For more information, consult readme.txt in the root of this extension
*/

include_once( 'lib/ezutils/classes/ezhttptool.php' );
include_once( 'kernel/classes/ezdatatype.php' );
include_once( 'kernel/common/i18n.php' );

define( 'SCK_DATATYPESTRING_ANTISPAM', 'sckantispam' );


class SckAntiSpamType extends eZDataType
{
    /*!
     Initializes with a string id and a description.
    */
    function SckAntiSpamType()
    {
        $this->eZDataType( SCK_DATATYPESTRING_ANTISPAM, ezi18n( 'extension/antispam/datatypes', 'Anti Spam', 'Datatype name' ),
                           array( 'serialize_supported' => true,
                                  'object_serialize_map' => array() ) );
    }
    
/********
* CLASS *
********/

    function validateClassAttributeHTTPInput( $http, $base, $classAttribute )
    {
        return EZ_INPUT_VALIDATOR_STATE_ACCEPTED;
    }
    
    function fetchClassAttributeHTTPInput( $http, $base, $classAttribute )
    {
        $params = $classAttribute->content();
        
        if( $http->hasPostVariable( $base . '_sckantispam_length_' . $classAttribute->attribute( 'id' ) ) )
        {
            $params['length'] = $http->postVariable( $base . '_sckantispam_length_' . $classAttribute->attribute( 'id' ) );
        }
        
        if($http->hasPostVariable( 'ContentClassHasInput' ))
        {
            if( $http->hasPostVariable( $base . '_sckantispam_uppercase_' . $classAttribute->attribute('id') ) )
            {
                $params['uppercase'] = true;
            }
            else
            {
                $params['uppercase'] = false;
            }
            
            if( $http->hasPostVariable( $base . '_sckantispam_lowercase_' . $classAttribute->attribute('id') ) )
            {
                $params['lowercase'] = true;
            }
            else
            {
                $params['lowercase'] = false;
            }
            
            if( $http->hasPostVariable( $base . '_sckantispam_numeric_' . $classAttribute->attribute('id') ) )
            {
                $params['numeric'] = true;
            }
            else
            {
                $params['numeric'] = false;
            }
            
            if( $http->hasPostVariable( $base . '_sckantispam_numeric_' . $classAttribute->attribute('id') ) )
            {
                $params['custom'] = true;
            }
            else
            {
                $params['custom'] = false;
            }
        }

        if( $http->hasPostVariable( $base . '_sckantispam_customchars_' . $classAttribute->attribute( 'id' ) ) )
        {
            $params['customchars'] = $http->postVariable( $base . '_sckantispam_customchars_' . $classAttribute->attribute( 'id' ) );
        }
        
        if( $http->hasPostVariable( $base . '_sckantispam_ini_' . $classAttribute->attribute( 'id' ) ) )
        {
            $params['ini_block'] = $http->postVariable( $base . '_sckantispam_ini_' . $classAttribute->attribute( 'id' ) );
        }
        
        if( $http->hasPostVariable( $base . '_sckantispam_ignore_' . $classAttribute->attribute( 'id' ) ) )
        {
            $params['ignore'] = $http->postVariable( $base . '_sckantispam_ignore_' . $classAttribute->attribute( 'id' ) );
        }
        
        $classAttribute->setContent( $params );
        $classAttribute->store();
        
    }

    function classAttributeContent( $classAttribute )
    {
        return unserialize( $classAttribute->attribute( 'data_text5' ) );
    }
    
    function storeClassAttribute( $classAttribute, $version )
    {
        $content =& $classAttribute->content();
        $classAttribute->setAttribute( 'data_text5' , serialize( $content ) );
    }

/*********
* OBJECT *
*********/

    function validateObjectAttributeHTTPInput( $http, $base, $objectAttribute )
    {
        return $this->validateAttributeHTTPInput( $http, $base, $objectAttribute, false );
    }
    
    function validateAttributeHTTPInput( &$http, $base, &$objectAttribute, $isInformationCollector = false )
    {
        $classAttribute = $objectAttribute->contentClassAttribute();
        
        $is_required = $objectAttribute->validateIsRequired();
        $must_validate = ($isInformationCollector == $classAttribute->attribute( 'is_information_collector' ) );
        
        if( $http->hasPostVariable( $base . '_sckantispam_answer_' . $objectAttribute->attribute( 'id' ) ) )
        {
            if( $is_required === true && $must_validate === true )
            {
                $answer = $http->postVariable( $base . '_sckantispam_answer_' . $objectAttribute->attribute( 'id' ) );

//                if( $answer != $objectAttribute->content() )
		if( md5($answer) != eZHTTPTool::sessionVariable('mysecretcode') )
                {
                    $objectAttribute->setValidationError( ezi18n( 'extension/antispam', 'Antispam code is incorrect' ));
//                    return EZ_INPUT_VALIDATOR_STATE_INVALID;
                    return eZInputValidator::STATE_INVALID;
                }
            }
        }

//        return EZ_INPUT_VALIDATOR_STATE_ACCEPTED;
          return eZInputValidator::STATE_ACCEPTED;
    }
    
    function fetchObjectAttributeHTTPInput( $http, $base, $objectAttribute )
    {
        if( $http->hasPostVariable( $base . '_sckantispam_answer_' . $objectAttribute->attribute( 'id' ) ) )
        {
            $answer = $http->postVariable( $base . '_sckantispam_answer_' . $objectAttribute->attribute( 'id' ) );

            //regenerate if not correct or empty
            if( $answer != $objectAttribute->content() )
            {
                return false;
    		}
            else
            {
                return true;
            }
        }
        return false;
    }

    function objectAttributeContent( $objectAttribute )
    {
        return $objectAttribute->attribute( 'data_text' );
    }

    function hasObjectAttributeContent( $objectAttribute )
    {
        return true;
    }
    
    function storeObjectAttribute( $objectAttribute )
    {
		$content = $objectAttribute->content();
		$objectAttribute->setAttribute( 'data_text', $content );
        $objectAttribute->storeData();
    }
    
    function initializeObjectAttribute( $objectAttribute, $currentVersion, $originalContentObjectAttribute )
    {
    }

/*************
* COLLECTION *
*************/

    function validateCollectionAttributeHTTPInput( $http, $base, $objectAttribute )
    {
        return $this->validateAttributeHTTPInput( $http, $base, $objectAttribute, true );
    }
    
    function fetchCollectionAttributeHTTPInput( $collection, $collectionAttribute, $http, $base, $objectAttribute )
    {
        if( $http->hasPostVariable( $base . '_sckantispam_answer_' . $objectAttribute->attribute( 'id' ) ) )
        {
            $answer =& $http->postVariable( $base . '_sckantispam_answer_' . $objectAttribute->attribute( 'id' ) );

            //regenerate if not correct or empty
            if( $answer != $objectAttribute->content() )
            {
                return false;
    		}
            else
            {
                return true;
            }
        }
        return false;
    }

/**********
* GENERAL *
**********/

    function title( $objectAttribute, $name = null )
    {
        return '';
    }
    
    function isIndexable()
    {
        return false;
    }
    
    function isInformationCollector()
    {
        return true;
    }
    
    function sortKey( $objectAttribute )
    {
        return '';
    }
    
    function sortKeyType()
    {
        return false;
    }
    
    function metaData( $contentObjectAttribute )
    {
        $metaData = '';
        
        return $metaData;
    }
    
    function serializeContentClassAttribute( $classAttribute, $attributeNode, $attributeParametersNode )
    {
        $attributeParametersNode->appendChild( eZDOMDocument::createElementTextNode( 'params', serialize($classAttribute->content()) ) );
    }

    function unserializeContentClassAttribute( $classAttribute, $attributeNode, $attributeParametersNode )
    {
        $params = $attributeParametersNode->elementTextContentByName( 'params' );
        $classAttribute->setAttribute( 'data_text5', unserialize( $params ) );
    }


}

eZDataType::register( SCK_DATATYPESTRING_ANTISPAM, 'sckantispamtype' );

?>
