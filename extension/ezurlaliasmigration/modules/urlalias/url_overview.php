<?php
/**
 * File containing url alias overview controller
 *
 * @copyright Copyright (C) 1999-2008 eZ Systems AS. All rights reserved.
 * @license http://ez.no/licenses/gnu_gpl GNU GPLv2
 * @package UrlAliasMigration
 *
 */

ezpUrlAliasMigrateTool::setupDebug();

require_once 'kernel/common/template.php';
// Set up module information
$path = array();
$path[] = array( 'url'  => false,
                 'text' => ezi18n( 'urlalias/urlalias_overview', 'URL alias overview' ) );

$Result['path'] = $path;
$Result['left_menu'] = 'design:urlalias/url_migrate_menu.tpl';

$customUrlAliasCount = ezpUrlAliasMigrateTool::customUrlAliasCount();
$historyUrlCount = ezpUrlAliasMigrateTool::historyUrlCount();

$tpl = templateInit();
$tpl->setVariable( 'custom_urlalias_count', $customUrlAliasCount );
$tpl->setVariable( 'history_url_count', $historyUrlCount );

$Result['content'] = $tpl->fetch( 'design:urlalias/url_overview.tpl' );
?>
