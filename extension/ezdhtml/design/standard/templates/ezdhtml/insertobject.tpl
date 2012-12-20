{section show=$is_upload}
<script type="text/javascript" for="window" event="onload">
<!--
// -->
</script>

<script type="text/javascript" for="uploadButton" event="onclick">
    document.getElementById("warningText").style.visibility="visible";
</script>

<div class="onlineeditor">

<h1>{"Upload local file"|i18n("design/standard/ezdhtml")}</h1>
<form enctype="multipart/form-data" action={concat("ezdhtml/insertobject","/",$object_id,"/",$object_version,"/")|ezurl} method="post">

<div class="block">

<label>{"Location"|i18n("design/standard/ezdhtml")}:</label>
<select name="location">
<option value="auto">{"Automatic"|i18n("design/standard/ezdhtml")}</option>
    {let $root_node_value=ezini( 'LocationSettings', 'RootNode', 'upload.ini' )
         $root_node=cond( $root_node_value|is_numeric, fetch( content, node, hash( node_id, $root_node_value ) ),
                         fetch( content, node, hash( node_path, $root_node_value ) ) )
         $content_object=fetch( content, object, hash( object_id, $object_id  ) )}
    {section show=$content_object.published}
     <option value="{$content_object.main_node_id}">{$content_object.name}</option>
    {/section}
	{let $selection_list=fetch( 'content', 'tree',
                                 hash( 'parent_node_id', $root_node.node_id,
                                       'class_filter_type', include,
                                       'class_filter_array', ezini( 'LocationSettings', 'ClassList', 'upload.ini' ),
                                       'depth', ezini( 'LocationSettings', 'MaxDepth', 'upload.ini' ),
								       'depth_operator', 'lt',
                                       'limit', ezini( 'LocationSettings', 'MaxItems', 'upload.ini' ) ) )}
										
		{section loop=$selection_list}
		{section show=$item.can_create}
		 <option value="{$item.node_id}">{'&nbsp;'|repeat( sub( $item.depth, $root_node.depth, 1 ) )}{$item.name|wash}</option>
		{/section}
		{/section}
    {/let}{/let}
</select>
</div>

{section show=eq( $support_object_naming, true() )}
<div class="block">
<label>{"Name"|i18n("ezdhtml","design/standard/ezdhtml")}:</label>
<input class="box" name="objectName" type="text" value="" />
</div>
{/section}

<div class="block">
<label>{"File"|i18n("design/standard/ezdhtml")}:</label>
<input class="box" size="48" name="fileName" type="file" />
<input type="hidden" name="MAX_FILE_SIZE" value="50000000" />
</div>


<input class="button" type="submit" name="uploadButton" id="uploadButton" value="{'OK'|i18n('design/standard/ezdhtml')}" />
<input class="button" type="submit" name="cancelButton" id="cancelButton" value="{'Cancel'|i18n('design/standard/ezdhtml')}" />

<div class="message-warning" style="visibility: hidden" id="warningText">
<h2>{"Upload is in progress, it may take a few seconds ..."|i18n("design/standard/ezdhtml")}</h2>
</div>

</form>

<div style="height:400px;">
</div>
{section-else}

{include uri="design:custom_attributes.tpl"}

{include uri="design:custom_attr_init.tpl"
         tag_name='embed'
         tag_attributes=$embed_attributes
         tag_defaults=$embed_defaults}

{include uri="design:custom_attr_init.tpl"
         tag_name='embed-inline'
         tag_attributes=$embed_inline_attributes
         tag_defaults=$embed_inline_defaults}

{literal}
<script type="text/javascript" for="window" event="onload">
    <!--
    // When window gets created, set some default values

    var objectID = "";
    var customAttributes = -1;
    var objectSrc = "";
    var imageExist = false;
    try
    {
        objectID = window.dialogArguments["objectID"];
        ContentObjectAlignment.value = window.dialogArguments["objectAlign"];
        size = window.dialogArguments["objectSize"];
        if ( size == "" )
            size = "{/literal}{$default_size}{literal}";

        ContentObjectSize.value = size;

        if ( window.dialogArguments["objectView"] != '' )
            ObjectView.value = window.dialogArguments["objectView"];
{/literal}

        {section show=ge($ezpublish_version, 3.8)}
        updateEmbedInline();
        {/section}

        {section show=ge($ezpublish_version, 3.6)}
        HtmlID.value = window.dialogArguments["htmlID"];
        {/section}

{literal}

        //if ( EmbedInline.checked == true )
            EmbedInlineClass.value = window.dialogArguments["objectClass"];
        //else
            ObjectClass.value = window.dialogArguments["objectClass"];

        customAttributes = window.dialogArguments["customAttributes"];
        objectSrc = window.dialogArguments["objectSrc"];
        imageExist  = window.dialogArguments["imageExist"];
    }
    catch( e )
    {
    }
    var objectIDString = "";
    var imageSrc = "";
    if ( objectID != "")
        objectIDString = "id='" + objectID;
    else
        objectIDString = "none";
    var isObject = objectSrc.match(/object_insert/g);

    var tagName = 'embed';
    if ( EmbedInline.checked == true )
        tagName = 'embed-inline';

    displayAttributes( tagName, customAttributes );

    try
    {
        for (var index=0;index<ContentObjectIDString.length;index++)
        {
            if (ContentObjectIDString[index].value.match(objectIDString) )
            {
                if ( objectID != "" )
                    ContentObjectIDString[index].checked = true;
                ContentObjectIDString[index].className = "selected";
                imageSrc = ContentObjectIDString[index].value;
            }
        }
    }
    catch( e )
    {
    }
    if ( isObject )
         ContentObjectSize.disabled=true;
    else
         ContentObjectSize.disabled=false;
// -->
</script>

<script type="text/javascript" for="ok" event="onclick">
    <!--
    var arr = new Array();

    // Contains object id and object icon path or image src path. The source has to be a proper "http://" URL
    // otherwise the editor doesn' show the image!
    var objectIDString = "";
    var ContentObjectIDString = document.getElementsByName("ContentObjectIDString");
    try
        {
        for (var i=0;i<ContentObjectIDString.length;i++)
        {
            if ( ContentObjectIDString[i].checked == true)
            {
                objectIDString = ContentObjectIDString[i].value;
            }
        }
    }
    catch( e )
    {
    }
    if ( objectIDString != "" )
    {
        arr["objectIDString"] = objectIDString;
        arr["objectAlign"] = ContentObjectAlignment.value;
        arr["objectSize"] = ContentObjectSize.value;
        if ( ContentObjectSize.disabled )
            arr["objectSize"] = "";

        arr["embedInline"] = EmbedInline.checked;

        if ( arr["embedInline"] == true )
            arr["objectClass"] = EmbedInlineClass.value;
        else
            arr["objectClass"] = ObjectClass.value;


        arr["objectView"] = ObjectView.value;
{/literal}

        {section show=ge($ezpublish_version, 3.6)}
        arr["htmlID"] = HtmlID.value;
        {/section}

{literal}

        arr["customAttributes"] = new Array();
        if ( typeof CustomAttributeName != 'undefined' && typeof CustomAttributeName != 'unknown' )
        {
            var customAttributes = new Array();
            if ( CustomAttributeName.length != null )
            {
                for (var i=0;i<CustomAttributeName.length;i++)
            {
                if ( CustomAttributeValue.length != null )
                {
                    if ( CustomAttributeValue[i].value != "" )
                        customAttributes[i]=CustomAttributeName[i].value + "|" + CustomAttributeValue[i].value;
                }
                else
                {
                    if ( CustomAttributeValue.value != "" )
                        customAttributes[i]=CustomAttributeName[i].value + "|" + CustomAttributeValue.value
                }
            }
        }
        else
        {
                customAttributes[0]=CustomAttributeName.value + "|" + CustomAttributeValue.value;
        }
        arr["customAttributes"] = customAttributes;
        }
        window.returnValue = arr;
        window.close();
    }
    else
    {
        alert( "You must select an object to insert" );
    }
// -->
</script>

<script type="text/javascript" for="ContentObjectIDString" event="onclick">
    var objectIDString = "";
    for (var i=0;i<ContentObjectIDString.length;i++)
    {
        if ( ContentObjectIDString[i].checked == true)
        {
            objectIDString = ContentObjectIDString[i].value;
            ContentObjectIDString[i].className = "selected";
        }
        else
            ContentObjectIDString[i].className = "unselected";
    }
    var isObject = objectIDString.match(/object_insert/g);
    if ( objectIDString != "none" )
        ok.disabled=false;
    if ( isObject )
    {
        ContentObjectSize.disabled=true;
        sizeRow.disabled=true;
    }
    else
    {
        ContentObjectSize.disabled=false;
        sizeRow.disabled=false;
    }
</script>

<script type="text/javascript" for="ObjectClass" event="onclick">
    ok.disabled=false;
</script>

{/literal}

<script type="text/javascript">

var isViewInline = new Array();
{section var=$view loop=$view_list}
 {section show=$inline_view_list|contains($view)}
  isViewInline['{$view}']=true;
 {section-else}
  isViewInline['{$view}']=false;
 {/section}
{/section}

{literal}
// Update Inline checkbox
function updateEmbedInline()
{
    var view = document.getElementById("ObjectView").value;

    if ( isViewInline[view] == true )
    {
        document.getElementById("EmbedInline").checked = true;
        document.getElementById("classInlineRow").className = '';
        document.getElementById("classRow").className = 'hide';
    }
    else
    {
        document.getElementById("EmbedInline").checked = false;
        document.getElementById("classRow").className = '';
        document.getElementById("classInlineRow").className = 'hide';
    }
}

function updateAttributes()
{
    removeAttributes();

    var tagName = 'embed';
    if ( EmbedInline.checked == true )
        tagName = 'embed-inline';

    displayAttributes( tagName, -1 );
}

</script>
{/literal}

<div class="onlineeditor">
<h1>{"Select from related objects or upload local files"|i18n("design/standard/ezdhtml")}</h1>

<fieldset>
<legend>{'Related objects'|i18n('design/standard/ezdhtml')}</legend>

{section show=$related_contentobjects|count|gt( 0 )}

    {* Related images *}
    {section show=$grouped_related_contentobjects.images|count|gt( 0 )}
    <h2>{'Related images'|i18n('design/standard/ezdhtml')}</h2>
    <table class="list-thumbnails" cellspacing="0" width="100%">
    <tr>
        {section var=RelatedImageObjects loop=$grouped_related_contentobjects.images}
        <td>
        <div class="image-thumbnail-item">
            {attribute_view_gui attribute=$RelatedImageObjects.RelatedObject.data_map.image image_class=small}
            <p>
                <input type="radio" {section show=$RelatedImageObjects.ObjectIsSelected}class="selected"{/section} name="ContentObjectIDString" value="{$RelatedImageObjects.ObjectIDString}" {section show=$RelatedImageObjects.ObjectIsSelected}checked{/section}/>
                {$RelatedImageObjects.RelatedObject.name|wash}
           </p>
        </div>
        </td>
        {delimiter modulo=4}
        </tr><tr>
        {/delimiter}
        {/section}
    </tr>
    </table>
    {/section}

    {* Related files *}
    {section show=$grouped_related_contentobjects.files|count|gt( 0 )}
    <h2>{'Related files'|i18n('design/standard/ezdhtml')}</h2>
            <table class="list" cellspacing="0">
            <tr>
                <th class="tight">&nbsp;</th>
                <th class="name">{'Name'|i18n( 'design/admin/content/edit' )}</th>
                <th class="class">{'File type'|i18n( 'design/admin/content/edit' )}</th>
                <th class="filesize">{'Size'|i18n( 'design/admin/content/edit' )}</th>
            </tr>

            {section var=RelatedFileObjects loop=$grouped_related_contentobjects.files sequence=array( bglight, bgdark )}
                <tr class="{$RelatedFileObjects.sequence|wash}">
                    <td><input type="radio" {section show=$RelatedFileObjects.ObjectIsSelected}class="selected"{/section} name="ContentObjectIDString" value="{$RelatedFileObjects.ObjectIDString}" {section show=$RelatedFileObjects.ObjectIsSelected}checked{/section} /></td>
                    <td class="name">{$RelatedFileObjects.RelatedObject.class_name|class_icon( small, $RelatedFileObjects.RelatedObject.class_name )}&nbsp;{$RelatedFileObjects.RelatedObject.name|wash}</td>
                    <td class="filetype">{$RelatedFileObjects.RelatedObject.data_map.file.content.mime_type|wash}</td>
                    <td class="filesize">{$RelatedFileObjects.RelatedObject.data_map.file.content.filesize|si( byte )}</td>
                </tr>
            {/section}
            </table>
    {/section}

    {* Related objects *}
    {section show=$grouped_related_contentobjects.objects|count|gt( 0 )}
    <h2>{'Related content'|i18n('design/standard/ezdhtml')}</h2>
            <table class="list" cellspacing="0">
            <tr>
                <th class="tight">&nbsp;</th>
                <th class="name">{'Name'|i18n( 'design/admin/content/edit' )}</th>
                <th class="class">{'Type'|i18n( 'design/admin/content/edit' )}</th>
            </tr>
            {section var=RelatedObjects loop=$grouped_related_contentobjects.objects sequence=array( bglight, bgdark )}
                <tr class="{$RelatedObjects.sequence|wash}">
                    <td class="checkbox"><input type="radio" {section show=$RelatedObjects.ObjectIsSelected}class="selected"{/section} name="ContentObjectIDString" value="{$RelatedObjects.ObjectIDString}" {section show=$RelatedObjects.ObjectIsSelected}checked{/section} /></td>
                    <td class="name">{$RelatedObjects.RelatedObject.class_name|class_icon( small, $RelatedObjects.RelatedObject.class_name )}&nbsp;{$RelatedObjects.RelatedObject.name|wash}</td>
                    <td class="class">{$RelatedObjects.RelatedObject.class_name|wash}</td>
                </tr>
            {/section}
            </table>
    {/section}
{section-else}
<div class="block">
<p>{"There are no related objects."|i18n("design/standard/ezdhtml")}</p>
</div>
{/section}

<form enctype="multipart/form-data" action={concat("ezdhtml/insertobject","/",$object_id,"/",$object_version,"/")|ezurl} method="post">

<input type="submit" class="button" name="uploadFile" id="uploadfile" value="{'Upload new'|i18n('design/standard/ezdhtml')}" />
<input type="submit" class="button" name="BrowseButton" id="BrowseButton" value="{'Add existing'|i18n('design/standard/ezdhtml')}" />

</form>

</fieldset>

<fieldset>
<legend>{'Properties'|i18n('design/standard/ezdhtml')}</legend>

    <table id="attributes" class="list" cellspacing="0">
    <tr>
        <th class="tight">&nbsp;</th>
        <th width="30%">{'Property name'|i18n('design/standard/ezdhtml')}</th>
        <th width="60%">{'Value'|i18n('design/standard/ezdhtml')}</th>
    </tr>
    <tr id="sizeRow" class="bglight">
        <td><input type='checkbox' disabled="true"{if ge($ezpublish_version, 3.9)} class="hide"{/if}/></td>
        <td class="name">Size</td>
        <td class="value">
        <select id="ContentObjectSize" onClick="ok.disabled=false">
            {section name=SizeArray loop=$size_type_list}
                <option value="{$SizeArray:item}">{$SizeArray:item}</option>
	        {/section}
        </select>
        </td>
    </tr>
    <tr id="alignmentRow" class="bgdark">
        <td><input type='checkbox' disabled="true"{if ge($ezpublish_version, 3.9)} class="hide"{/if}/></td>
        <td class="name">Alignment</td>
        <td class="value">
        <select id="ContentObjectAlignment" onClick="ok.disabled=false">
            <option value="center" selected>{"Center"|i18n("design/standard/ezdhtml")}</option>
            <option value="left">{"Left"|i18n("design/standard/ezdhtml")}</option>
            <option value="right">{"Right"|i18n("design/standard/ezdhtml")}</option>
        </select>
        </td>
    </tr>
    <tr id="classRow" class="bglight">
        <td><input type='checkbox' disabled="true"{if ge($ezpublish_version, 3.9)} class="hide"{/if}/></td>
        <td class="name">Class</td>
        <td class="value">
        <select id ="ObjectClass">
            <option value="-1">[{"none"|i18n("design/standard/ezdhtml")}]</option>
            {let classDescriptionEmbed=ezini('embed', 'ClassDescription', 'content.ini')
                 classDescription=$classDescriptionEmbed|merge($classDescriptionObject)}
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
         </td>
    </tr>
    <tr id="classInlineRow" class='hide' style="background-color: #f8f8f4;">
        <td><input type='checkbox' disabled="true"{if ge($ezpublish_version, 3.9)} class="hide"{/if}/></td>
        <td class="name">Class</td>
        <td class="value">
        <select id="EmbedInlineClass">
            <option value="-1">[{"none"|i18n("design/standard/ezdhtml")}]</option>
            {let classDescription=ezini('embed-inline', 'ClassDescription', 'content.ini')}
            {section name=ClassArray loop=$class_list_inline}
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
         </td>
    </tr>
    <tr id="viewRow" class="bgdark">
        <td><input type='checkbox' disabled="true"{if ge($ezpublish_version, 3.9)} class="hide"{/if}/></td>
        <td class="name">View</td>
        <td class="value">
        <select id="ObjectView" onchange="updateEmbedInline();updateAttributes()">
            {section name=ViewModeArray loop=$view_list}
                <option value="{$ViewModeArray:item}">{$ViewModeArray:item}</option>
	        {/section}
	     </select>
         </td>
    </tr>
    <tr {section show=lt($ezpublish_version, 3.8)}class="hide"{/section} id="inlineRow" class="bglight">
        <td><input type='checkbox' disabled="true"{if ge($ezpublish_version, 3.9)} class="hide"{/if}/></td>
        <td class="name">Inline</td>
        <td class="value">
            <input id="EmbedInline" type='checkbox' disabled='disabled' />
        </td>
    </tr>
    {section show=ge($ezpublish_version, 3.6)}
    <tr id="idRow" class="bgdark">
        <td><input type='checkbox' disabled="true"{if ge($ezpublish_version, 3.9)} class="hide"{/if}/></td>
        <td class="name">ID</td>
        <td class="value">
        <input id="HtmlID" type="text" size="10"/>
        </td>
    </tr>
    {/section}
    <tr id="lastPropertyRow" class="bglight" style="display:none">
    </tr>
    </table>

    {if lt($ezpublish_version, 3.9)}
<div class="block"">
        <input type="button" class="button" id="remove_attribute" value="{'Remove selected'|i18n('design/standard/ezdhtml')}" onclick='removeSelected()' />
	    <input type="button" class="button" id="new_attribute" value="{'New attribute'|i18n('design/standard/ezdhtml')}" onclick='addNew()' />
</div>
    {/if}

</fieldset>

<div class="block"">
	    <input class="button" id="ok" type="submit" value={"OK"|i18n("design/standard/ezdhtml")} />
        <input type="button" class="button" onclick="window.close();" value={"Cancel"|i18n("design/standard/ezdhtml")} />
</div>
{/section}
</div>

<div style="height:200px;">
</div>
