{if ge($ezpublish_version, 3.9)}
{include uri="design:custom_attributes.tpl"}
{include uri="design:custom_attr_init.tpl"
         tag_name='literal'
         tag_attributes=$custom_attributes
         tag_defaults=$custom_defaults}
{/if}

<script type="text/javascript" for="window" event="onload">
<!--
    // When window gets created, set some default values
    classification.value = window.dialogArguments["class"];
    if ( window.dialogArguments["class"] == "" )
        classification.value = -1;
{if ge($ezpublish_version, 3.9)}
    displayAttributes( 'literal', window.dialogArguments["customAttributes"] );
{/if}
// -->
</script>

<script type="text/javascript" for="ok" event="onclick">
<!--
  var arr = new Array();
  arr["class"] = classification.value;

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

<h1>{"Select from available classes"|i18n("design/standard/ezdhtml")}</h1>

<div class="block">
<label>{"Class"|i18n("design/standard/ezdhtml")}:</label>
<select id="classification">
    <option value="-1">[{"none"|i18n("design/standard/ezdhtml")}]</option>
    {let classDescription=ezini('literal', 'ClassDescription', 'content.ini')}
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
{include uri="design:custom_attr_output.tpl"}
{/if}

<div class="block">
<button class="button" id="ok" type="submit">{"OK"|i18n("design/standard/ezdhtml")}</button>
<button class="button" onclick="window.close();">{"Cancel"|i18n("design/standard/ezdhtml")}</button>
</div>

</div>