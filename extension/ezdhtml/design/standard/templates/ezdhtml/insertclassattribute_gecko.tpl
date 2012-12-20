{if ge($ezpublish_version, 3.9)}
{include uri="design:custom_attributes_gecko.tpl"}
{include uri="design:custom_attr_init.tpl"
         tag_name=$tag_name
         tag_attributes=$custom_attributes
         tag_defaults=$custom_defaults}
{/if}
{literal}
<script type="text/javascript">
<!--
function Init()
{
    var editorID = opener.document.getElementById("iframeID").value;
    document.getElementById("editorID").value = editorID;
    var windowParameters = opener.customClassParameters( editorID );
    if ( windowParameters == null )
        window.close();
    var classValue = windowParameters['class'];
    if ( classValue == "" )
    	 classValue = -1;
    document.getElementById("classification").value = classValue;

{/literal}{if ge($ezpublish_version, 3.9)}
    displayAttributes( '{$tag_name}', windowParameters.customAttributes );
{/if}{literal}
}

function insert()
{
    var customClassParameters = new Array();
    customClassParameters["class"] = document.getElementById("classification").value;

{/literal}{if ge($ezpublish_version, 3.9)}{literal}
    var CustomAttributeName = document.getElementsByName("CustomAttributeName");
    if ( CustomAttributeName.length != null )
    {
        var CustomAttributeValue = document.getElementsByName("CustomAttributeValue");
        customClassParameters["customAttributes"] = packCustomAttributes( CustomAttributeName, CustomAttributeValue );
    }
    else
{/literal}{/if}{literal}
        customClassParameters["customAttributes"] = "";

    var editorID = document.getElementById("editorID").value;
    opener.addCustomClass( editorID, customClassParameters );
    window.close();
}
// -->
</script>
{/literal}

<input type="hidden" id="editorID" value="" />

<div class="onlineeditor">

<h1>{"Select from available classes"|i18n("design/standard/ezdhtml")}</h1>

<div class="block">
{section show=$class_list}
{let classDescription=ezini($tag_name, 'ClassDescription', 'content.ini')}
<label>{"Class"|i18n("design/standard/ezdhtml")}:</label>
<select id="classification" align="left">
    <option value="-1">[{"none"|i18n("design/standard/ezdhtml")}]</option>
    {section name=ClassArray loop=$class_list}
    {section show=is_set($classDescription[$ClassArray:item])}
    <option value="{$ClassArray:item}">{$classDescription[$ClassArray:item]}</option>
    {section-else}
    <option value="{$ClassArray:item}">{$ClassArray:item}</option>
    {/section}
    {/section}
</select>
{/let}
{section-else}
    {"No classes are available for the element: "|i18n("design/standard/ezdhtml")}<strong>&lt;{$tag_name}&gt;</strong>
{/section}
</div>

{if ge($ezpublish_version, 3.9)}
{include uri="design:custom_attr_output_gecko.tpl"}
{/if}

<div class="block">
{section show=$class_list}<button id="ok" onclick="insert();">{"OK"|i18n("design/standard/ezdhtml")}</button>{/section}
<button onclick="window.close();">{"Cancel"|i18n("design/standard/ezdhtml")}</button>
</div>

</div>