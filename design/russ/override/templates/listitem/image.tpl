{* Image - List item view *}

{default image_class=listitem}

<div class="content-view-listitem">
    <div class="class-image">

    <h3>{$node.name|wash}</h3>

    <div class="attribute-image">
        <p>{attribute_view_gui attribute=$node.data_map.image image_class=$image_class href=$node.url_alias|ezurl()}</p>
    </div>

    <div class="content-caption">
        {attribute_view_gui attribute=$node.data_map.caption}
    </div>

    </div>
</div>
