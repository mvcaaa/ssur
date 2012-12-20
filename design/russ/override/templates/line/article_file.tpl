{*?template charset="koi8-r"?*}
{* Article - Line view *}
{*

*}
{default image_class=articlethumbnail show_topic=0 show_annotation=1
}

<div class="content-view-line">
    <div class="class-article float-break">

	{def $person=$node.data_map.person
	     $image=cond( $person.content.data_map.image.has_content, $person.content.data_map.image, 
			  $node.data_map.image.has_content, $node.data_map.image) 
	}

{if $image.has_content}
{* $image.content.$image_class | attribute(show, 1 ) *}
{/if}

        {section show=and($image.has_content, is_set($image.content.$image_class) )}
        <div class="attribute-image">
            {attribute_view_gui image_class=$image_class href=$node.url_alias|ezurl attribute=$image}
        </div>
        {/section}

    <h2><a href={$node.url_alias|ezurl}>{$node.data_map.title.content|wash}</a></h2>

	{section show=$node.data_map.person.content}
	<div class="attribute-byline">
	<p class="author">
		{attribute_view_gui attribute=$node.data_map.person}
	</p>
{*
	<p class="date">
{if $node.object.data_map.date_time.has_content}
	{$node.object.data_map.date_time.value.timestamp|l10n(shortdatetime)}
{else}  
        {$node.object.published|l10n(shortdatetime)}
{/if}
	</p>
*}
	</div>
	{/section}

	
    {section show=and($node.data_map.intro.content.is_empty|not, $show_annotation)}
    <div class="attribute-short">
        {attribute_view_gui attribute=$node.data_map.intro link=$node.url_alias|ezurl}
{*	<p class="linkmore"><a href={$node.url_alias|ezurl}>читать далее&nbsp;&raquo;</a></p> *}
    </div>
    {/section}

    </div>
</div>