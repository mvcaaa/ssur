{if ge($ezpublish_version, 3.9)}
{include uri="design:custom_attributes_gecko.tpl"}
{include uri="design:custom_attr_init.tpl"
         tag_name='literal'
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
    var windowParameters = opener.literalParameters( editorID );
    if ( windowParameters == null )
        window.close();
    var classValue = windowParameters['class'];
    if ( classValue == "" )
    	 classValue = -1;
    document.getElementById("classification").value = classValue;
{/literal}{if ge($ezpublish_version, 3.9)}
    displayAttributes( 'literal', windowParameters.customAttributes );
{/if}{literal}
}

function insert()
{
    var literalParameters = new Array();
    literalParameters["class"] = document.getElementById("classification").value;
    var editorID = document.getElementById("editorID").value;

{/literal}{if ge($ezpublish_version, 3.9)}{literal}
    var CustomAttributeName = document.getElementsByName("CustomAttributeName");
    if ( CustomAttributeName.length != null )
    {
        var CustomAttributeValue = document.getElementsByName("CustomAttributeValue");
        literalParameters["customAttributes"] = packCustomAttributes( CustomAttributeName, CustomAttributeValue );
    }
    else
{/literal}{/if}{literal}
        literalParameters["customAttributes"] = "";
    opener.addLiteral( editorID, literalParameters );
    window.close();
}
// -->
</script>
{/literal}

<input type="hidden" id="editorID" value="" />

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
{include uri="design:custom_attr_output_gecko.tpl"}
{/if}

<div class="block">
<button id="ok" onclick="insert();">{"OK"|i18n("design/standard/ezdhtml")}</button>
<button onclick="window.close();">{"Cancel"|i18n("design/standard/ezdhtml")}</button>
</div>

</div>