{*?template charset="koi8-r"?*}
{* News on frontpage - Line view *}
{* 'Events' folder *}
{*

*}
{def $image=cond( 
			  $node.data_map.image.has_content, $node.data_map.image) 
	}
        {section show=$image.has_content}
        <div class="attribute-image">
            {attribute_view_gui image_class=articleimage attribute=$image href=$node.data_map.location.content|ezurl}
        </div>
        {/section}
<div class="content-view-line">
    <div class="class-article float-break">

    {section show=$node.data_map.location.content.is_empty|not}
    <div class="attribute-short" align='center'>
        {attribute_view_gui attribute=$node.data_map.location}
    </div>
    {/section}

    </div>
</div>
