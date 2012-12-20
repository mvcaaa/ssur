{if ge($ezpublish_version, 3.9)}
{include uri="design:custom_attributes.tpl"}
{include uri="design:custom_attr_init.tpl"
         tag_name='table'
         tag_attributes=$custom_attributes
         tag_defaults=$custom_defaults}
{/if}

<script type="text/javascript" for="window" event="onload">
<!--
    {if $is_new}
    // default values
    {foreach $defaults as $param=>$value}
    document.getElementById( 'table' + '{$param|upfirst()}' ).value = '{$value}';
    {/foreach}
    enableRowEdit = true;
    {else}
    // stored values
    tableRows.value   = window.dialogArguments["tableRows"];
    tableCols.value   = window.dialogArguments["tableCols"];
    tableBorder.value = window.dialogArguments["tableBorder"];
    tableWidth.value  = window.dialogArguments["tableWidth"];
    tableClass.value  = window.dialogArguments["tableClass"];
    enableRowEdit = false;
    {/if}

    if ( enableRowEdit == false )
        tableRows.disabled = true;
    if ( enableRowEdit == false )
        tableCols.disabled = true;
{if ge($ezpublish_version, 3.9)}
    displayAttributes( 'table', window.dialogArguments["customAttributes"] );
{/if}
// -->
</script>

<script type="text/javascript" for="ok" event="onclick">
<!--
  var arr = new Array();
  arr["tableRows"]   = tableRows.value;
  arr["tableCols"]   = tableCols.value;
  arr["tableBorder"] = tableBorder.value;
  arr["tableWidth"]  = tableWidth.value;
  arr["tableClass"]  = tableClass.value;

{if ge($ezpublish_version, 3.9)}
  if ( typeof CustomAttributeName != 'undefined' && typeof CustomAttributeName != 'unknown' )
      arr["customAttributes"] = packCustomAttributes( CustomAttributeName, CustomAttributeValue );
  else
{/if}
      arr["customAttributes"] = '';

  window.returnValue = arr;
  window.close();
// -->
</script>

<div class="onlineeditor">

<h1>
{section show=$is_new}
{"Insert table"|i18n("design/standard/ezdhtml")}
{section-else}
{"Table Properties"|i18n("design/standard/ezdhtml")}
{/section}
</h1>

<div class="block">
<div class="element">
<label>{"Rows"|i18n("design/standard/ezdhtml")}:</label>
<input id="tableRows" type="text" size="4" name="tableRows" />
</div>
<div class="element">
<label>{"Columns"|i18n("design/standard/ezdhtml")}:</label>
<input id="tableCols" type="text" size="4" name="tableCols" />
</div>
<div class="break"></div>
</div>

<div class="block">
<div class="element">
<label>{"Size"|i18n("design/standard/ezdhtml")}:</label>
<input  id="tableWidth" type="text" size="4" name="tableWidth" />
</div>
<div class="element">
<label>{"Border"|i18n("design/standard/ezdhtml")}:</label>
<input id="tableBorder" type="text" size="4" name="tableBorder" />
</div>
<div class="break"></div>
</div>

<div class="block">
<label>{"Class"|i18n("design/standard/ezdhtml")}:</label>
	    <select name="tableClass" align="left">
	        <option value="-1">[{"none"|i18n("design/standard/ezdhtml")}]</option>
        {let classDescription=ezini('table', 'ClassDescription', 'content.ini')}
        {section name=ClassArray loop=$class_list}
        <option value="{$ClassArray:item}">
        {section show=is_set($classDescription[$ClassArray:item])}
        {$classDescription[$ClassArray:item]}
        {section-else}
        {$ClassArray:item}
        {/section}
        </option>
        {/section}
        {/let}
	    </select>
</div>

{if ge($ezpublish_version, 3.9)}
<div class="block">
{include uri="design:custom_attr_output.tpl"}
</div>
{/if}

<div class="block">
	<button class="button" id="ok" type="submit">{"OK"|i18n("design/standard/ezdhtml")}</button>
	<button class="button" onclick="window.close();">{"Cancel"|i18n("design/standard/ezdhtml")}</button>
</div>

</div>

