<?php
//
// Created on: <12-Oct-2006 10:10:02 ks>
//
// Copyright (C) 1999-2006 eZ systems as. All rights reserved.
//

function getCustomAttributes( $tagName, &$customAttributes, &$customAttrDefaults )
{
    $ini = eZINI::instance( 'content.ini' );

    if ( $ini->hasVariable( $tagName, 'CustomAttributesDefaults' ) )
        $customAttrDefaults = $ini->variable( $tagName, 'CustomAttributesDefaults' );
    else
        $customAttrDefaults = array();

    if ( $ini->hasVariable( $tagName, 'CustomAttributes' ) )
        $customAttributes = $ini->variable( $tagName, 'CustomAttributes' );
    else
        $customAttributes = array();
}

?>
