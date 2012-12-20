{if ge($ezpublish_version, 3.9)}
{include uri="design:custom_attributes_gecko.tpl"}
{include uri="design:custom_attr_init.tpl"
         tag_name='table'
         tag_attributes=$custom_attributes
         tag_defaults=$custom_defaults}
{/if}

{literal}
<script type="text/javascript">
<!--
function Init()
{
    {/literal}
    var editorID = opener.document.getElementById("iframeID").value;
    document.getElementById("editorID").value = editorID;
    var windowParameters = opener.tableParameters( editorID, {$is_new} );

    {if $is_new}
    // default values
    {foreach $defaults as $param=>$value}
    document.getElementById( 'table' + '{$param|upfirst()}' ).value = '{$value}';
    {/foreach}
    enableRowEdit = true;
    {else}
    // stored values
    var classValue = windowParameters.tableClass;
    if ( classValue == "" )
    	 classValue = -1;
    document.getElementById("tableWidth").value = windowParameters.tableWidth;
    document.getElementById("tableClass").value = classValue;
    document.getElementById("tableRows").value = windowParameters.tableRows;
    document.getElementById("tableCols").value = windowParameters.tableCols;
    document.getElementById("tableBorder").value = windowParameters.tableBorder;
    document.getElementById("tableWidth").value = windowParameters.tableWidth;
    enableRowEdit = false;
    {/if}

    {literal}
    if ( enableRowEdit == false )
    {
        document.getElementById("tableRows").disabled = true;
        document.getElementById("tableCols").disabled = true;
    }
{/literal}{if ge($ezpublish_version, 3.9)}
    displayAttributes( 'table', windowParameters.customAttributes );
{/if}{literal}
    
    document.getElementById("tableRows").focus();
}

function insert()
{
    var tableParameters = new Array();
    tableParameters["tableClass"] = document.getElementById("tableClass").value;
    tableParameters["tableRows"] = document.getElementById("tableRows").value;
    tableParameters["tableCols"] = document.getElementById("tableCols").value;
    tableParameters["tableBorder"] = document.getElementById("tableBorder").value;
    tableParameters["tableWidth"] = document.getElementById("tableWidth").value;

{/literal}{if ge($ezpublish_version, 3.9)}{literal}
    var CustomAttributeName = document.getElementsByName("CustomAttributeName");
    if ( CustomAttributeName.length != null )
    {
        var CustomAttributeValue = document.getElementsByName("CustomAttributeValue");
        tableParameters["customAttributes"] = packCustomAttributes( CustomAttributeName, CustomAttributeValue );
    }
    else
{/literal}{/if}{literal}
        tableParameters["customAttributes"] = "";

    var editorID = document.getElementById("editorID").value;
    opener.addTable( editorID, tableParameters, {/literal}{$is_new}{literal} );
    window.close();
}
// -->
</script>
{/literal}

<input type="hidden" id="editorID" value="" />

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
	    <select id="tableClass" align="left">
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
{include uri="design:custom_attr_output_gecko.tpl"}
{/if}

<div class="block">
<button id="ok" onclick="insert();">{"OK"|i18n("design/standard/ezdhtml")}</button>
<button onclick="window.close();">{"Cancel"|i18n("design/standard/ezdhtml")}</button>
</div>

</div>