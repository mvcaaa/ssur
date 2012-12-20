{*?template charset="koi8-r"?*}{* Article - Full view *}

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

{*
        {section show=$node.data_map.author.content.is_empty|not()}
        <div class="attribute-byline">
        <p class="author">
             {attribute_view_gui attribute=$node.data_map.author}
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

{if $image.has_content}
{* $image.content | attribute(show, 1 ) *}
{/if}


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
{* 116006 *}
{*
{if $node.node_id|eq(107761)} 
{$node.object.data_map.date_time.value|attribute(show, 1)}
{$node.object.data_map.date_time.value.timestamp|l10n(shortdatetime)}
{/if}
*}
	{section show=$node.object.data_map.source.content}
	<p>
		{attribute_view_gui attribute=$node.object.data_map.source}
	</p>
	{/section}
	</div>

	<div class="icons">
        <span class="attribute-printversion">
			<a href="{concat('/layout/set/print/', $node.url_alias|ezurl('no')) }"><img src={'images/print.gif'|ezdesign} width="20" height="16" alt="{"Print version"|i18n("design/base")|wash}" border=0></a>
        </span>
{*
        <span class="attribute-tipafriend">
             <a href={concat('/content/tipafriend/',$node.node_id)|ezurl}><img src={'images/email.gif'|ezdesign} width="20" height="16" alt="{"Send by e-mail"|i18n("design/base")|wash}" border=0></a>
        </span>
        <span class="attribute-disciss">
             <a href={"http://forums.russ.ru"|ezurl}><img src={'images/discuss.gif'|ezdesign} width="20" height="16" alt="{"Discuss"|i18n("design/base")|wash}" border=0></a>
        </span>
*}
	</div>

{*
	{if $node.object.data_map.see_also.has_content|false()}
            <div class="attribute-topic">
		<h3>{$node.object.data_map.see_also.contentclass_attribute_name|wash()}</h3>
		{attribute_view_gui attribute=$node.object.data_map.see_also show_image=0}
	    </div>
	{/if}
*}

{*
        <div class="attribute-tipafriend">
          <p>
             <a href={concat('/content/tipafriend/',$node.node_id)|ezurl}>{"Tip a friend"|i18n("design/base")}</a>
          </p>
        </div>

        <div class="attribute-pdf">
          <p>
             <a href={concat('/content/pdf/',$node.node_id)|ezurl}>{'application/pdf'|mimetype_icon( small, "Download PDF"|i18n( "design/base" ) )} {"Download PDF version of this page"|i18n( "design/base" )}</a>
          </p>
        </div>

*}

        {* Should we allow comments? *}
        {section show=is_unset( $versionview_mode )}
        {section show=or($node.object.data_map.enable_comments.content, $disable_comments)}
<a name="comments"></a>
<h3 class="comments_hdr"><span>Обсуждение</span></h3>
<div class="sect" id="commentaries">
{def $comments_count=fetch_alias( comments_count, hash( parent_node_id, $node.node_id ) ) }
{section show=$comments_count}
<!-- comments_count: {$comments_count} -->
{/section}
<!--             <h2>{"Comments"|i18n("design/base")}</h2> -->
	<div class="content-view-children">
					{section name=Child loop=fetch_alias( comments, hash( parent_node_id, $node.node_id ) )}
                        {node_view_gui view='line' content_node=$:item}
                    {/section}
	</div>

                {* Are we allowed to create new object under this node? *}
                {section show=fetch( content, access,
                                     hash( access, 'create',
                                           contentobject, $node,
                                           contentclass_id, 'comment' ) )}
	<form method="post" action={"content/action"|ezurl}>
		<input type="hidden" name="ClassIdentifier" value="comment" />
		<input type="hidden" name="NodeID" value="{$node.node_id}" />
		<input type="hidden" name="ContentLanguageCode" value="rus-RU" />
		<input class="button new_comment" type="submit" name="NewButton" value="{'New Comment'|i18n( 'design/base' )}" />
<!-- 		<input class="button new_comment" type="submit" name="NewButton" value="{$node.name|wash}" /> -->
	</form>
                {section-else}
	<h3>{"You are not allowed to create comments."|i18n("design/base")}</h3>
                {/section}
</div><!-- /sect #commentary -->
        {/section}
        {/section}

    </div>
</div>

