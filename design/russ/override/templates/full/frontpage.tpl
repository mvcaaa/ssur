{*?template charset="koi8-r"?*}{* CUSTOM FRONTPAGE *}
{def $frontpagestyle='leftcolumn norightcolumn'}

{* Mirovaya povestka - 2491, Problem Field - 2493 *}

{*** Mirovaya povestka - 2491 ***}
{def $razdel_node_id = 2491
	 $razdel=fetch( content, node, hash( node_id, $razdel_node_id ))
	 $limit = or($razdel.object.data_map.limit_on_morda.value, 8)
}
{def $list_items=fetch_alias( children, hash( parent_node_id, $razdel_node_id,
                                                             offset, 0,
                                                             sort_by, $razdel.sort_array,
                                                             limit, $limit ) )}
{def $list_count=fetch_alias( children_count, hash( parent_node_id, $razdel_node_id ) )}

{*** OnGuard - 154234 ***}
{def $razdel3_node_id = 154234
	 $razdel3=fetch( content, node, hash( node_id, $razdel3_node_id ))
	 $limit3 = or($razdel3.object.data_map.limit_on_morda.value, 4)
}
{def $list3_items=fetch_alias( children, hash( parent_node_id, $razdel3_node_id,
                                                             offset, 0,
                                                             sort_by, $razdel3.sort_array,
                                                             limit, $limit3 ) )}
{def $list3_count=fetch_alias( children_count, hash( parent_node_id, $razdel3_node_id ) )}

{*** Problem Field - 2493 ***}
{def $razdel2_node_id = 2493
	 $razdel2=fetch( content, node, hash( node_id, $razdel2_node_id ))
	 $limit2 = or($razdel2.object.data_map.limit_on_morda.value, 4)
}
{def $list2_items=fetch_alias( children, hash( parent_node_id, $razdel2_node_id,
                                                             offset, 0,
                                                             sort_by, $razdel2.sort_array,
                                                             limit, $limit2 ) )}
{def $list2_count=fetch_alias( children_count, hash( parent_node_id, $razdel2_node_id ) )}


<div class="content-view-full">
	<div class="class-frontpage {$frontpagestyle}">

<!-- list2_items: {$list2_items|count()} -->
	
{*** TOP BLOCK ***}
	<div class="attribute-top-column">
		<div class="content-view-children">
			<div id="hotblock">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td width="" id="td_hotcontent"><div id="hotcontent">{*{foreach $list_items as $child max 1}{/foreach} *}
{*** HOT ARTICLE ***}
{def $child=$list_items.0 }
{* TOPICs *}
{def $topics=fetch( 'content', 'reverse_related_objects', hash( 'object_id', $child.object.id) )}
		{* <!-- , 'attribute_identifier', 'Topic' | , 'all_relations', true()  --> *}
		{* $related_objects|attribute( show, 1 ) *}
{def $topic=0}
{foreach $topics as $topic}{if eq($topic.class_name,'Topic')}{break}{/if}{/foreach}
{def $person=$child.data_map.person
     $image=cond(  $child.data_map.image.has_content, $child.data_map.image,
			 $topic.data_map.image.has_content, $topic.data_map.image )}
{*      $image=cond( $person.content.data_map.image.has_content, $person.content.data_map.image, 
		  $child.data_map.image.has_content, $child.data_map.image) 
*}
<div class="content-view-line">
	<div class="class-article float-break">
		<h3><a href={$child.url_alias|ezurl}>{if $child.data_map.person.content}<span class="author">{attribute_view_gui attribute=$child.data_map.person show_position=0 show_colon=0 link=0}</span>{/if}</a></h3>
		<div class="attribute-short"><a href={$child.url_alias|ezurl}>{attribute_view_gui attribute=$child.data_map.intro}</a></div>
	</div>
</div>
		</div>
	</td>
	<td id="td_hotpic">{if $image.has_content}<div id="hotpic">{attribute_view_gui attribute=$image image_class=imagelarge}</div>{else}&nbsp;{/if}</td>
</tr>
<tr>
	<td id="td_week_topic"><div id="week_topic">Тема дня</div></td>
	<td id="td_topic_name">{*<!-- Притяжение Европы Притяжениe Европы -->*}
{def $topic_url=$node.data_map.topic_url}
{* $node.data_map.topic_url|attribute(show, 1) *}
{* if $topic}	<div id="topic_name"><a href={$topic.main_node.url_alias|ezurl}>{$topic.name|wash()}&nbsp;<span class="go_topic" id="go_topic"><img src={"images/go_topic.gif"|ezdesign} width="32" height="32" border="0" alt=""></span></a></div>{/if *}
{if $topic_url}	<div id="topic_name"><a href={$topic_url.value|ezurl}>{$topic_url.data_text|wash()}</a></div>{/if}
	</td></tr></table>
{*** HOT ARTICLE END ***}
</div>
		</div>
	</div>
<!-- /hotblock -->
{*** COLUMNS-FRONTPAGE BLOCK ***}
	<div class="columns-frontpage">
		<div class="left-column-position">
			<div class="left-column">
			<!-- Left Content: START -->
                   {* attribute_view_gui attribute=$node.object.data_map.left_column *}
<h1 class="column-a-head"><a href="{$razdel.url_alias|ezurl(no)}">Мировая повестка</a></h1>
{foreach $list_items as $child offset 1 max 3}
	{node_view_gui view=frontpage content_node=$child}
{/foreach}

<!-- Comics Start -->
{*** COMICS ***}
{def $comics_item=$node.data_map.comics.content}
{node_view_gui view=frontpage content_node=$comics_item.main_node image_class=listitem}
{*** COMICS ENDS ***}

{*** VIDEO ***}
{def $video_item=$node.data_map.video.content}
         {node_view_gui view=frontpage content_node=$video_item.main_node image_class=listitem}
{*** VIDEO ENDS ***}
{foreach $list_items as $child offset 4 max $limit}
	{node_view_gui view=frontpage content_node=$child}
{/foreach}

                <!-- Left Content: END -->
            </div>
        </div>
        <div class="center-column-position">
            <div class="center-column">
                <div class="overflow-fix">
                <!-- Center Content: START -->
                    {* attribute_view_gui attribute=$node.object.data_map.center_column *}
                    <h1 class="column-a-head"><a href="{$razdel2.url_alias|ezurl(no)}">Проблемное поле</a></h1>
{foreach $list2_items as $child max 4}
	{node_view_gui view=frontpage content_node=$child}
{/foreach}

{foreach $list3_items as $child max $limit3(dec|1)}
	{node_view_gui view=frontpage content_node=$child}
{/foreach}


{foreach $list2_items as $child offset 4 max $limit2(dec|2)}
	{node_view_gui view=frontpage content_node=$child}
{/foreach}


                <!-- Center Content: END -->
                </div>
            </div>
        </div>
        <div class="right-column-position">
            <div class="right-column">
                  {* attribute_view_gui attribute=$node.object.data_map.right_column *}
            </div>
        </div>
    </div>

    <div class="attribute-bottom-column">
        {* attribute_view_gui attribute=$node.object.data_map.bottom_column *}
    </div>

    </div>
</div>
