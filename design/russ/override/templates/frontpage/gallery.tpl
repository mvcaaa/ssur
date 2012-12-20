{*?template charset="koi8-r"?*}
{* Gallery - Frontpage view, from node line view *}

<div class="content-view-line">
    <div class="class-gallery">

    {section show=$node.data_map.image.content}

{* $node.data_map.image.content.data_map.image.object.main_node| attribute(show, 1) *}

        <div class="attribute-image">
	    {def $img=$node.data_map.image.content.data_map.image}
            {attribute_view_gui image_class=galleryfrontpage attribute=$img href=$img.object.main_node.url_alias|ezurl}
        </div>
    {/section}

        <h2><a href={$img.object.main_node.url_alias|ezurl}>{$node.name|wash()}</a></h2>

        <div class="attribute-short">
           {attribute_view_gui attribute=$node.data_map.short_description}
        </div>

    </div>
</div>
