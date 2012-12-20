{*?template charset="koi8-r"?*}

<h2><a href="{'/content/advancedsearch'|ezurl('no')}">{"Search"|i18n("design/standard/content/search")}</a></h2>

<!-- $search_contentclass_id: {$search_contentclass_id} -->
<!-- $search_button: {$search_button} -->
<!-- $search_text: {$search_text} -->
<!-- $search_page_limit: {$search_page_limit} -->

{let search=false()}
{section show=$use_template_search}
    {set page_limit=20}
    {switch match=$search_page_limit}
    {case match=1}
        {set page_limit=5}
    {/case}
    {case match=2}
        {set page_limit=10}
    {/case}
    {case match=3}
        {set page_limit=20}
    {/case}
    {case match=4}
        {set page_limit=30}
    {/case}
    {case match=5}
        {set page_limit=50}
    {/case}
    {case/}
    {/switch}
	{switch match=$search_contentclass_id}
	{case match=23}
	    {set search=fetch(content,search,
                      hash(text,$search_text,
			subtree_array,7060,
                           class_id,$search_contentclass_id))}					 
		{set search_result=$search['SearchResult']}

		
<!-- $authors:---{$search_result|count}--- -->
{* <!-- {foreach $search_result as $id=>$author}
{$id} - <a href="http://ed.russ.dada.ru/{$author.url_alias}">{$author.name|wash}</a> - {$author.object.id} - {def $rel_articles=fetch( 'content', 'reverse_related_objects_count', hash( 'object_id', $author.object.id ) )} {$rel_articles}<br>
{/foreach} -->
*}
		{def $person_id_array=array()} 
		{foreach $search['SearchResult'] as $person_node}{set $person_id_array=$person_id_array|append(int($person_node.contentobject_id )) }{/foreach}
		{def $nodes_count=fetch( 'content', 'list_count',
        	hash( 'parent_node_id', 2,
			  'depth', 4, 
              'attribute_filter', array(
                                  array( 'article/person',
                                   'in',
                                  $person_id_array ) ) ) )
		}
		{def $nodes=fetch( 'content', 'list',
        	hash( 'parent_node_id', 2,
			  'depth', 4, 
			  'sort_by', array( array( 'published', false()), array( 'name', true()) ),
			  offset,$view_parameters.offset,
              limit,$page_limit,
              'attribute_filter', array(
                                  array( 'article/person',
                                   'in',
                                  $person_id_array ) ) ) )
		}

    {set search_result=$nodes}
    {set search_count=$nodes_count}
    {set stop_word_array=$search['StopWordArray']}
    {set search_data=$search}

	{/case}
	{case} {* $search_contentclass_id, 16 - Article *}
<!-- <br>
---$page_limit:{$page_limit}---
---$search_sub_tree:{$search_sub_tree}---
---$search_section_id:{$search_section_id}---
<br> -->
	    {set search=fetch(content,search,
                      hash(text,$search_text,
						  'sort_by', array( array( 'published', false()), array( 'name', true()) ),
						   section_id,$search_section_id,
                           subtree_array,$search_sub_tree,
                           class_id, 16, 
                           class_attribute_id,$search_contentclass_attribute_id,
                           offset,$view_parameters.offset,
                           publish_date,$search_date,
                           limit,$page_limit))}
    {set search_result=$search['SearchResult']}
    {set search_count=$search['SearchCount']}
    {set stop_word_array=$search['StopWordArray']}
    {set search_data=$search}

	{/case}
	{/switch}
	
{/section}

<form action={"/content/advancedsearch/"|ezurl} method="get">

<!-- <div class="maincontentheader">
<h1>{"Advanced search"|i18n("design/standard/content/search")}</h1>
</div> -->

<div style="float: none; clear: both; padding: 0em 0em 0.5em 0em; background: none;">
<div style="float: left; width: 49%; ">
<!-- border-right: 1px solid black; margin-right: 1px; background: pink; -->

<div class="block" style="float: left; ">
<label>{"Search the words"|i18n("design/standard/content/search")}</label><div class="labelbreak"></div>
<input style="width: 250px;" class="box" type="text" size="40" name="SearchText" value="{$full_search_text|wash}" />
</div>
<!-- <div class="block">
<label>{"Search the exact phrase"|i18n("design/standard/content/search")}</label><div class="labelbreak"></div>
<input class="box" type="text" size="40" name="PhraseSearchText" value="{$phrase_search_text|wash}" />
</div> -->

<div class="buttonblock" style="float: left; margin: 1.3em 0em 0em 0.5em; ">
<input class="button" type="submit" name="SearchButton" value="{'Search!'|i18n('design/standard/content/search')}" />
</div>

<div class="block">
<div class="element">
{if $search_contentclass_id|eq(23) }
<!-- $:{$search_contentclass_id} -->
{/if}

<input type="radio" name="SearchContentClassID" id="alltexts" {if eq($search_contentclass_id, -1) }checked="checked" {/if}value="-1"><label style="display: inline;" for="alltexts">{"Search in all texts"|i18n("design/standard/content/search")}</label>
<!-- <div class="labelbreak"></div> -->&nbsp;
<input type="radio" name="SearchContentClassID" id="inauthors" {if eq($search_contentclass_id, 23) }checked="checked" {/if}value="23"><label style="display: inline;" for="inauthors">{"Search in Authors"|i18n("design/standard/content/search")}</label>
</div>

</div>

</div><!-- /framing for line and float -->

<div style="float: left; width: 49%; border-left: 3px double #7a7a7a; margin-left: 0px; ">
<!--  background: linen; -->

<div class="block" style="padding: 0em 0em 0em 1em">
<div class="element" style="padding: 0em 0em 0.5em 0em">

<label>{"Published"|i18n("design/standard/content/search")}</label><div class="labelbreak"></div>
<select name="SearchDate">
<option value="-1" {section show=eq($search_date,-1)}selected="selected"{/section}>{"Any time"|i18n("design/standard/content/search")}</option>
<option value="1" {section show=eq($search_date,1)}selected="selected"{/section}>{"Last day"|i18n("design/standard/content/search")}</option>
<option value="2" {section show=eq($search_date,2)}selected="selected"{/section}>{"Last week"|i18n("design/standard/content/search")}</option>
<option value="3" {section show=eq($search_date,3)}selected="selected"{/section}>{"Last month"|i18n("design/standard/content/search")}</option>
<option value="4" {section show=eq($search_date,4)}selected="selected"{/section}>{"Last three months"|i18n("design/standard/content/search")}</option>
<option value="5" {section show=eq($search_date,5)}selected="selected"{/section}>{"Last year"|i18n("design/standard/content/search")}</option>
</select>
</div>

<div class="break"></div>

<!-- $search_page_limit:{$search_page_limit} -->
<!-- $page_limit:{$page_limit} -->
{section show=$use_template_search}
<div class="element">
<label>{"Display per page"|i18n("design/standard/content/search")}</label><div class="labelbreak"></div>
<select name="SearchPageLimit">
<option value="1" {section show=eq($search_page_limit,1)}selected="selected"{/section}>{"5 items"|i18n("design/standard/content/search")}</option>
<option value="2" {section show=eq($search_page_limit,2)}selected="selected"{/section}>{"10 items"|i18n("design/standard/content/search")}</option>
<option value="3" {section show=or(array(1,2,4,5)|contains($search_page_limit)|not,eq($search_page_limit,3))}selected="selected"{/section}>{"20 items"|i18n("design/standard/content/search")}</option>
<option value="4" {section show=eq($search_page_limit,4)}selected="selected"{/section}>{"30 items"|i18n("design/standard/content/search")}</option>
<option value="5" {section show=eq($search_page_limit,5)}selected="selected"{/section}>{"50 items"|i18n("design/standard/content/search")}</option>
</select>
</div>
{/section}

{section name=SubTree loop=$search_sub_tree}
<input type="hidden" name="SubTreeArray[]" value="{$:item}" />
{/section}


<div class="break"></div>
</div>

</div><!-- /framing for line and float -->

<div class="break"></div>
</div><!-- /end framig -->


{section show=or($search_text,eq(ezini('SearchSettings','AllowEmptySearch','site.ini'),'enabled') )}
<br/>
{switch name=Sw match=$search_count}
  {case match=0}
<div class="warning">
<h2>{'No results were found when searching for "%1"'|i18n("design/standard/content/search",,array($search_text|wash))}</h2>
</div>
  {/case}
  {case}
<div class="feedback">
<h2>{'Search for "%1" returned %2 matches'|i18n("design/standard/content/search",,array($search_text|wash,$search_count))}</h2>
</div>
  {/case}
{/switch}

{include name=Result
         uri='design:content/searchresult.tpl'
         search_result=$search_result}
{section-else}
<div class="block" style="font-size: 110%; ">
<!-- $search_text:'{$search_text}' -->
{section show=$search_button|ne('')}
<h2 style="color: #CC0000; ">Ошибка: не задано ключевое слово!</h2>
{/section}
{* 
<!-- Для того, чтобы <code>что-то</code> найти, надо написать <code>что-то</code> в поле ввода и нажать кнопку  --> 
*}
<p>Введите ключевое слово в форму поиска и нажмите кнопку <span style="padding: 1px 3px; border: 1px solid #7a7a7a; background: #eee; ">"Искать!"</span>. По умолчанию поиск производится по текстам документов. Например, поиск по слову "<code>Иванов</code>" найдет все документы, где в текстах встречается это слово. </p>
<p>Чтобы искать по фамилии автора, выберите "<input type="radio" name="" value="" checked><b>Поиск по авторам</b>". Тогда поиск выдаст документы, фамилия и имя автора которых содержит искомое слово.</p>
<p>Поиск осуществляется по соответствию <span style="border-bottom: 1px dashed blue;" title="последовательность букв и цифр, ограниченная пробелами, знаками препинания и началом/концом строки">целому слову</span>. Так, поиск по слову "<code>Иван</code>" <b>не найдет</b> документы, где есть слово "<code>Иванов</code>". Чтобы искать по подстроке, используйте символ "*". Например, поиск по "<code>Иван*</code>" найдет все документы, где есть "<code>Иван</code>", "<code>Иванов</code>", "<code>Иванова</code>" и т.д.</p>

<!-- <p>Статьи, опубликованные в Русском Журнале до 2004 г., располагаются в <a href="http://old.russ.ru/">архиве</a>.</p> -->

</div>
{/section}

{include name=navigator
         uri='design:navigator/google.tpl'
         page_uri='/content/advancedsearch'
         page_uri_suffix=concat('?SearchText=',$search_text|urlencode,'&PhraseSearchText=',$phrase_search_text|urlencode,'&SearchContentClassID=',$search_contentclass_id,'&SearchContentClassAttributeID=',$search_contentclass_attribute_id,'&SearchSectionID=',$search_section_id,$search_timestamp|gt(0)|choose('',concat('&SearchTimestamp=',$search_timestamp)),$search_sub_tree|gt(0)|choose( '', concat( '&', 'SubTreeArray[]'|urlencode, '=', $search_sub_tree|implode( concat( '&', 'SubTreeArray[]'|urlencode, '=' ) ) ) ),'&SearchDate=',$search_date,'&SearchPageLimit=',$search_page_limit)
         item_count=$search_count
         view_parameters=$view_parameters
         item_limit=$page_limit}

<div class="block">
<hr class=hr>
<p class=big><b>Публикации в Русском Журнале до 2004г. можно найти в Архиве по адресу <a href="http://old.russ.ru/authors">http://old.russ.ru/authors</a></b></p>
</div>

</form>
{/let}

