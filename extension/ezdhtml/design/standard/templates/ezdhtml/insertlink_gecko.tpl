{if ge($ezpublish_version, 3.9)}
{include uri="design:custom_attributes_gecko.tpl"}
{include uri="design:custom_attr_init.tpl"
         tag_name='link'
         tag_attributes=$custom_attributes
         tag_defaults=$custom_defaults}
{/if}

<script type="text/javascript">
<!--
function Init()
{ldelim}
    var editorID = opener.document.getElementById("iframeID").value;

    var browseNodeField = document.getElementById("browseNodeField");
    var browseObjectField = document.getElementById("browseObjectField");
    var linkViewBlock = document.getElementById("linkViewBlock");
    
    document.getElementById("editorID").value = editorID;

    if ( document.getElementById("browseActionName").value == "browseNode" )
    {ldelim}
        browseNodeField.style.display = "inline";
{if ge($ezpublish_version, 3.9)}
        displayAttributes( 'link', -1 );
{/if}
    {rdelim}
    else if ( document.getElementById("browseActionName").value == "browseObject" )
    {ldelim}
        browseObjectField.style.display = "inline";
{if ge($ezpublish_version, 3.9)}
        displayAttributes( 'link', -1 );
{/if}
    {rdelim}
    else
    {ldelim}
    
    var windowParameters = opener.linkParameters( editorID );

    var linkType = windowParameters.linkType;
    document.getElementById("linkUrl").value = windowParameters.linkUrl;
    document.getElementById("linkText").value = windowParameters.linkText;
    document.getElementById("linkType").value = linkType;
    document.getElementById("linkClass").value = windowParameters.linkClass;
    document.getElementById("linkView").value = windowParameters.linkView;

    {section show=ge($ezpublish_version, 3.6)}
    document.getElementById("linkTitle").value = windowParameters.linkTitle;
    document.getElementById("linkID").value = windowParameters.linkID;
    {/section}
    if ( windowParameters.linkWindow == "_blank" )
            document.getElementById("linkWindow").checked = true;
    document.getElementById("linkText").focus();
    if ( windowParameters.linkText == "ez_image" )
    {ldelim}
        document.getElementById("linkText").disabled = true;
    {rdelim}

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
    displayAttributes( 'link', windowParameters.customAttributes );
    {/if}
    {rdelim}

{rdelim}

function insert()
{ldelim}
    var linkParameters = new Array();
    linkParameters["linkUrl"] = document.getElementById("linkUrl").value;
    if ( document.getElementById("linkWindow").checked )
	    linkParameters["linkWindow"] = "_blank";
	else
	    linkParameters["linkWindow"] = "_self";
    linkParameters["linkText"] = document.getElementById("linkText").value;
    if ( linkParameters["linkText"] == "" )
    {ldelim}
        alert( "Link text can not be empty." );
    {rdelim}
    else
    {ldelim}
        linkParameters["linkClass"] = document.getElementById("linkClass").value;
        linkParameters["linkView"] = document.getElementById("linkView").value;
{if ge($ezpublish_version, 3.9)}
        var CustomAttributeName = document.getElementsByName("CustomAttributeName");
        if ( CustomAttributeName.length != null )
        {ldelim}
            var CustomAttributeValue = document.getElementsByName("CustomAttributeValue");
            linkParameters["customAttributes"] = packCustomAttributes( CustomAttributeName, CustomAttributeValue );
        {rdelim}
        else
{/if}
            linkParameters["customAttributes"] = "";

        {section show=ge($ezpublish_version, 3.6)}
        linkParameters["linkTitle"] = document.getElementById("linkTitle").value;
        linkParameters["linkID"] = document.getElementById("linkID").value;
        {/section}

        var editorID = document.getElementById("editorID").value;
        opener.addLink( editorID, linkParameters );
        window.close();
    {rdelim}
{rdelim}

function getType()
{ldelim}
    var linkType = document.getElementById("linkType").value;
    document.getElementById("linkUrl").value =  linkType;

    var browseNodeField = document.getElementById("browseNodeField");
    var browseObjectField = document.getElementById("browseObjectField");
    var linkViewBlock = document.getElementById("linkViewBlock");

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
{rdelim}

function preBrowse()
{ldelim}
    document.getElementById("linkText").disabled = false;
    document.getElementById("linkClass").disabled = false;
{rdelim}
// -->
</script>

<input type="hidden" id="editorID" value="" />

<input type="hidden" id="browseActionName" value="{$browse_action_name}" />

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
<div class="block">
<label>{"Text"|i18n("design/standard/ezdhtml")}:</label>
<input id="linkText" class="box" name="linkText" type="text" size="50" value="{$link_text}"/>
</div>

<div class="block">
<label>{"Type"|i18n("design/standard/ezdhtml")}:</label>
<select id ="linkType" onchange="getType()">
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
        <input type="submit" name="BrowseButton[node]" onclick="preBrowse()" value="{'Browse'|i18n('design/standard/ezdhtml')}" />
    </div>
    <div id="browseObjectField" style="display:none">
        <input type="submit" name="BrowseButton[object]" onclick="preBrowse()" value="{'Browse'|i18n('design/standard/ezdhtml')}" />
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

<div class="block">
<label>{"Class"|i18n("design/standard/ezdhtml")}:</label>
<select id ="linkClass" name="linkClass">
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
{include uri="design:custom_attr_output_gecko.tpl"}
{/if}

<div class="block">
<button id="ok" onclick="insert();">{"OK"|i18n("design/standard/ezdhtml")}</button>
<button id="cancel" onclick="window.close();">{"Cancel"|i18n("design/standard/ezdhtml")}</button>
</div>

</div>
