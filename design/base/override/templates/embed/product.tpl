{* Product - List embed view *}
<div class="content-view-embed">
    <div class="class-product">
        <a href={$object.main_node.url_alias|ezurl}><h2>{$object.name|wash}</h2></a>

        <div class="content-body">

    {section show=$object.data_map.image.content}
        <div class="attribute-image">
            {attribute_view_gui alignment=right image_class=small attribute=$object.data_map.image.content.data_map.image href=$object.main_node.url_alias|ezurl}
        </div>
    {/section}

        {attribute_view_gui attribute=$object.data_map.short_description}

        </div>

    </div>
</div>
