{*?template charset="koi8-r"?*}
{* News on frontpage - Line view *}
{* 'Events' folder *}
{*

*}
{default image_class=articlethumbnail 
 		 annotation_limit = 100
}
<div class="content-view-line">
    <div class="class-article float-break">

{*
	<div class="attribute-byline">
	<p class="date">
		{$node.object.published|l10n(shortdate)}&nbsp;|&nbsp;{$node.object.published|l10n(shorttime)}
	</p>
	</div>
*}

{*     <h2><a href={$node.url_alias|ezurl}>{$node.data_map.title.content|wash}</a></h2> *}


    {section show=$node.data_map.intro.content.is_empty|not}
    <div class="attribute-short">
        {attribute_view_gui attribute=$node.data_map.intro}
{*	<p class="linkmore"><a href={$node.url_alias|ezurl}>читать далее&nbsp;&raquo;</a></p> *}
    </div>
    {/section}

    </div>
</div>