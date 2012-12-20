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

require_once( "kernel/common/template.php" );
include_once( "lib/ezutils/classes/ezini.php" );
include_once( "lib/ezutils/classes/ezextension.php" );

$Module = $Params["Module"];

$extensionPath = "/" . extension_path( 'ezdhtml', false, false, false );
$imgPath = $extensionPath . "/design/standard/images/ezdhtml";

$docPath = $extensionPath . "/doc";
$http = eZHTTPTool::instance();
$Module->setTitle( "Online editor help" );

$tpl = templateInit();
$tpl->setVariable( "module", $Module );
$tpl->setVariable( "path", $imgPath );
$tpl->setVariable( "docpath", $docPath );

$Result = array();
$userAgent = eZSys::serverVariable( 'HTTP_USER_AGENT' );
if ( preg_match ("/gecko/i", $userAgent ) )
{
    $Result['content'] = $tpl->fetch( "design:ezdhtml/help_gecko.tpl" );
}
else
{
    $Result['content'] = $tpl->fetch( "design:ezdhtml/help.tpl" );
}
$Result['path'] = array( array( 'url' => '/ezdhtml/help/',
                                'text' => 'Online editor help' ) );
?>
