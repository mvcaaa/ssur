{*?template charset="koi8-r"?*}
{* LJ Post - Line view - Right Column *}

<div class="content-view-onmorda">
    <div class="class-lj_post">

<div class="bl">
	
{def $title=or($node.object.data_map.name.content, $node.object.data_map.user.content) 
	$url=$node.object.data_map.location.content
}
{* $node.object.data_map.location |attribute(show,1) *} 

	{section show=$node.object.data_map.userpic_src.has_content}
	<div class="image"><a href="{$url}"><img src="{$node.object.data_map.userpic_src.value}" width="{or($node.object.data_map.userpic_width.value, 50)}" height="{or($node.object.data_map.userpic_height.value, 50)}" border="0" alt=""></a>
		<div class="author">{if $url}<a href="{$url}">{/if}{$node.object.data_map.user.content|wrap(15, '<br>', false)}{if $url}</a>{/if}</div>
	</div>
	{/section}

    {section show=$node.object.data_map.name.has_content}
	    <div class=hdr>{if $url}<a href="{$url}">{/if}{$node.object.data_map.name.content }{if $url}</a>{/if}</div>
    {/section}

    {section show=$node.object.data_map.description.content.is_empty|not}
{* $node.object.data_map.description.content.output |attribute(show,1) *}
    <div class="attribute-short">
{def $text=$node.object.data_map.description.content.output.output_text}
{* set $text=$text|strip_tags() *}
{set $text=''}
		<a href="{$url}" target="_blank">{$text|shorten(150)|wrap(20, ' <br>', false)}</a>
        {* attribute_view_gui attribute=$node.object.data_map.description *}
    </div>
    {/section}
	
    {section show=false()}
	<div class="attribute-byline">
    <p class="date">
             {$node.object.published|l10n(date)} | {$node.object.published|l10n(shorttime)}
    </p>
	</div>
    {/section}

    {section show=$url|false()}
	<div class="more">
        <div class="attribute-link">
            <p><a href="{$url}">{"Читать оригинальный пост в ЖЖ"}</a></p>
        </div>
	</div>
    {/section}


		<div class="fix"></div>
</div><!-- /block -->

    </div>
</div>
