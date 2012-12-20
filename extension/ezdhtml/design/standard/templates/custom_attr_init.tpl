<script type="text/javascript">

customAttrDefaults["{$tag_name}"] = new Array();

{def $value=""}
  {foreach $tag_attributes as $attr}
  {if is_set( $tag_defaults[$attr] )}
  {set $value=$tag_defaults[$attr]}
  {else}
  {set $value=""}
  {/if}
  customAttrDefaults["{$tag_name}"]["{$attr}"] = "{$value}";
  {/foreach}
{undef $value}

</script>
