{* EzXMLText with href attribute and adwords option ('sape' extention) *}
{*
Input:
 ending	       - Option string will be put at end of the content.
 href          - Optional string, if set it will create a <a> tag
                 around the content with href as the link.
 adwords       - if true, invict {$string|sape_context('$number')} on bodytext
*}

{default href=false() ending=false() adwords=false()}{if $adwords}{$attribute.content.output.output_text|sape_context()}{else}{section show=$href}<a href={$href}>{/section}{$attribute.content.output.output_text}{section show=and($ending, $attribute.content.output.output_text)}{$ending}{/section}{section show=$href}</a>{/section}{/if}{/default}
