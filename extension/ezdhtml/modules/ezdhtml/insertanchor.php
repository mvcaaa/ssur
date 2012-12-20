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

$imgName = "anchor_image.gif";

require_once( "kernel/common/template.php" );
include_once( "lib/ezutils/classes/ezini.php" );

include_once( 'extension/ezdhtml/lib/commonfunctions.php' );
include_once( 'extension/ezdhtml/lib/system.php' );

include_once( 'lib/version.php' );
$eZPublishVersion = eZPublishSDK::majorVersion() + eZPublishSDK::minorVersion() * 0.1;

$Module = $Params["Module"];

$http = eZHTTPTool::instance();

$Module->setTitle( "Insert Anchor" );

$imgSrc = imagePath( $imgName );

$tpl = templateInit();
$tpl->setVariable( "module", $Module );
$tpl->setVariable( "imgSrc", $imgSrc );

getCustomAttributes( 'anchor', $customAttributes, $customDefaults );
$tpl->setVariable( "custom_attributes", $customAttributes );
$tpl->setVariable( "custom_defaults", $customDefaults );
$tpl->setVariable( "ezpublish_version", $eZPublishVersion );

$Result = array();
$userAgent = eZSys::serverVariable( 'HTTP_USER_AGENT' );
if ( preg_match ("/gecko/i", $userAgent ) )
{
    $Result['content'] = $tpl->fetch( "design:ezdhtml/insertanchor_gecko.tpl" );
}
else
{
    $Result['content'] = $tpl->fetch( "design:ezdhtml/insertanchor.tpl" );
}
$Result['path'] = array( array( 'url' => '/ezdhtml/insertanchor/',
                                'text' => 'Insert anchor' ) );

?>
