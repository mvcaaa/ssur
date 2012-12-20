{*?template charset="koi8-r"?*}{* LJ Post - Full view *}
<div class="content-view-full">
    <div class="class-lj_post">

{* TOPICs *}
{def $reverse_related_objects_count=fetch( 'content', 'reverse_related_objects_count', hash( 'object_id', $node.object.id ) )} 

{* <!-- , 'attribute_identifier', 'Topic' | , 'all_relations', true()  --> *}

{* $related_objects.0 | attribute( show, 1 ) *}
{* $related_objects|count() *}

	{section show=$reverse_related_objects_count|ne(0)}
	{def $reverse_related_objects=fetch( 'content', 'reverse_related_objects', hash( 'object_id', $node.object.id) )}

{section loop=$reverse_related_objects var=$topic}
{/section}

	{/section}

{section show=$topic.related_contentobject_count}
<div class="sect" id="doctopic">
<div class="line3"></div>

<div class="blhdr"><span>Материалы по теме:</span></div>
		{section var=$obj max=7 loop=$topic.related_contentobject_array }
		{section-exclude match=eq($obj.id, $node.object.id)}

<div class="bl">
	<div class="hdr"><a href={$obj.main_node.url_alias|ezurl}>{$obj.data_map.title.content|wash}</a></div>
			{section show=$obj.data_map.intro.content.is_empty|not}
	<div class="anno">
				{attribute_view_gui attribute=$obj.data_map.intro}
	</div>
		    {/section}
</div>
		{/section}
{* $topic |attribute(show,1) *}
<div class="more"><a href={$topic.main_node.url_alias|ezurl}>Все материалы по теме</a></div>
<div class="line3"></div>
</div><!-- /sect #doc-topic -->
{/section}


<div class="sect" id="document">
<div class="line3"></div>

{* $node |attribute(show, 1) *}

<div class="blhdr"><span>{$node.parent.name|wash()}</span></div>

<div class="doc">
<div class="text">


	{section show=$reverse_related_objects_count|ne(0)}
	{def $reverse_related_objects=fetch( 'content', 'reverse_related_objects', hash( 'object_id', $node.object.id) )}
	<div class="topic">Тема: <span class="topic-title">{section loop=$reverse_related_objects var=$topic}{content_view_gui view=embed-inline content_object=$topic}{delimiter},{/delimiter}{/section}</span>
	</div>
	{/section}

        <h1 class=hdr>{$node.object.data_map.title.content|wash()}</h1>

        <h3 class=hdr>{$node.object.data_map.short_title.content|wash()}</h3>

		{section show=$node.object.data_map.person.content}
		<div class="author">
				{attribute_view_gui attribute=$node.object.data_map.person show_image=1}
		</div>
	    {/section}

        {section show=and($node.object.data_map.image.content, $node.object.data_map.person.content.data_map.image.content|not) }
            <div class="attribute-image">
                {attribute_view_gui attribute=$node.object.data_map.image image_class=medium}
            </div>
        {/section}

        {section show=$node.object.data_map.intro.content.is_empty|not}
            <div class="attribute-short">
                {attribute_view_gui attribute=$node.object.data_map.intro}
            </div>
        {/section}

        {section show=$node.object.data_map.body.content.is_empty|not}
            <div class="attribute-long">
                {attribute_view_gui attribute=$node.object.data_map.body}
            </div>
        {/section}

	<div class="fix"></div>
	</div>	<!-- /text -->
		<div class="misc">
        <div class="attribute-byline">
        <p class="date">
             {$node.object.published|l10n(date)} | {$node.object.published|l10n(shorttime)}
        </p>
        {section show=$node.object.data_map.source.content}
		<p>
			{attribute_view_gui attribute=$node.object.data_map.source}
		</p>
		{/section}
        </div>
		</div>

		<div class="icons">
        <span class="attribute-printversion">
			<a href="{concat('/layout/set/print/', $node.url_alias|ezurl('no')) }"><img src={'images/print.gif'|ezdesign} width="20" height="16" alt="{"Print version"|i18n("extention/translations")|wash}" border=0></a>
        </span>
        <span class="attribute-tipafriend">
             <a href={concat('/content/tipafriend/',$node.node_id)|ezurl}><img src={'images/email.gif'|ezdesign} width="20" height="16" alt="{"Send by e-mail"|i18n("extention/translations")|wash}" border=0></a>
        </span>
        <span class="attribute-disciss">
             <a href="#"><img src={'images/discuss.gif'|ezdesign} width="20" height="16" alt="{"Discuss"|i18n("extention/translations")|wash}" border=0></a>
        </span>
		</div>

<!--         <div class="attribute-pdf">
          <p>
             <a href={concat('/content/pdf/',$node.node_id)|ezurl}>{'application/pdf'|mimetype_icon( small, "Download PDF"|i18n( "design/base" ) )} {"Download PDF version of this page"|i18n( "design/base" )}</a>
          </p>
        </div>
 -->

</div><!-- /doc -->

</div><!-- /sect #({$node.url}) -->


        {* Should we allow comments? *}
        {section show=is_unset( $versionview_mode )}
        {section show=$node.object.data_map.enable_comments.content}
<div class="sect" id="commentaries">
<div class="blhdr"><span>Обсуждение</span></div>
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


