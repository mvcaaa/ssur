{*?template charset="koi8-r"?*}
{* Article on frontpage - Line view *}
{*
 Проблемное поле - 2493
*}
{default image_class=imagefrontpagewide
 		 annotation_limit = 100
}
<div class="content-view-line">
    <div class="class-article float-break">

    <h2><a href={$node.url_alias|ezurl}>{$node.data_map.title.content|wash}</a></h2>

	{section show=$node.data_map.person.content}
	<div class="attribute-byline">
	<p class="author">
		{attribute_view_gui attribute=$node.data_map.person}
	</p>
{*	<p class="date">
		{$node.object.published|l10n(date)}
	</p>
*}	</div>
	{/section}

{* $person.content.data_map.image.has_content, $person.content.data_map.image,  *}
	{def $person=$node.data_map.person
	     $image=cond( 
			  $node.data_map.image.has_content, $node.data_map.image) 
	}
{if $node.node_id|eq(106926)}
{* $image.content | attribute(show, 1) *}
{/if}
        {section show=$image.has_content}
        <div class="attribute-image">
            {attribute_view_gui image_class=$image_class href=$node.url_alias|ezurl attribute=$image}
        </div>
        {/section}



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

	{if $topic|false()}
    <div class="attribute-topic">
	Тема: {content_view_gui view=embed-inline content_object=$topic}
	</div>
	{/if}
	
    {section show=$node.data_map.intro.content.is_empty|not}
    <div class="attribute-short float-break">
        {attribute_view_gui attribute=$node.data_map.intro}
{*	<p class="linkmore"><a href={$node.url_alias|ezurl}>читать далее&nbsp;&raquo;</a></p> *}
    </div>
    {/section}

    </div>
</div>