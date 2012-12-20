{* 
defaults:
$show_colon = false 
$show_position = false 
$show_image = false
$link = true
*}
{default show_position=false() 
	show_image=false()
	link=true()
}
{let $attr=$attribute.content}
{section show=$attr}
{* $attribute.content.main_node | attribute( show, 1 ) *}
{* $attribute.content.data_map.first_name | attribute( show, 1 ) *}
	{switch match=$show_image}
	{case match=0}
<span class="person">
<span class="person-name">{section show=$link}<a href={$attribute.content.main_node.url_alias|ezurl}>{/section}{$attr.data_map.first_name.content} {$attr.data_map.last_name.content}{section show=$link}</a>
{/section}{section show=$show_colon}:{/section}</span>{section show=$attr.data_map.position.has_content|and($show_position)}, <span class="person-position">{$attr.data_map.position.content}</span>{/section}</span>{/case}
	{case match=1}
	{section show=$attr.data_map.image.content}
		{section show=$link}<a href={$attribute.content.main_node.url_alias|ezurl}>{/section}{attribute_view_gui attribute=$attr.data_map.image image_class=medium}{section show=$link}</a>{/section}
	{/section}
<div class="person">
<span class="person-name">{section show=$link}<a href={$attribute.content.main_node.url_alias|ezurl}>{/section}{$attr.data_map.first_name.content} {$attr.data_map.last_name.content}{section show=$link}</a>
{/section}{section show=$show_colon}:{/section}</span>{section show=$attr.data_map.position.has_content|and($show_position)}, <span class="person-position">{$attr.data_map.position.content}</span>{/section}
</div>
	{/case}
	{case/}
	{/switch}

{/section}
{/let}