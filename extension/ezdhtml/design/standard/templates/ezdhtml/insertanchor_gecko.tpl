{if ge($ezpublish_version, 3.9)}
{include uri="design:custom_attributes_gecko.tpl"}
{include uri="design:custom_attr_init.tpl"
         tag_name='anchor'
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
    var windowParameters = opener.anchorParameters( editorID );
    if ( windowParameters == null )
        window.close();
    
    document.getElementById("imgName").focus();
    document.getElementById("imgName").value = windowParameters.imgName;
{/literal}{if ge($ezpublish_version, 3.9)}
    displayAttributes( 'anchor', windowParameters.customAttributes );
{/if}{literal}
}

function insert()
{
    var anchorParameters = new Array();
    anchorParameters["imgName"] = document.getElementById("imgName").value;
    anchorParameters["imgSrc"] = document.getElementById("imgSrc").value;
    anchorParameters["imgType"] = "anchor";

{/literal}{if ge($ezpublish_version, 3.9)}
    var CustomAttributeName = document.getElementsByName("CustomAttributeName");
    if ( CustomAttributeName.length != null )
    {ldelim}
        var CustomAttributeValue = document.getElementsByName("CustomAttributeValue");
        anchorParameters["customAttributes"] = packCustomAttributes( CustomAttributeName, CustomAttributeValue );
    {rdelim}
    else
{/if}{literal}
        anchorParameters["customAttributes"] = "";

    var editorID = document.getElementById("editorID").value;
    opener.addAnchor( editorID, anchorParameters );
    window.close();
}
// -->
</script>
{/literal}

<div class="onlineeditor">

<input type="hidden" id="editorID" value="" />

<h1>{"Insert anchor"|i18n("design/standard/ezdhtml")}</h1>

<div class="block">
<label>{"Name"|i18n("design/standard/ezdhtml")}:</label>
<input id="imgName" class="box" type="text" size="25" />
</div>

{if ge($ezpublish_version, 3.9)}
{include uri="design:custom_attr_output_gecko.tpl"}
{/if}

<div class="block">
<button id="ok" onclick="insert();">{"OK"|i18n("design/standard/ezdhtml")}</button>
<button onclick="window.close();">{"Cancel"|i18n("design/standard/ezdhtml")}</button>
</div>

<input type="hidden" id="imgSrc" value="{$imgSrc}" />

</div>
