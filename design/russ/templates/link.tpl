{*?template charset=koi8-r?*}
{default enable_print=true() $enable_rss=true()}

<link rel="Home" href={"/"|ezurl} title="{'%sitetitle front page'|i18n('design/standard/layout',,hash('%sitetitle',$site.title))}" />
<link rel="Index" href={"/"|ezurl} />
<link rel="Top"  href={"/"|ezurl} title="{$site_title}" />
<link rel="Search" href={"content/advancedsearch"|ezurl} title="{'Search %sitetitle'|i18n('design/standard/layout',,hash('%sitetitle',$site.title))}" />
{* <link rel="Shortcut icon" href={"favicon.ico"|ezimage} type="image/x-icon" /> *}
{* <link rel="Copyright" href={"/ezinfo/copyright"|ezurl} />
<link rel="Author" href={"/ezinfo/about"|ezurl} /> *}

{section show=$enable_print}
<link rel="Alternate" href={concat("layout/set/print/",$site.uri.original_uri)|ezurl} media="print" title="{'Printable version'|i18n('design/standard/layout')}" />
{/section}
{section show=$enable_rss}
<link rel="Alternate" type="application/rss+xml" title="RSS" href="/rss/feed/russ.rss" />
{/section}

{/default}