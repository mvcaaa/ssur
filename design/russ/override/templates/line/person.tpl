{*?template charset="koi8-r"?*}
{* Person - Line view *}
<div class="content-view-line">
    <div class="class-person">

		<h2><a href={$node.url_alias|ezurl}>{$node.name|wash()}</a></h2>

		{section show=$node.object.data_map.person.content}
		<div class="author">
				{attribute_view_gui attribute=$node.object.data_map.person show_image=0 show_position=0}
		</div>
		{/section}

    </div>
</div>


