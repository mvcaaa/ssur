{* SeeAlso Attribute in Article *}
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
	<ul class="attribute-see_also-list">
		{foreach $attribute.content.relation_list as $topic_ref}{def $topic = fetch( 'content', 'node', hash( 'node_id', $topic_ref.node_id))}
		<li>{if $link}<a href={$topic.url_alias|ezurl}>{/if}{$topic.name|wash()}{if $link}</a>{/if}</li>
		{/foreach}
	</ul>
{/if}