{if ge($ezpublish_version, 3.9)}
{include uri="design:custom_attributes.tpl"}
{include uri="design:custom_attr_init.tpl"
         tag_name='anchor'
         tag_attributes=$custom_attributes
         tag_defaults=$custom_defaults}
{/if}

{literal}
<script type="text/javascript" for="window" event="onload">
<!--
    // When window gets created, set some default values
    imgName.value = window.dialogArguments["imgName"];

{/literal}{if ge($ezpublish_version, 3.9)}
    displayAttributes( 'anchor', window.dialogArguments["customAttributes"] );
{/if}{literal}
// -->
</script>

<script type="text/javascript" for="ok" event="onclick">
<!--
	var arr = new Array();
	arr["imgName"] = imgName.value;
    arr["imgSrc"] = imgSrc.value;
    arr["imgType"] = "anchor";
	
{/literal}{if ge($ezpublish_version, 3.9)}
    if ( typeof CustomAttributeName != 'undefined' && typeof CustomAttributeName != 'unknown' )
        arr["customAttributes"] = packCustomAttributes( CustomAttributeName, CustomAttributeValue );
    else
{/if}{literal}
        arr["customAttributes"] = '';
	window.returnValue = arr;
	window.close();
// -->
</script>
{/literal}

<div class="onlineeditor">

<h1>{"Insert anchor"|i18n("design/standard/ezdhtml")}</h1>

<div class="block">
<label>{"Name"|i18n("design/standard/ezdhtml")}:</label>
<input id="imgName" class="box" name="imgName" type="text" size="25" />
</div>

{if ge($ezpublish_version, 3.9)}
{include uri="design:custom_attr_output.tpl"}
{/if}

<div class="block">
<button id="ok" type="submit">{"OK"|i18n("design/standard/ezdhtml")}</button>
<button onclick="window.close();">{"Cancel"|i18n("design/standard/ezdhtml")}</button>
</div>

<input type="hidden" name="imgSrc" value="{$imgSrc}" />

</div>
