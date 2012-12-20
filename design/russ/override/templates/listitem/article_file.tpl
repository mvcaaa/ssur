{*?template charset=koi8-r?*}
{* Article - List item view *}
<div class="content-view-listitem">
    <div class="class-article float-break">

{default image_class=listitem show_topic=0 show_annotation=1 show_image=1
}

{def $person=$node.data_map.person
     $image=cond( $person.content.data_map.image.has_content, $person.content.data_map.image, 
		  $node.data_map.image.has_content, $node.data_map.image) 
}

{if $image.has_content}
{* $image | attribute(show, 1 ) *}
{/if}

        {section show=and($image.has_content, $show_image)}
        <div class="attribute-image">
            {attribute_view_gui image_class=$image_class href=$node.url_alias|ezurl attribute=$image}
        </div>
        {/section}


    <h3>{if $node.data_map.person.content}<span class="author">{attribute_view_gui attribute=$node.data_map.person show_position=0 show_colon=1}</span>{/if}<a href={$node.url_alias|ezurl}>{$node.data_map.title.content|wash}</a></h3>


	{section show=$node.data_map.person.content|false()}
	<div class="attribute-byline">
{*
	<p class="author">
		{attribute_view_gui attribute=$node.data_map.person}
	</p>
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
        {attribute_view_gui attribute=$node.data_map.intro}
{*	<p class="linkmore"><a href={$node.url_alias|ezurl}>читать далее&nbsp;&raquo;</a></p> *}
    </div>
    {/section}

    </div>
</div>