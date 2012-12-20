{*?template charset="koi8-r"?*}{* 
 Articles on Morda in NEWS Column, derived from 'Article - Line view'
 for video, uses node
*}
{default image_class=articleimage}
<div class="content-view-frontpage float-break" id="frontpage-comics">
	{section show=$node.data_map.previewimage.content.is_empty|not}<div class="attribute-short float-break"><a href={$node.url_alias|ezurl}>{attribute_view_gui attribute=$node.data_map.previewimage}</a></div>{/section}
	</div>
