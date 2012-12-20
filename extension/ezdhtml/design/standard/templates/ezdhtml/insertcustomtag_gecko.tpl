{include uri="design:custom_attributes_gecko.tpl"}
{foreach $customtag_list as $custom_tag}
{include uri="design:custom_attr_init.tpl"
         tag_name=$custom_tag.Name
         tag_attributes=$custom_tag.Attributes
         tag_defaults=$custom_tag.Defaults}
{/foreach}

<script type="text/javascript">
{literal}
function Init()
{
    var editorID = opener.document.getElementById("iframeID").value;
    document.getElementById("editorID").value = editorID;
    var windowParameters = opener.customTagParameters( editorID, {/literal}{$is_new}{literal} );
    if ( windowParameters == null )
        window.close();

    document.getElementById("customTagText").value = windowParameters.customTagText;
    var type = windowParameters.customTagType;
    if ( type == "block" )
    {
        document.getElementById("customTagType").checked = false;
        document.getElementById("customTagText").disabled = true;
        document.getElementById("customTagName").value = windowParameters.customTagName;
    }
    else if ( type == "inline" )
    {
        document.getElementById("customTagName").value = "inline_" + windowParameters.customTagName;
        document.getElementById("customTagType").checked = true;
    }
    else
    {
        changeType();
    }

    document.getElementById("customTagType").disabled = true;

    displayCustomTagAttributes( windowParameters.customAttributes );
}

function displayCustomTagAttributes( customAttributes )
{
    customTagString = document.getElementById("customTagName").value;
    var isInline = customTagString.match(/inline_/g);
    if ( isInline )
        customTagString = customTagString.substring(7);

    displayAttributes( customTagString, customAttributes );
}

function insert()
{
    var editorID = document.getElementById("editorID").value;
    var customTagParameters = new Array();
    customTagParameters["customTagName"] = document.getElementById("customTagName").value;
    if ( document.getElementById("customTagType").checked == true )
    {
        customTagParameters["customTagType"] = "inline";
        customTagParameters["customTagText"] = document.getElementById("customTagText").value;
    }
    else
    {
        customTagParameters["customTagType"] = "block";
        customTagParameters["customTagText"] = "";
    }
    customTagParameters["imgSrc"] = document.getElementById("imgSrc").value;
    var CustomAttributeName = document.getElementsByName("CustomAttributeName");
    if ( CustomAttributeName.length != null )
    {
        var CustomAttributeValue = document.getElementsByName("CustomAttributeValue");
        customTagParameters["customAttributes"] = packCustomAttributes( CustomAttributeName, CustomAttributeValue );
    }
    opener.addCustomTag( editorID, customTagParameters, {/literal}{$is_new}{literal} );
    window.close();
}

function changeType()
{
    var customTagName = document.getElementById("customTagName");
    if ( customTagName.value != "" )
       document.getElementById("ok").disabled = false;
    var customTagString = customTagName.value;
    var customTagText = document.getElementById("customTagText");
    var customTagType = document.getElementById("customTagType");
    var isInline = customTagString.match(/inline_/g);
    if ( isInline )
    {
        customTagText.disabled = false;
        customTagType.checked = true;
    }
    else
    {
        customTagText.disabled = true;
        customTagType.checked = false;
    }
}
// -->
</script>

{/literal}

<div class="onlineeditor">

<input type="hidden" id="editorID" value="" />

<h1>{"Select from available custom tags"|i18n("design/standard/ezdhtml")}</h1>

<div class="block">
<label>{"Custom tag"|i18n("design/standard/ezdhtml")}:</label>
<select id="customTagName" align="left" onclick="changeType();{if ge($ezpublish_version, 3.9)}removeAttributes();displayCustomTagAttributes(-1){/if}">
{section name=CustomTagArray loop=$customtag_list}
<option value="{$CustomTagArray:item.Value}">{$CustomTagArray:item.Name}</option>
{/section}
</select>
</div>

<div class="block">
<label>{"Inline"|i18n("design/standard/ezdhtml")}:</label>
<input id="customTagType" name="customTagType" type="checkbox" disabled='true'/>
</div>

<div class="block">
<label>{"Text"|i18n("design/standard/ezdhtml")}:</label>
<input id="customTagText" class="box" name="customTagText" type="text" size="20" />
</div>

{include uri="design:custom_attr_output_gecko.tpl"}

<div class="block">
<button id="ok" onclick="insert();">{"OK"|i18n("design/standard/ezdhtml")}</button>
<button onclick="window.close();">{"Cancel"|i18n("design/standard/ezdhtml")}</button>
</div>

<input type="hidden" id="imgSrc" value="{$imgSrc}" />

</div>