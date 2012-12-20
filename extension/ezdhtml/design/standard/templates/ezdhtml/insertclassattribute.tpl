{if ge($ezpublish_version, 3.9)}
{include uri="design:custom_attributes.tpl"}
{include uri="design:custom_attr_init.tpl"
         tag_name=$tag_name
         tag_attributes=$custom_attributes
         tag_defaults=$custom_defaults}
{/if}

<script type="text/javascript" for="window" event="onload">
<!--
    // When window gets created, set some default values
    {section show=$class_list}
    classification.value = window.dialogArguments["class"];
    if ( window.dialogArguments["class"] == "" )
	   classification.value = -1;
	{/section}

{if ge($ezpublish_version, 3.9)}
    displayAttributes( '{$tag_name}', window.dialogArguments["customAttributes"] );
{/if}
// -->
</script>

<script type="text/javascript" for="ok" event="onclick">
<!--
  var arr = new Array();
  {section show=$class_list}
  arr["class"] = classification.value;
  {section-else}
  arr["class"] = -1;
  {/section}

{if ge($ezpublish_version, 3.9)}
  if ( typeof CustomAttributeName != 'undefined' && typeof CustomAttributeName != 'unknown' )
      arr["customAttributes"] = packCustomAttributes( CustomAttributeName, CustomAttributeValue );
  else
{/if}
      arr["customAttributes"] = "";

  window.returnValue = arr;
  window.close();
// -->
</script>
<div class="onlineeditor">

<h1>{"Select from available classes"|i18n("design/standard/ezdhtml")}</h1>

{section show=$class_list}
{let classDescription=ezini($tag_name, 'ClassDescription', 'content.ini')}
<div class="block">
<label>{"Class"|i18n("design/standard/ezdhtml")}:</label>
<select name="classification" align="left">
    <option value="-1">[{"none"|i18n("design/standard/ezdhtml")}]</option>
    {section name=ClassArray loop=$class_list}
    {section show=is_set($classDescription[$ClassArray:item])}
    <option value="{$ClassArray:item}">{$classDescription[$ClassArray:item]}</option>
    {section-else}
    <option value="{$ClassArray:item}">{$ClassArray:item}</option>
    {/section}
    {/section}
</select>
</div>
{/let}
{section-else}
    {"No classes are available for the element: "|i18n("design/standard/ezdhtml")}<strong>&lt;{$tag_name}&gt;</strong>
{/section}

{if ge($ezpublish_version, 3.9)}
<div class="block">
{include uri="design:custom_attr_output.tpl"}
</div>
{/if}

<div class="block">
{section show=$class_list}<button id="ok" type="submit">{"OK"|i18n("design/standard/ezdhtml")}</button>{/section}
<button onclick="window.close();">{"Cancel"|i18n("design/standard/ezdhtml")}</button>
</div>

</div>
