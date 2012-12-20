{*?template charset="koi8-r"?*}
{* Topics list Attribute in Article *}
{* 
defaults:
$show_all = false
$link = true
*}
{default 
	show_all=false()
	link=true()
}
{if and($attribute.has_content, is_set($attribute.content.relation_list)  )}
{* $attribute.content.relation_list| attribute( show, 2) *}
{def $list_count=$attribute.content.relation_list|count }
{if $list_count}
	<span class="attribute-topics-prefix">{if $list_count|eq(1)}Тема{else}Темы{/if}: </span>
{/if}
	<span class="attribute-topics-list">
		{foreach $attribute.content.relation_list as $topic_ref}{def $topic = fetch( 'content', 'node', hash( 'node_id', $topic_ref.node_id))}{if $link}<a href={$topic.url_alias|ezurl}>{/if}{$topic.name|wash()}{if $link}</a>{/if}{delimiter}, {/delimiter}{/foreach}
	</span>
{/if}