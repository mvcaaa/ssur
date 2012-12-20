{* Feedback code START *}
{switch match=$info_code}
{case match='feedback-restore'}
<div class="message-feedback">
<h2><span class="time">[{currentdate()|l10n( shortdatetime )}]</span> {'The selected url aliases were successfully restored.'|i18n( 'design/urlalias/url_restore' )}</h2>
</div>
{/case}
{case match='feedback-restore-all'}
<div class="message-feedback">
<h2><span class="time">[{currentdate()|l10n( shortdatetime )}]</span> {'All url aliases [%migrate_all_count] were successfully restored.'|i18n( 'design/urlalias/url_restore',, hash( '%migrate_all_count', $info_data['migrate-all-count'] ) )|wash}</h2>
</div>
{/case}
{case match='feedback-dev'}
<div class="message-feedback">
<h2><span class="time">[{currentdate()|l10n( shortdatetime )}]</span> Development mode</h2>
{if is_set( $info_data.message )}
    <p>{$info_data.message|wash}</p>
{/if}
</div>
{/case}
{case}
{/case}
{/switch}
{* Feedback code END *}

<div class="menu-block">
    <ul>
        {if $show_restored}
            <li class="enabled">
                <div class="button-bc"><div class="button-tl"><div class="button-tr"><div class="button-br">
                    <a href={"user/preferences/set/admin_urlalias_show_restored/0"|ezurl}>Show restored</a>
                </div></div></div>
            </li>
        {else}
            <li class="disabled">
                <div class="button-bc"><div class="button-tl"><div class="button-tr"><div class="button-br">
                    <a href={"user/preferences/set/admin_urlalias_show_restored/1"|ezurl}>Show restored</a>
                </div></div></div>
            </li>
        {/if}
    </ul>
    <div class="break"></div>
</div>



<form name="aliasform" method="post" action={"urlalias/restore/"|ezurl}>
<div class="context-block">

{* DESIGN: Header START *}<div class="box-header"><div class="box-tc"><div class="box-ml"><div class="box-mr"><div class="box-tl"><div class="box-tr">
<h1 class="context-title">{'Migrated custom URL Aliases [%alias_count]'|i18n( 'design/urlalias/url_restore',, hash( '%alias_count', $count ) )|wash}</h1>
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
            <a href={concat('/user/preferences/set/admin_urlalias_restore_list_limit/', $key)|ezurl} title="{'Show %number_of items per page.'|i18n( 'design/urlalias/url_restore',, hash( '%number_of', $limitEntry ) )}">{$limitEntry|wash}</a>
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
<p>{"No aliases found."|i18n( 'design/urlalias/url_restore' )}</p>
</div>
{else}
<table class="list" cellspacing="0" >
<tr>
    <th class="tight"><img src={'toggle-button-16x16.gif'|ezimage} alt="{'Invert selection.'|i18n( 'design/urlalias/url_restore' )}" title="{'Invert selection.'|i18n( 'design/urlalias/url_restore' )}" onclick="ezjs_toggleCheckboxes( document.aliasform, 'ElementList[]' ); return false;"/></th>
    <th>{'URL alias'|i18n( 'design/urlalias/url_restore' )}</th>
    <th>{'Destination'|i18n( 'design/urlalias/url_restore' )}</th>
    <th>{'Language'|i18n( 'design/urlalias/url_restore' )}</th>
    <th class="tight">{'Always available'|i18n( 'design/urlalias/url_restore' )}</th>
</tr>
{foreach $aliasList as $element sequence array('bglight', 'bgdark') as $seq}
    <tr class="{$seq}{if $element.is_restored} restored{/if}">
        {* Checkbox *}
        <td>
            <input type="checkbox" name="ElementList[]" value="{$element.parent}.{$element.text_md5}" />
        </td>

        {* Path *}
        <td>
            /{$element.real_path_stored|shorten(70)|wash}
        </td>

        {* Action / Destination of alias *}
        <td>
            <a href={$element.action_url|ezurl}>{$element.action}</a>
        </td>

        {* Language *}
        <td>
            <img src="{$element.language_object.locale|flag_icon}" alt="{$element.language_object.locale|wash}" />
            &nbsp;
            {if $element.lang_mask_adjusted}
                <span title="{'Calculated fallback translation'|i18n( 'design/urlalias/url_restore' )}">[{$element.language_object.locale|wash}]</span>
            {else}
                {$element.language_object.locale|wash}
            {/if}
        </td>

        {* Always available *}
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
         page_uri='urlalias/restore'
         item_count=$count
         view_parameters=$view_parameters
         item_limit=$limit}
</div>
{/if}


{* DESIGN: Content END *}</div></div></div>


<div class="controlbar">
{* DESIGN: Control bar START *}<div class="box-bc"><div class="box-ml"><div class="box-mr"><div class="box-tc"><div class="box-bl"><div class="box-br">

<div class="block">
    <div class="left">
        {if $aliasList|count|gt( 0 )}
            <input class="button" type="submit" name="RestoreAliasButton" value="{'Restore selected aliases'|i18n( 'design/urlalias/url_restore' )}" title="{'Restore the selected custom url aliases.'|i18n( 'design/urlalias/url_restore' )}" />
            <input class="button" type="submit" name="RestoreAllAliasesButton" value="{'Restore all aliases'|i18n( 'design/urlalias/url_restore' )}" title="{'Restore all migrated custom url aliases.'|i18n( 'design/content/urlalias_restore' )}" onclick="return confirm( '{'Are you sure you want to restore all migrated custom url aliases?'|i18n( 'design/urlalias/url_restore' )}' );" />
        {else}
            <input class="button-disabled" type="submit" name="RestoreAliasButton" value="{'Restore selected aliases'|i18n( 'design/urlalias/url_restore' )}" title="{'Restore the selected custom url aliases.'|i18n( 'design/urlalias/url_restore' )}" disabled="disabled" />
            <input class="button-disabled" type="submit" name="RestoreAllAliasesButton" value="{'Restore all aliases'|i18n( 'design/urlalias/url_restore' )}" title="{'Restore all migrated custom url aliases.'|i18n( 'design/content/urlalias_restore' )}" onclick="return confirm( '{'Are you sure you want to restore all migrated custom url aliases?'|i18n( 'design/urlalias/url_restore' )}' );" disabled="disabled" />
        {/if}
    </div>
    <div class="right">
        {if $aliasList|count|gt( 0 )}
            <input class="button" type="submit" name="RemoveButton" value="{'Remove selected'|i18n( 'design/urlalias/url_restore' )}" title="{'Remove selected previously migrated aliases.'|i18n( 'design/urlalias/url_restore' )}" onclick="return confirm( '{'Are you sure you want to remove the selected migrated custom url aliases?'|i18n( 'design/urlalias/url_restore' )}' );" />
            <input class="button" type="submit" name="RemoveAllButton" value="{'Remove all'|i18n( 'design/urlalias/url_restore' )}" title="{'Remove all previously migrated aliases.'|i18n( 'design/urlalias/url_restore' )}" onclick="return confirm( '{'Are you sure you want to remove all migrated custom url aliases?'|i18n( 'design/urlalias/url_restore' )}' );" />
        {else}
            <input class="button-disabled" type="submit" name="RemoveButton" value="{'Remove selected'|i18n( 'design/urlalias/url_restore' )}" title="{'Remove selected previously migrated aliases.'|i18n( 'design/urlalias/url_restore' )}" onclick="return confirm( '{'Are you sure you want to remove the selected migrated custom url aliases?'|i18n( 'design/urlalias/url_restore' )}' );" disabled="disabled" />
            <input class="button-disabled" type="submit" name="RemoveAllButton" value="{'Remove all'|i18n( 'design/urlalias/url_restore' )}" title="{'Remove all previously migrated aliases.'|i18n( 'design/urlalias/url_restore' )}" onclick="return confirm( '{'Are you sure you want to remove all migrated custom url aliases?'|i18n( 'design/urlalias/url_restore' )}' );" disabled="disabled" />
        {/if}
    </div>
    <div class="break"></div>
</div>
{* DESIGN: Control bar END *}</div></div></div></div></div></div>
</div>

<div class="break"></div>

</div>

</form>