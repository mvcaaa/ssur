{*?template charset="koi8-r"?*}{* 
 Articles on Morda in NEWS Column, derived from 'Article - Line view'
 for video, uses node
*}
{default image_class=articleimage 
}
<div class="content-view-frontpage float-break" id="frontpage-video">
    <div class="class-article">

	<div><img src={"images/direct_speech.gif"|ezdesign} width="170" height="30" border="0" alt=""></div>
	
    <h2><a href={$node.url_alias|ezurl}>{attribute_view_gui attribute=$node.data_map.person show_position=0 show_colon=1 link=0}</a></h2>

	{section show=$node.data_map.person.content|false()}
	<div class="attribute-byline">
{*	<p class="author">
		{attribute_view_gui attribute=$node.data_map.person}
	</p>
	<p class="date">
		{$node.object.published|l10n(date)}
	</p>
*}	</div>
	{/section}

    {section show=$node.data_map.intro.content.is_empty|not}
    <div class="attribute-short float-break">
        {attribute_view_gui attribute=$node.data_map.intro href=$node.url_alias|ezurl ending="&nbsp;&gt;&gt;"}
{* 	<span class="linkmore"><a href={$node.url_alias|ezurl}>&nbsp;&gt;&gt;</a></span> *}
    </div>
    {/section}

    </div>
</div>