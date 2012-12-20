{default attribute_base=ContentObjectAttribute}

{* Current file. *}
<div class="block">
<label>{'Current file and its flv version'|i18n( 'ezvideoflv/datatype' )}:</label>
{section show=$attribute.content.filename}
<table class="list" cellspacing="0">
<tr>
	<th>{'Preview'|i18n( 'ezvideoflv/datatype' )}</th>
    <th>{'Filename'|i18n( 'design/standard/content/datatype' )}</th>
    <th>{'MIME type'|i18n( 'design/standard/content/datatype' )}</th>
    <th>{'Size'|i18n( 'design/standard/content/datatype' )}</th>
</tr>
<tr>
	<td rowspan="2" style="width: 120px; text-align: center;">
	<img src={concat( 'video/preview/', $attribute.contentobject_id,"/",$attribute.content.contentobject_attribute_id )|ezurl()} alt="Preview" width="100" />
	</td>
    <td>{$attribute.content.original_filename}</td>
    <td>{$attribute.content.mime_type}</td>
    <td>
		{$attribute.content.filesize|si( byte )}<br />
		{$attribute.content.width}x{$attribute.content.height}
	</td>
</tr>
<tr>
	<td>{'FLV version'|i18n( 'ezvideoflv/datatype' )}</td>
	<td>video/x-flv</td>
	{if $attribute.content.has_flv}
	<td>{$attribute.content.filesize_flv|si( byte )}</td>
	{else}
	<td>{'Not yet generated'|i18n( 'ezvideoflv/datatype' )}</td>
	{/if}
</tr>
</table>
{section-else}
<p>{'There is no file.'|i18n( 'design/standard/content/datatype' )}</p>
{/section}
</div>

{* Remove button. *}
{section show=$attribute.content.filename}
    <input class="button" type="submit" name="CustomActionButton[{$attribute.id}_delete_videoflv]" value="{'Remove'|i18n('design/standard/content/datatype')}" title="{'Remove the file from this draft.'|i18n( 'design/standard/content/datatype' )}" />
{section-else}
    <input class="button-disabled" type="submit" name="CustomActionButton[{$attribute.id}_delete_videoflv]" value="{'Remove'|i18n('design/standard/content/datatype')}" disabled="disabled" />
{/section}


<div class="block">
    <input type="hidden" name="MAX_FILE_SIZE" value="{$attribute.contentclass_attribute.data_int1|mul( 1024, 1024 )}" />
    <label>{'New video file'|i18n( 'ezvideoflv/datatype' )}:</label>
    <input class="box" name="{$attribute_base}_data_videoflvfilename_{$attribute.id}" type="file" />
</div>


{/default}
