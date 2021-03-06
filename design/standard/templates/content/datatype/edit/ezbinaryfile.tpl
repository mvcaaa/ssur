{* DO NOT EDIT THIS FILE! Use an override template instead. *}
{default attribute_base=ContentObjectAttribute}

{* Current file. *}
<div class="block">
<label>{'Current file'|i18n( 'design/standard/content/datatype' )}:</label>
{section show=$attribute.content}
<table class="list" cellspacing="0">
<tr>
<th>{'Filename'|i18n( 'design/standard/content/datatype' )}</th>
<th>{'MIME type'|i18n( 'design/standard/content/datatype' )}</th>
<th>{'Size'|i18n( 'design/standard/content/datatype' )}</th>
</tr>
<tr>
<td>{$attribute.content.original_filename|wash( xhtml )}</td>
<td>{$attribute.content.mime_type|wash( xhtml )}</td>
<td>{$attribute.content.filesize|si( byte )}</td>
</tr>
</table>
{section-else}
<p>{'There is no file.'|i18n( 'design/standard/content/datatype' )}</p>
{/section}

{section show=$attribute.content}
<input class="button" type="submit" name="CustomActionButton[{$attribute.id}_delete_binary]" value="{'Remove'|i18n( 'design/standard/content/datatype' )}" title="{'Remove the file from this draft.'|i18n( 'design/standard/content/datatype' )}" />
{section-else}
<input class="button-disabled" type="submit" name="CustomActionButton[{$attribute.id}_delete_binary]" value="{'Remove'|i18n( 'design/standard/content/datatype' )}" disabled="disabled" />
{/section}
</div>

{* New file. *}
<div class="block">
<label>{'New file for upload'|i18n( 'design/standard/content/datatype' )}:</label>
<input type="hidden" name="MAX_FILE_SIZE" value="{$attribute.contentclass_attribute.data_int1}000000"/>
<input id="ezcoa-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}" class="box ezcc-{$attribute.object.content_class.identifier} ezcca-{$attribute.object.content_class.identifier}_{$attribute.contentclass_attribute_identifier}" name="{$attribute_base}_data_binaryfilename_{$attribute.id}" type="file" />
</div>

{/default}
