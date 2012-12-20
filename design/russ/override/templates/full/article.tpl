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

	<div class="icons" style="margin-top: 10px;">
		<table>
			<tr>
				<td>
					{literal}<script type="text/javascript">VK.init({apiId: 2438313, onlyWidgets: true});</script>{/literal}
					<div id="vk_like"></div>
					{literal}<script type="text/javascript">VK.Widgets.Like("vk_like", {type: "button", verb: 1});</script>{/literal}
				</td>
				<td>
					<a href="http://twitter.com/share" class="twitter-share-button" data-count="horizontal" data-lang="ru">рБХРМСРЭ</a><script type="text/javascript" src="http://platform.twitter.com/widgets.js"></script>
				</td>
				<td>
					<div id="" style="margin-left: 20px; float: left"><nobr>
						<a target="_blank" title="Twitter" href="http://twitter.com/home?status={$node.data_map.title.content|wash()} http://russ.ru/{$node.url_alias}"><img border="0" src="/design/russ/images/twitter.png"></a>&nbsp;
						<a target="_blank" title="Livejournal" href="http://www.livejournal.com/update.bml?event=http://russ.ru/{$node.url_alias}&amp;subject={$node.data_map.title.content|wash()}"><img border="0" src="/design/russ/images/livejournal.png" /></a>&nbsp;
						<a target="_blank" title="Facebook" href="http://www.facebook.com/sharer.php?u=http://russ.ru/{$node.url_alias}"><img border="0" src="/design/russ/images/facebook.png" /></a>&nbsp;
						<a href="http://vkontakte.ru/share.php?url=http://russ.ru/{$node.url_alias}" title="Опубликовать ВКонтакте" target="_blank"><img border="0" src="/design/russ/images/vkontakte.png" /></a>&nbsp;
			 		</nobr></div>
				</td>
				<td style="vertical-align: middle; text-align: right;"><a href="{concat('/layout/set/print/', $node.url_alias|ezurl('no')) }"><img src={'images/print.gif'|ezdesign} width="20" height="16" alt="{"Print version"|i18n("design/base")|wash}" border="0" style="float: left; margin-right: 5px;" /> Распечатать</a></td>
			</tr>
		</table>
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
		<div id="fb-root" style="margin-top: 10px;"></div><script src="http://connect.facebook.net/ru_RU/all.js#appId=221070994610708&amp;xfbml=1"></script>
		<fb:like href="{$node.url_alias|ezurl('no','full')}" send="false" width="700" show_faces="true" action="like" font=""></fb:like><br><br>
		<fb:comments href="{$node.url_alias|ezurl('no','full')}" num_posts="20" width="700" colorscheme="light"></fb:comments>
	</div>
</div>
