{*?template charset="koi8-r"?*}
{if $current_node_id}{/if}
{def $morda_node_id = 2}
{def $morda_node=fetch( content, node, hash( node_id, $morda_node_id ))}

<div id="newscol">

{*** NEWS ***}
{def 
	$block = fetch( 'content', 'node', hash( 'node_id', '2490' ) )
	$block_name = $block.name	
}
{* $block|attribute(show,1) *}

    {def $children = array()
         $limit = or($block.object.data_map.limit_on_morda.value, 10)
         $offset = 0}
{* <!-- $current_top_razdel.url_alias: '{$current_top_razdel.url_alias}' --> *}
	{if $current_top_razdel.node_id|eq('225')}{def $limit=5}{/if} {* Themes *}
    {set $children=fetch( content, list, hash( 'parent_node_id', $block.node_id, 
                                               'limit', $limit,
                                               'offset', $offset,
                                               'class_filter_type', 'include',
                                               'class_filter_array', array( 'article', 'news'),
                                               'sort_by', $block.sort_array ) ) }

    {if $children|count()}
    <div class="content-view-children float-break">
    {foreach $children as $child max 6}
         {node_view_gui view=frontpage content_node=$child image_class=listitem}
         {delimiter}
             {include uri='design:content/datatype/view/ezxmltags/separator.tpl'}
         {/delimiter}
    {/foreach}
{*** PUSHKIN - 106905 ***}
{def 
	$block2 = fetch( 'content', 'node', hash( 'node_id', '106905' ) )
	$block2_name = $block.name	
}
{* $block|attribute(show,1) *}

    {def $children2 = array()
         $limit2 = 1
         $offset2 = 0}
{* <!-- $current_top_razdel.url_alias: '{$current_top_razdel.url_alias}' --> *}
	{if $current_top_razdel.node_id|eq('225')}{def $limit=5}{/if} {* Themes *}
    {set $children2=fetch( content, list, hash( 'parent_node_id', $block2.node_id, 
                                               'limit', $limit2,
                                               'offset', $offset2,
                                               'class_filter_type', 'include',
                                               'class_filter_array', array( 'article', 'news'),
                                               'sort_by', $block2.sort_array ) ) }

    {if $children2|count()}
    <div class="content-view-children float-break" id="pushkin">
    {foreach $children2 as $child2}
         {node_view_gui view=frontpage content_node=$child2 image_class=articleimage title=0}
         {delimiter}
             {include uri='design:content/datatype/view/ezxmltags/separator.tpl'}
         {/delimiter}
    {/foreach}
    </div>
    {/if}
{*** PUSHKIN END ***}


    {foreach $children as $child offset 6 max 2}
         {node_view_gui view=frontpage content_node=$child image_class=listitem}
         {delimiter}
             {include uri='design:content/datatype/view/ezxmltags/separator.tpl'}
         {/delimiter}
    {/foreach}


{*** ACADEM - 111607 ***}
{def 
	$block2 = fetch( 'content', 'node', hash( 'node_id', '111607' ) )
	$block2_name = $block.name	
}
{* $block|attribute(show,1) *}

    {def $children2 = array()
         $limit2 = 1
         $offset2 = 0}
{* <!-- $current_top_razdel.url_alias: '{$current_top_razdel.url_alias}' --> *}
	{if $current_top_razdel.node_id|eq('225')}{def $limit=5}{/if} {* Themes *}
    {set $children2=fetch( content, list, hash( 'parent_node_id', $block2.node_id, 
                                               'limit', $limit2,
                                               'offset', $offset2,
                                               'class_filter_type', 'include',
                                               'class_filter_array', array( 'article', 'news'),
                                               'sort_by', $block2.sort_array ) ) }

    {if $children2|count()}
    <div class="content-view-children float-break" id="academ">
    {foreach $children2 as $child2}
         {node_view_gui view=frontpage content_node=$child2 image_class=articleimage title=0}
         {delimiter}
             {include uri='design:content/datatype/view/ezxmltags/separator.tpl'}
         {/delimiter}
    {/foreach}
    </div>
    {/if}
{*** ACADEM END ***}

    {foreach $children as $child offset 8}
         {node_view_gui view=frontpage content_node=$child image_class=listitem}
         {delimiter}
             {include uri='design:content/datatype/view/ezxmltags/separator.tpl'}
         {/delimiter}
    {/foreach}

    </div>
    {/if}

{def $current_node=fetch( content, node, hash( node_id, $current_node_id ))}
<!-- $current_node.class_identifier: {$current_node.class_identifier} -->
<div class="adblock">
{sape_links('5')}
</div>

</div> <!-- / #newscol -->
<div id="extracol">
    
{def $current_top_razdel = $module_result.path.1
}
{* ***  *}
{* $current_top_razdel|attribute( show,1) *}

{*** BEST BLOCK ***}

{def $best=$morda_node.data_map.best.content.relation_list}
{* $best|attribute(show, 2) *}

{if  $best|count()} 
<div class="content-view-children float-break" id="best">
<div class="" style="margin-bottom: 10px;"><img style="border-bottom: 3px double black; padding-bottom: 2px; " src={"images/best.gif"|ezdesign}  width="192" height="27" border="0" alt=""></div>
{** Save current $node **}
{def $tmp_node = $node}

      {foreach $best as $index=>$relation_object }
		{def $node=fetch( content, node, hash( node_id, $relation_object.node_id ))}
		{* node_view_gui view=listitem content_node=$best_node *}
<div class="content-view-listitem{if $index|eq($best|count()|dec())} last{/if}">
    <div class="class-article float-break">

{def $image_class=listitem $show_topic=0 $show_annotation=1 $show_image=0
}

{def $person=$node.data_map.person
     $image=cond( $person.content.data_map.image.has_content, $person.content.data_map.image, 
		  $node.data_map.image.has_content, $node.data_map.image) 
}

{if $image.has_content}
{* $image | attribute(show, 1 ) *}
{/if}

        {section show=and($image.has_content, $show_image)}
        <div class="attribute-image">
            {attribute_view_gui image_class=$image_class href=$node.url_alias|ezurl attribute=$image}
        </div>
        {/section}

    <h3><a href={$node.url_alias|ezurl}>{$node.data_map.title.content|wash}</a></h3>

	{section show=$node.data_map.person.content}
	<div class="attribute-byline">
	<p class="author">
		{attribute_view_gui attribute=$node.data_map.person}
	</p>
	</div>
	{/section}

    </div>
</div>

      {/foreach}

{** Restore current $node **}	  
{def $node = $tmp_node}


</div><!-- /sect #best -->
{/if} {* /if $bestblock_array *}


{*** WORKBOOKS - 72267  ***}
{def 
	$block = fetch( 'content', 'node', hash( 'node_id', '72267' ) )
	$block_name = $block.name	
}
{* $block|attribute(show,1) *}

    {def $children = array()
         $limit = or($block.object.data_map.limit_on_morda.value, 1)
         $offset = 0}
{* <!-- $current_top_razdel.url_alias: '{$current_top_razdel.url_alias}' --> *}
	{if $current_top_razdel.node_id|eq('225')}{def $limit=5}{/if} {* Themes *}
    {set $children=fetch( content, list, hash( 'parent_node_id', $block.node_id, 
                                               'limit', $limit,
                                               'offset', $offset,
                                               'class_filter_type', 'include',
                                               'class_filter_array', array( 'article', 'news'),
                                               'sort_by', $block.sort_array ) ) }

    {if $children|count()}
    <div class="content-view-children float-break" id="workbook">
    {foreach $children as $child}
         {node_view_gui view=frontpage content_node=$child image_class=articleimage title=0}
         {delimiter}
             {include uri='design:content/datatype/view/ezxmltags/separator.tpl'}
         {/delimiter}
    {/foreach}
    </div>
    {/if}
{*** WORKBOOKS END ***}


{*** KNIGA - 2499 ***}
{def 
	$block = fetch( 'content', 'node', hash( 'node_id', '2499' ) )
	$block_name = $block.name	
}
{* $block|attribute(show,1) *}

    {def $children = array()
         $limit = or($block.object.data_map.limit_on_morda.value, 2)
         $offset = 0}
{* <!-- $current_top_razdel.url_alias: '{$current_top_razdel.url_alias}' --> *}
	{if $current_top_razdel.node_id|eq('225')}{def $limit=5}{/if} {* Themes *}
    {set $children=fetch( content, list, hash( 'parent_node_id', $block.node_id, 
                                               'limit', $limit,
                                               'offset', $offset,
                                               'class_filter_type', 'include',
                                               'class_filter_array', array( 'article', 'news'),
                                               'sort_by', $block.sort_array ) ) }

    {if $children|count()}
    <div class="content-view-children float-break" id="book">
    {foreach $children as $child}
         {node_view_gui view=frontpage content_node=$child image_class=articleimage title=0}
         {delimiter}
             {include uri='design:content/datatype/view/ezxmltags/separator.tpl'}
         {/delimiter}
    {/foreach}
    </div>
    {/if}

</div>
