{*?template charset="koi8-r"?*}{* Article - Full view - Print Layout *}

<div class="content-view-full">
    <div class="class-article">

        <h1>{$node.data_map.title.content|wash()}</h1>

        {if eq( ezini( 'article', 'ShortTitleInFullView', 'content.ini' ), 'enabled' )}
            {if $node.data_map.short_title.has_content} 
        <div class="attribute-header">
            <h2>{$node.data_map.short_title.content|wash()}</h2>
        </div>
	    {/if}
        {/if}


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


        {if $node.data_map.person.has_content}
        <div class="attribute-byline">
        <p class="author">
             {attribute_view_gui attribute=$node.data_map.person}
        </p>
        </div>
        {/if}

	{def $person=$node.data_map.person
	     $image=cond(  $node.data_map.image.has_content, $node.data_map.image,
			   $person.content.data_map.image.has_content, $person.content.data_map.image
			  ) 
	}


        {if eq( ezini( 'article', 'ImageInFullView', 'content.ini' ), 'enabled' )}
	    {if $image.has_content}
                <div class="attribute-image">
                    {attribute_view_gui attribute=$image image_class=articleimage alignment=left}
                </div>
            {/if}
        {/if}

        {if eq( ezini( 'article', 'SummaryInFullView', 'content.ini' ), 'enabled' )}
            {if $node.data_map.intro.content.is_empty|not}
                <div class="attribute-short">
                    {attribute_view_gui attribute=$node.data_map.intro}
                </div>
            {/if}
        {/if}


        {section show=$node.data_map.body.content.is_empty|not}
            <div class="attribute-long">
                {attribute_view_gui attribute=$node.data_map.body adwords=yes}
            </div>
        {/section}


        <div class="attribute-byline">
        <p class="date">
{if $node.object.data_map.date_time.has_content}
	{$node.object.data_map.date_time.value.timestamp|l10n(shortdatetime)}
{else}  
        {$node.object.published|l10n(shortdatetime)}
{/if}
        </p>

	{section show=$node.object.data_map.source.content}
	<p>
		{attribute_view_gui attribute=$node.object.data_map.source}
	</p>
	{/section}
	</div>

    </div>
</div>

<div class="adblock">
{sape_links('5')}
</div>
