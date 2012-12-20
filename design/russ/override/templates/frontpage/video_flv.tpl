{* Video FLV - Frontpage view *}
<div class="content-view-frontpage float-break" id="frontpage-video">
	<div class="class-video-flv">
{* <h2><a href={$node.url_alias|ezurl}>{$node.name|wash()}</a></h2> *}
	{attribute_view_gui attribute=$node.object.data_map.file size=half correct_size=1}
	{if $node.data_map.description.has_content}
		<div class="attribute-short">{attribute_view_gui attribute=$node.data_map.description href=$node.url_alias|ezurl ending=""}
{*        <a href={$node.url_alias|ezurl}>{attribute_view_gui attribute=$node.data_map.description}</a> *}
		</div>
	{/if}
	</div>
</div>