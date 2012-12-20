{*?template charset="koi8-r"?*}
{* Article on frontpage - Line view *}
{*
  Статьи в левой колонке на главной. Раздел "Мировая повестка" 
*}
{default image_class=listitem 
 		 annotation_limit = 100
}
<div class="content-view-line">
    <div class="class-article float-break">

{*     <h2><a href={$node.url_alias|ezurl}>{$node.data_map.title.content|wash}</a></h2> *}

	{def $person=$node.data_map.person
	     $image=cond( $person.content.data_map.image.has_content, $person.content.data_map.image, 
			  $node.data_map.image.has_content, $node.data_map.image) 
	}
{* $image.content.original | attribute(show, 1) *}

        {section show=$image.has_content}
        <div class="attribute-image">
            {attribute_view_gui image_class=$image_class href=$node.url_alias|ezurl attribute=$image}
			{if is_set($person)}
				<p class="bio"><a href={$person.content.main_node.url_alias|ezurl}>Био</a></p>
			{/if}
        </div>
        {/section}

	<h2><a href={$node.url_alias|ezurl}>{attribute_view_gui attribute=$node.data_map.person link=false() }</a></h2>

{*
	{section show=$node.data_map.person.content}
	<div class="attribute-byline">
	<p class="author">
		{attribute_view_gui attribute=$node.data_map.person}
	</p>
	<p class="date">
		{$node.object.published|l10n(date)}
	</p>
	</div>
	{/section}
*}

{* TOPICs *}
{def $topics=fetch( 'content', 'reverse_related_objects', hash( 'object_id', $node.object.id) )}
		{* <!-- , 'attribute_identifier', 'Topic' | , 'all_relations', true()  --> *}
		{* $related_objects|attribute( show, 1 ) *}
{def $topic=0}
{foreach $topics as $topic}
{if eq($topic.class_name,'Topic')}
	{break}
{/if}
{/foreach}
{* $topic|attribute(show, 1) *}

	{if $topic}
    <div class="attribute-topic">
	{content_view_gui view=embed-inline content_object=$topic}
	</div>
	{/if}
	
    {section show=$node.data_map.intro.content.is_empty|not}
    <div class="attribute-short float-break" style="clear: left;">
        {attribute_view_gui attribute=$node.data_map.intro}
{if $node.node_id|eq(107029)}
{* $node.data_map.enable_comments|attribute(show, 1) *}
{/if}
		{if $node.data_map.enable_comments.content}	
	<p class="linkmore comments"><a href="{$node.url_alias|ezurl(no)}#comments">Комментарии</a></p>
		{/if}
    </div>
    {/section}

    </div>
</div>