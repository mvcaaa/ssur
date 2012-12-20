{*?template charset=latin1?*}
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="{$site.http_equiv.Content-language|wash}" lang="{$site.http_equiv.Content-language|wash}">
<head>
{def $basket_is_empty   = cond( $current_user.is_logged_in, fetch( shop, basket ).is_empty, 1 )
     $current_node_id   = first_set( $module_result.node_id, 0 )
     $user_hash         = concat( $current_user.role_id_list|implode( ',' ), ',', $current_user.limited_assignment_value_list|implode( ',' ) )
     $user_id           = $current_user.contentobject_id}

{if and( $current_node_id|eq(0), is_set( $module_result.path.0 ) , is_set( $module_result.path[$module_result.path|count|dec].node_id ) )}
    {set $current_node_id = $module_result.path[$module_result.path|count|dec].node_id}
{/if}

{def $pagestyle        = 'nosidemenu noextrainfo'
     $locales          = fetch( 'content', 'translation_list' )
     $pagerootdepth    = ezini( 'SiteSettings', 'RootNodeDepth', 'site.ini' )
     $indexpage        = ezini( 'NodeSettings', 'RootNode', 'content.ini' )
     $infobox_count    = 0
     $path_normalized  = ''
     $path_array       = array()
     $pagedesign_class = fetch( 'content', 'class', hash( 'class_id', 'template_look' ) )
     $pagedepth        = $module_result.path|count
     $content_info     = hash()
}

{if $pagedesign_class.object_count|eq( 0 )|not}
    {def $pagedesign = $pagedesign_class.object_list[0]}
{/if}

{if is_set( $module_result.content_info )}
    {set $content_info = $module_result.content_info}
{/if}

    <link rel="stylesheet" type="text/css" href={"stylesheets/popunder.css"|ezdesign} />

{literal}
<!-- IE conditional comments; for bug fixes for different IE versions -->
<!--[if IE 5]>     <style type="text/css"> @import url({"stylesheets/browsers/ie5.css"|ezdesign(no)});    </style> <![endif]-->
<!--[if lte IE 7]> <style type="text/css"> @import url({"stylesheets/browsers/ie7lte.css"|ezdesign(no)}); </style> <![endif]-->
{/literal}

</head>
<body>
{def $morda_node_id = 2}
{def $morda_node=fetch( content, node, hash( node_id, $morda_node_id ))}

<h1><a href={"/"|ezroot} target="_parent">{$site.title}</a></h1>

{*** BEST BLOCK ***}
{def $best=$morda_node.data_map.best.content.relation_list}
{* $best|attribute(show, 2) *}

{if  $best|count()} 
<h2>{$morda_node.data_map.best.contentclass_attribute_name}</h2>
<div class="best float-break">

{** Save current $node **}
{def $tmp_node = $node}

      {foreach $best as $index=>$relation_object }
		{def $node=fetch( content, node, hash( node_id, $relation_object.node_id ))}
		{* node_view_gui view=listitem content_node=$best_node *}
<div class="listitem{if $index|eq($best|count()|dec())} last{/if}">
    <div class="node float-break">
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
{*
	{section show=$node.data_map.person.content}
		<div class="attribute-author">
			{attribute_view_gui attribute=$node.data_map.person link=false()}
		</div>
	{/section}
*}    
	<h3>{if $node.data_map.person.content}{attribute_view_gui attribute=$node.data_map.person link=false()}: {/if}<a href={$node.url_alias|ezroot} target="_parent">{$node.data_map.title.content|wash}</a></h3>

    </div>
</div>
      {/foreach}

{** Restore current $node **}	  
{def $node = $tmp_node}
</div><!-- /sect #best -->
{/if} {* /if $bestblock_array *}

<!--DEBUG_REPORT-->

</body>
</html>
