{* EzXMLText with href attribute *}
{*
Input:
 ending	       - Option string will be put at end of the content.
 href          - Optional string, if set it will create a <a> tag
                 around the content with href as the link.
*}
{default href=false() ending=false()}{section show=$href}<a href={$href}>{/section}{$attribute.content.output.output_text}{section show=and($ending, $attribute.content.output.output_text)}{$ending}{/section}{section show=$href}</a>{/section}{/default}
