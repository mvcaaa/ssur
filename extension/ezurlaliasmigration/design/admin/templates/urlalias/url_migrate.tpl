{* Feedback code START *}

{switch match=$info_code}
{case match='feedback-migrate'}
<div class="message-feedback">
<h2><span class="time">[{currentdate()|l10n( shortdatetime )}]</span> {'The selected aliases were successfully migrated.'|i18n( 'design/urlalias/url_migrate' )}</h2>
</div>
{/case}
{case match='feedback-migrate-all'}
<div class="message-feedback">
<h2><span class="time">[{currentdate()|l10n( shortdatetime )}]</span> {'All url aliases were successfully migrated.'|i18n( 'design/urlalias/url_migrate' )|wash}</h2>
</div>
{/case}
{case}
{/case}
{/switch}

{* Feedback code END *}


<form name="aliasform" method="post" action={"urlalias/migrate/"|ezurl}>
<div class="context-block">
{def $aliasList=$filter.items}

{* DESIGN: Header START *}<div class="box-header"><div class="box-tc"><div class="box-ml"><div class="box-mr"><div class="box-tl"><div class="box-tr">
<h1 class="context-title">{'Custom URL Aliases [%alias_count]'|i18n( 'design/urlalias/url_migrate',, hash( '%alias_count', $filter.count ) )|wash}</h1>
{* DESIGN: Mainline *}<div class="header-mainline"></div>
{* DESIGN: Header END *}</div></div></div></div></div></div>
{* DESIGN: Content START *}<div class="box-ml"><div class="box-mr"><div class="box-content">

{* Items per page selector. *}
<div class="context-toolbar">
<div class="block">
<div class="left">
    <p>
    {foreach $limitList as $key => $limitEntry}
        {if eq($limit, $limitEntry)}
            <span class="current">{$limitEntry|wash}</span>
        {else}
            <a href={concat('/user/preferences/set/admin_urlalias_migrate_list_limit/', $key)|ezurl} title="{'Show %number_of items per page.'|i18n( 'design/urlalias/url_migrate',, hash( '%number_of', $limitEntry ) )}">{$limitEntry|wash}</a>
        {/if}
    {/foreach}
    </p>
</div>
<div class="break"></div>

</div>
</div>


{* list here *}
{if eq( count( $aliasList ), 0)}
<div class="block">
<p>{"No aliases found."|i18n( 'design/urlalias/url_migrate' )}</p>
</div>
{else}
<table class="list" cellspacing="0" >
<tr>
    <th class="tight"><img src={'toggle-button-16x16.gif'|ezimage} alt="{'Invert selection.'|i18n( 'design/urlalias/url_migrate' )}" title="{'Invert selection.'|i18n( 'design/urlalias/url_migrate' )}" onclick="ezjs_toggleCheckboxes( document.aliasform, 'ElementList[]' ); return false;"/></th>
    <th>{'URL alias'|i18n( 'design/urlalias/url_migrate' )}</th>
    <th>{'Destination'|i18n( 'design/urlalias/url_migrate' )}</th>
    <th>{'Language'|i18n( 'design/urlalias/url_migrate' )}</th>
    <th>{'Always available'|i18n( 'design/urlalias/url_migrate' )}</th>
</tr>
{foreach $aliasList as $element sequence array('bglight', 'bgdark') as $seq}
    <tr class="{$seq}">
        <td>
            <input type="checkbox" name="ElementList[]" value="{$element.parent}.{$element.text_md5}.{$element.language_object.locale}" />
        </td>

        <td>
            {def $url_alias_path=""}
            {foreach $element.path_array as $el}
                {if ne( $el.action, "nop:" )}
                    {set $url_alias_path=concat($url_alias_path, '/',
                                                '<a title="',$el.text|wash,'" href=', concat("/",$el.path)|ezurl, ">",
                                                $el.text|shorten(30)|wash,
                                                '</a>')}
                {else}
                    {set $url_alias_path=concat($url_alias_path, '/', $el.text|shorten(30)|wash)}
                {/if}
            {/foreach}
            {$url_alias_path}
            {undef $url_alias_path}
        </td>

        <td>
            <a href={$element.action_url|ezurl}>{$element.action_url}</a>
        </td>

        <td>
            <img src="{$element.language_object.locale|flag_icon}" alt="{$element.language_object.locale|wash}" />
            &nbsp;
            {if $element.lang_mask_adjusted}
                <span title="{'Calculated fallback translation'|i18n( 'design/urlalias/url_restore' )}">[{$element.language_object.locale|wash}]</span>
            {else}
                {$element.language_object.locale|wash}
            {/if}
        </td>
        <td>
            {if $element.always_available}
                yes
            {else}
                no
            {/if}
        </td>
    </tr>
{/foreach}
 </table>

<div class="context-toolbar">
    {include name=navigator
         uri='design:navigator/google.tpl'
         page_uri='urlalias/migrate'
         item_count=$filter.count
         view_parameters=$view_parameters
         item_limit=$filter.limit}
</div>
{/if}


{* DESIGN: Content END *}</div></div></div>


<div class="controlbar">
{* DESIGN: Control bar START *}<div class="box-bc"><div class="box-ml"><div class="box-mr"><div class="box-tc"><div class="box-bl"><div class="box-br">

<div class="block">
    {if $aliasList|count|gt( 0 )}
    <input class="button" type="submit" name="MigrateAliasButton" value="{'Migrate selected aliases'|i18n( 'design/urlalias/url_migrate' )}" title="{'Mark the selected custom url aliases for migration.'|i18n( 'design/urlalias/url_migrate' )}" />
    <input class="button" type="submit" name="MigrateAllAliasesButton" value="{'Migrate all aliases'|i18n( 'design/urlalias/url_migrate' )}" title="{'Migrate all custom url aliases.'|i18n( 'design/admin/content/urlalias_global' )}" onclick="return confirm( '{'Are you sure you want to migrate all custom url aliases?'|i18n( 'design/urlalias/url_migrate' )}' );" />
    {else}
    <input class="button-disabled" type="submit" name="MigrateAliasButton" value="{'Migrate selected aliases'|i18n( 'design/urlalias/url_migrate' )}" title="{'Mark the selected custom url aliases for migration.'|i18n( 'design/urlalias/url_migrate' )}" disabled="disabled" />
    <input class="button-disabled" type="submit" name="MigrateAllAliasesButton" value="{'Migrate all aliases'|i18n( 'design/urlalias/url_migrate' )}" title="{'Migrate all custom url aliases.'|i18n( 'design/admin/content/urlalias_global' )}" onclick="return confirm( '{'Are you sure you want to migrate all custom url aliases?'|i18n( 'design/urlalias/url_migrate' )}' );" disabled="disabled" />
    {/if}
</div>
{* DESIGN: Control bar END *}</div></div></div></div></div></div>
</div>

<div class="break"></div>

</div>

</form>