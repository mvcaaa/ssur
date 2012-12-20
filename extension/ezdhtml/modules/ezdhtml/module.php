<?php
//
//
// SOFTWARE NAME: eZ Online Editor
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


$Module = array( "name" => "eZDhtml" );

$ViewList = array();
$ViewList["inserttable"] = array(
    "ui_context" => "edit",
    "script" => "inserttable.php",
    "params" => array( 'New' ) );
$ViewList["insertcustomtag"] = array(
    "ui_context" => "edit",
    "script" => "insertcustomtag.php",
    "params" => array( 'New' ) );
$ViewList["insertliteral"] = array(
    "ui_context" => "edit",
    "script" => "insertliteral.php",
    "params" => array() );
$ViewList["insertlink"] = array(
    "ui_context" => "edit",
    "script" => "insertlink.php",
    "params" => array( 'New' ) );
$ViewList["insertanchor"] = array(
    "ui_context" => "edit",
    "script" => "insertanchor.php",
    "params" => array() );
$ViewList["insertobject"] = array(
    "ui_context" => "edit",
    "script" => "insertobject.php",
    "params" => array( 'ObjectID', 'ObjectVersion' ),
    "unordered_params" => array( 'upload' => 'Upload' ) );
$ViewList["insertclassattribute"] = array(
    "ui_context" => "edit",
    "script" => "insertclassattribute.php",
    "params" => array( 'TagName' ) );
$ViewList["tablecelledit"] = array(
    "ui_context" => "edit",
    "script" => "tablecelledit.php",
    "params" => array( 'TagName' ) );
$ViewList["help"] = array(
    "script" => "help.php",
    "params" => array() );
$ViewList["insertcharacter"] = array(
    "ui_context" => "edit",
    "script" => "insertcharacter.php",
    "params" => array() );
?>
