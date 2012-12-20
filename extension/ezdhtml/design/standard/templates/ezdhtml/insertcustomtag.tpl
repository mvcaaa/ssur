{include uri="design:custom_attributes.tpl"}
{foreach $customtag_list as $custom_tag}
{include uri="design:custom_attr_init.tpl"
         tag_name=$custom_tag.Name
         tag_attributes=$custom_tag.Attributes
         tag_defaults=$custom_tag.Defaults}
{/foreach}

<script type="text/javascript">
{literal}
function displayCustomTagAttributes( customAttributes )
{
    customTagString = customTagName.value;
    var isInline = customTagString.match(/inline_/g);
    if ( isInline )
        customTagString = customTagString.substring(7);

    displayAttributes( customTagString, customAttributes );
}
{/literal}
</script>

{literal}
<script type="text/javascript" for="window" event="onload">
    <!--
    // When window gets created, set some default values
    customTagText.value = window.dialogArguments["customTagText"];
    var type = window.dialogArguments["customTagType"];
    if ( window.dialogArguments["customTagName"] != "" )
    {
        if ( type == "inline" )
            customTagName.value = "inline_" + window.dialogArguments["customTagName"];
        else
            customTagName.value = window.dialogArguments["customTagName"];
    }
    if ( type == "block" )
    {
        customTagType.checked = false;
        customTagText.disabled = true;
    }
    else if ( type == "inline" )
        customTagType.checked = true;
    else
    {
        changeType();
    }

    customTagType.disabled = true;

    var customAttributes = window.dialogArguments["customAttributes"];
    displayCustomTagAttributes( customAttributes );
// -->
</script>

<script type="text/javascript" for="customTagName" event="onclick">
changeType();
{/literal}{if ge($ezpublish_version, 3.9)}
removeAttributes();
displayCustomTagAttributes(-1);
{/if}{literal}
</script>
  
<script type="text/javascript" for="ok" event="onclick">
<!--
    var arr = new Array();
    arr["customTagName"] = customTagName.value;
    if ( customTagType.checked )
        arr["customTagType"] = "inline";
    else
        arr["customTagType"] = "block";
    if ( customTagType.checked )
        arr["customTagText"] = customTagText.value;
    else
        arr["customTagText"] = "";
    arr["imgSrc"] = imgSrc.value;
    
    if ( typeof CustomAttributeName != 'undefined' && typeof CustomAttributeName != 'unknown' )
    {
        arr["customAttributes"] = packCustomAttributes( CustomAttributeName, CustomAttributeValue );
    }
    window.returnValue = arr;
    window.close();
// -->
</script>

<script type="text/javascript">
function changeType()
{
    if ( customTagName.value != "" )
       ok.disabled = false;
    var customTagString = customTagName.value;
    var isInline = customTagString.match(/inline_/g);
    if ( isInline )
    {
        customTagType.checked = true;
        customTagText.disabled = false;
    }
    else
    {
        customTagType.checked = false;
        customTagText.disabled = true;
    }
}

</script>

<script type="text/javascript" for="CustomAttribute" event="onclick">
    addFirst( "", "" );
</script>
{/literal}

<div class="onlineeditor">

<h1>{"Select from available custom tags"|i18n("design/standard/ezdhtml")}</h1>

<div class="block">
<label>{"Custom tag"|i18n("design/standard/ezdhtml")}:</label>
<select name="customTagName" align="left">
{section name=CustomTagArray loop=$customtag_list}
<option value="{$CustomTagArray:item.Value}">{$CustomTagArray:item.Name}</option>
{/section}
</select>
</div>

<div class="block">
<label>{"Inline"|i18n("design/standard/ezdhtml")}:</label>
<input id="customTagType" name="customTagType" type="checkbox" />
</div>

<div class="block">
<label>{"Text"|i18n("design/standard/ezdhtml")}:</label>
<input id="customTagText" class="box" name="customTagText" type="text" size="20" />
</div>

{include uri="design:custom_attr_output.tpl"}

<div class="block">
<button id="ok" type="submit">{"OK"|i18n("design/standard/ezdhtml")}</button>
<button onclick="window.close();">{"Cancel"|i18n("design/standard/ezdhtml")}</button>
</div>

<input type="hidden" id="imgSrc" value="{$imgSrc}" />

</div>