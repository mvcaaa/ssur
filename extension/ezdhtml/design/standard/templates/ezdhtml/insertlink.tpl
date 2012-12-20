{if ge($ezpublish_version, 3.9)}
{include uri="design:custom_attributes.tpl"}
{include uri="design:custom_attr_init.tpl"
         tag_name='link'
         tag_attributes=$custom_attributes
         tag_defaults=$custom_defaults}
{/if}

<script type="text/javascript" for="window" event="onload">
    <!--
    if ( browseActionName.value == "browseNode" )
    {ldelim}
        browseNodeField.style.display = "inline";
{if ge($ezpublish_version, 3.9)}
        displayAttributes( 'link', -1 );
{/if}
    {rdelim}
    else if ( browseActionName.value == "browseObject" )
    {ldelim}
        browseObjectField.style.display = "inline";
{if ge($ezpublish_version, 3.9)}
        displayAttributes( 'link', -1 );
{/if}
    {rdelim}
    else
    {ldelim}
        // When window gets created, set some default values
        var linkType = window.dialogArguments["linkType"];
        document.getElementById("linkUrl").value = window.dialogArguments["linkUrl"];
        document.getElementById("linkText").value = window.dialogArguments["linkText"];
        document.getElementById("linkType").value = linkType;
        document.getElementById("linkClass").value = window.dialogArguments["linkClass"];
        document.getElementById("linkView").value = window.dialogArguments["linkView"];

        {section show=ge($ezpublish_version, 3.6)}
        document.getElementById("linkTitle").value = window.dialogArguments["linkTitle"];
        document.getElementById("linkID").value = window.dialogArguments["linkID"];
        {/section}

        if ( window.dialogArguments["linkWindow"] == "_blank" )
            document.getElementById("linkWindow").checked = true;
        if ( window.dialogArguments["linkText"] == "ez_image" )
        {ldelim}
            document.getElementById("linkText").disabled = true;
        {rdelim}

        {section show=ge($ezpublish_version, 3.6)}
        if ( linkType == "ezobject://" )
        {ldelim}
            linkViewBlock.style.display = "inline";
            browseObjectField.style.display = "inline";
            browseNodeField.style.display = "none";
        {rdelim}
        else if ( linkType == "eznode://" )
        {ldelim}
            linkViewBlock.style.display = "inline";
            browseNodeField.style.display = "inline";
            browseObjectField.style.display = "none";
        {rdelim}
        else
        {ldelim}
            linkViewBlock.style.display = "none";
            browseNodeField.style.display = "none";
            browseObjectField.style.display = "none";
        {rdelim}
{if ge($ezpublish_version, 3.9)}
        displayAttributes( 'link', window.dialogArguments["customAttributes"] );
{/if}
    {rdelim}
        {/section}
// -->
</script>

<script type="text/javascript" for="ok" event="onclick">
    <!--
	var arr = new Array();
	arr["linkText"] = document.getElementById("linkText").value;
	arr["linkUrl"] = document.getElementById("linkUrl").value;
	arr["linkClass"] = document.getElementById("linkClass").value;
    arr["linkView"] = document.getElementById("linkView").value;

    arr["linkTitle"] = document.getElementById("linkTitle").value;
    arr["linkID"] = document.getElementById("linkID").value;

{if ge($ezpublish_version, 3.9)}
    if ( typeof CustomAttributeName != 'undefined' && typeof CustomAttributeName != 'unknown' )
        arr["customAttributes"] = packCustomAttributes( CustomAttributeName, CustomAttributeValue );
    else
{/if}
        arr["customAttributes"] = '';

    var linkWindow = document.getElementById("linkWindow");
	if ( linkWindow.checked )
	    arr["linkWindow"] = "_blank";
	else
	    arr["linkWindow"] = "_self";
    if ( arr["linkText"] == "" )
    {ldelim}
        alert( "Link text can not be empty." );
    {rdelim}
    else
    {ldelim}
	    window.returnValue = arr;
	    window.close();
    {rdelim}
// -->
</script>

<script type="text/javascript">
    <!--
    function preBrowse()
    {ldelim}
    document.getElementById("linkText").disabled = false;
    document.getElementById("linkClass").disabled = false;
    document.getElementById("linkView").disabled = false;
    {rdelim}
// -->
</script>

<script type="text/javascript" for="linkType" event="onchange">
    <!--
    linkUrl.value =  linkType.value;

    {section show=ge($ezpublish_version, 3.6)}
    if ( linkType.value == "ezobject://" )
    {ldelim}
        linkViewBlock.style.display = "inline";
        browseObjectField.style.display = "inline";
        browseNodeField.style.display = "none";
    {rdelim}
    else if ( linkType.value == "eznode://" )
    {ldelim}
        linkViewBlock.style.display = "inline";
        browseNodeField.style.display = "inline";
        browseObjectField.style.display = "none";
    {rdelim}
    else
    {ldelim}
        linkViewBlock.style.display = "none";
        browseNodeField.style.display = "none";
        browseObjectField.style.display = "none";
    {rdelim}
    {/section}
// -->
</script>

<input type="hidden" id="browseActionName" value="{$browse_action_name}" />

<form method="post" action="insertlink">
<div class="onlineeditor">

<input id="isNew" name="isNew" type="hidden" value="{$is_new}"/>

<h1>
{section show=$is_new}
{"Insert link"|i18n("design/standard/ezdhtml")}
{section-else}
{"Link Properties"|i18n("design/standard/ezdhtml")}
{/section}
</h1>

<form method="post" action="insertlink">
<div class="block" id="linkTextBlock">
<label>{"Text"|i18n("design/standard/ezdhtml")}:</label>
<input id="linkText" class="box" name="linkText" type="text" size="50" value="{$link_text}" />
</div>

<div class="block">
<label>{"Type"|i18n("design/standard/ezdhtml")}:</label>
<select name ="linkType">
    <option value="" {section show=$link_type|eq("")}selected{/section}>({"other"|i18n("design/standard/ezdhtml")})</option>
    <option value="http://">http:</option>
    {section show=ge($ezpublish_version, 3.6)}
    <option value="ezobject://" {section show=$link_type|eq("ezobject://")}selected{/section}>ezobject:</option>
    <option value="eznode://" {section show=$link_type|eq("eznode://")}selected{/section}>eznode:</option>
    {/section}
    <option value="mailto:">mailto:</option>
    <option value="file://">file:</option>
    <option value="ftp://">ftp:</option>
    <option value="https://">https:</option>
</select>
    <div id="browseNodeField" style="display:none">
        <input type="submit" name="BrowseButton[node]" onclick="window.preBrowse()" value="{'Browse'|i18n('design/standard/ezdhtml')}" />
    </div>
    <div id="browseObjectField" style="display:none">
        <input type="submit" name="BrowseButton[object]" onclick="window.preBrowse()" value="{'Browse'|i18n('design/standard/ezdhtml')}" />
    </div>
</div>

<div class="block">
<label>{"URL"|i18n("design/standard/ezdhtml")}:</label>
<input id="linkUrl" class="box" name="linkUrl" type="text" size="50" value="{$link_url}" />
</div>

<div class="block" id="linkViewBlock" style="display:none">
<label>{"View"|i18n("design/standard/ezdhtml")}:</label>
<select id ="linkView" name="linkView">
<option value="-1">[{"default"|i18n("design/standard/ezdhtml")}]</option>
{foreach $view_list as $view}
<option value="{$view}" {if eq($view, $link_view)}selected{/if}>{$view}</option>
{/foreach}
</select>
</div>

<div class="block" id="linkClassBlock">
<label>{"Class"|i18n("design/standard/ezdhtml")}:</label>
<select name ="linkClass">
<option value="-1">[{"none"|i18n("design/standard/ezdhtml")}]</option>
{let classDescription=ezini('link', 'ClassDescription', 'content.ini')}
{section name=ClassArray loop=$class_list}
<option value="{$ClassArray:item}" {section show=eq($ClassArray:item,$link_class)}selected{/section}>
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

<div class="block">
<label>{"Open in new window"|i18n("design/standard/ezdhtml")}:</label>
<input class="checkbox" id="linkWindow" name="linkWindow" type="checkbox" {section show=$link_window|eq(true())}checked{/section}/>
</div>

{section show=ge($ezpublish_version, 3.6)}
<div class="block">
<label>{"Title ( optional )"|i18n("design/standard/ezdhtml")}:</label>
<input id="linkTitle" class="box" name="linkTitle" type="text" size="50" value="{$link_title}" />
</div>

<div class="block">
<label>{"ID ( optional )"|i18n("design/standard/ezdhtml")}:</label>
<input id="linkID" class="box" name="linkID" type="text" size="50" value="{$link_id}" />
</div>
{/section}
</form>

{if ge($ezpublish_version, 3.9)}
{include uri="design:custom_attr_output.tpl"}
{/if}

<div class="block">
<button id="ok" type="submit">{"OK"|i18n("design/standard/ezdhtml")}</button>
<button onclick="window.close();">{"Cancel"|i18n("design/standard/ezdhtml")}</button>
</div>

</div>
</form>
