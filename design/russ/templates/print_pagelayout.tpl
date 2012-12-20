{*?template charset="koi8-r"?*}
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="{$site.http_equiv.Content-language|wash}" lang="{$site.http_equiv.Content-language|wash}">

<head>
    <link rel="stylesheet" type="text/css" href={"stylesheets/core.css"|ezdesign} />

<style type="text/css">
{section var=css_file loop=ezini( 'StylesheetSettings', 'CSSFileList', 'design.ini' )}
    @import url({concat( 'stylesheets/',$css_file )|ezdesign});
{/section}

    @import url({"stylesheets/print.css"|ezdesign});
</style>
{include uri="design:page_head.tpl" enable_print=false()}
</head>

<body>

<div class="top">
	<div class="logo"><a href="/"><img src={'images/logo_russ_ru_grey.gif'|ezdesign} width="140" height="100" border="0" alt="RJ"></a></div>
</div>

{* Main area START *}

{include uri="design:page_mainarea.tpl" disable_comments=true()}

{* Main area END *}

{include uri="design:page_copyright.tpl"}

<!--DEBUG_REPORT-->

</body>
</html>
