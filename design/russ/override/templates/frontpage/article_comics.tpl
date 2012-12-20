{*?template charset="koi8-r"?*}{* 
 Articles on Morda in NEWS Column, derived from 'Article - Line view'
 for video, uses node
*}
{default image_class=articleimage}
<div class="content-view-frontpage float-break" id="frontpage-video">
	<div class="class-article">
	{section show=$node.data_map.person.content|false()}
	<div class="attribute-byline">
{*	<p class="author">
		{attribute_view_gui attribute=$node.data_map.person}
	</p>
	<p class="date">
		{$node.object.published|l10n(date)}
	</p>
*}
	</div>
	{/section}
	{section show=$node.data_map.intro.content.is_empty|not}<div class="attribute-short float-break">{attribute_view_gui attribute=$node.data_map.intro ending=""}</div>{/section}
	</div>
</div>