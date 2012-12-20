{*?template charset="koi8-r"?*}{* Person - Full view 
  derived from article
*}
<div class="content-view-full">
    <div class="class-person">

<div class="sect" id="document">

{* $node.object.data_map.image |attribute(show, 1) *}

<div class="doc">
<div class="text">

		{section show=$node.name|ne('')}
		<h1 class=hdr>{$node.name|wash()}</h1>
		{/section}

		{section show=$node.object.data_map.position.has_content}
        <h3 class=hdr>{$node.object.data_map.position.content|wash()}</h3>
		{/section}

{* $node.object.data_map.image.content | attribute(show, 2) *}
        {section show=and($node.object.data_map.image.has_content) }
            <div class="attribute-image">
                {attribute_view_gui attribute=$node.object.data_map.image image_class=medium alignment=left}
            </div>
        {/section}

		{section show=$node.object.data_map.person.content}
		<div class="author">
				{attribute_view_gui attribute=$node.object.data_map.person show_image=1}
		</div>
	    {/section}

        {section show=$node.object.data_map.bio.content.is_empty|not}
            <div class="attribute-short">
                {attribute_view_gui attribute=$node.object.data_map.bio}
            </div>
        {/section}

		
{* Documents -> Person *}
{def $reverse_related_objects_count=fetch( 
		'content', 'reverse_related_objects_count', 
		hash( 'object_id', $node.object.id,
			  'attribute_identifier', 'article/person')
		)}

		{section show=$reverse_related_objects_count|ne(0)}
{def $reverse_related_objects=fetch( 
		'content', 'reverse_related_objects', 
		hash( 'object_id', $node.object.id,
			  'attribute_identifier', 'article/person',
			  'sort_by',  array( 'published', false() )
			  )
		)}

<hr class="hr float-break">	
<div class="doclist ">
<h2 class=hdr>Публикации с 2004г. </h3>

	<div class="content-view-children">
			{section loop=$reverse_related_objects var=$obj}
<div class="bl">
	<div class="hdr"><a href={$obj.main_node.url_alias|ezurl}>{$obj.data_map.title.content|wash}</a><span class="date"> | {$obj.published|l10n(date)}</span></div>
<!-- 	<div class="attribute-byline">
        <p class="date"> {$obj.published|l10n(date)} {* | $obj.published|l10n(shorttime) *} </p>
	</div> -->
</div>				
			{/section}
	</div>
</div>
	{/section}

<hr class=hr>
<p class=big><b>Публикации в Русском Журнале до 2004г. можно найти в Архиве по адресу <a href="http://old.russ.ru/authors">http://old.russ.ru/authors</a></b></p>
		
	<div class="fix"></div>
</div>	<!-- /text -->
</div><!-- /doc -->
</div><!-- /sect #({$node.url}) -->

    </div>
</div>


