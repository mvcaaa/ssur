{*?template charset="koi8-r"?*}
{* Topic - Full view *}
<div class="content-view-full">
    <div class="class-topic">

{*
        <h1>{$node.data_map.title.content|wash()}</h1>
*}
        <div class="attribute-header">
            <h1>{'Topic'|i18n( 'design/base' )}: {$node.data_map.title.content|wash()}</h1>
        </div>


        {if eq( ezini( 'topic', 'ImageInFullView', 'content.ini' ), 'enabled' )}
            {if $node.data_map.image.has_content}
                <div class="attribute-image">
                    {attribute_view_gui attribute=$node.data_map.image image_class=articleimage alignment=none}

                    {if $node.data_map.caption.has_content|false()}
                    <div class="caption">
                        {attribute_view_gui attribute=$node.data_map.caption}
                    </div>
                    {/if}
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

        {if $node.data_map.body.content.is_empty|not}
            <div class="attribute-long">
                {attribute_view_gui attribute=$node.data_map.body}
            </div>
        {/if}
{*
        <div class="attribute-byline">
        <p class="date">
             {$node.object.published|l10n(shortdatetime)}
        </p>
	</div>
*}	

{def $page_limit = 20

	$related_objects_count=fetch( 'content', 'related_objects_count', 
											hash( 'object_id', $node.object.id )) 
	
	$related_objects=fetch( 'content', 'related_objects', 
							hash( 'object_id', $node.object.id, 
								  'sort_by', array( array( 'published', false() ))
						   ) )

	}
{*
	$related_objects_count=fetch_alias('related_objects_count', hash( 'object_id', $node.object.id ) ) 
	$related_objects=fetch_alias('related_objects', hash( 'object_id', $node.object.id,
															   'sort_by', array( array( 'published', false() )) 
															   ) )

*}
{* $related_objects|attribute(show, 1) *}

	
	{if $related_objects_count}
		<div class="attribute-related-objects float-break">
 		{foreach $related_objects as $related_object}
			{node_view_gui view=listitem content_node=$related_object.main_node show_topic=false()}
		{/foreach}
		</div>
            {include name=navigator
                     uri='design:navigator/google.tpl'
                     page_uri=$node.url_alias
                     item_count=$related_objects_count
                     view_parameters=$view_parameters
                     item_limit=$page_limit}
	{/if}

    </div>
</div>