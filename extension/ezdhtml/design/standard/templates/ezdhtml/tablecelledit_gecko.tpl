<script type="text/javascript" for="ok" event="onclick">
<!--
  var arr = new Array();
  arr["width"] = cellWidth.value;
  arr["class"] = cellClass.value;
  if ( widthTarget[0].checked )
      arr["widthTarget"] = widthTarget[0].value;
  if ( widthTarget[1].checked )
      arr["widthTarget"] = widthTarget[1].value;
  if ( widthTarget[2].checked )
      arr["widthTarget"] = widthTarget[2].value;
  {section show=$class_list}
  if ( classTarget[0].checked )
      arr["classTarget"] = classTarget[0].value;
  if ( classTarget[1].checked )
      arr["classTarget"] = classTarget[1].value;
  if ( classTarget[2].checked )
      arr["classTarget"] = classTarget[2].value;
  {/section}
  window.returnValue = arr;
  window.close();
// -->
</script>

<script type="text/javascript">
<!--
function Init()
{literal}{{/literal}
var editorID = opener.document.getElementById("iframeID").value;
document.getElementById("editorID").value = editorID;
var windowParameters = opener.tableCellPropertyParameters( editorID );
if ( windowParameters == null )
    window.close();
{section show=$class_list}
var classValue = windowParameters.cellClass;
if ( classValue == "" )
	 classValue = -1;
document.getElementById("cellClass").value = classValue;
{/section}
document.getElementById("cellWidth").value = windowParameters.cellWidth;
document.getElementById("cellWidth").focus();
{literal}}{/literal}

function insert()
{literal}{{/literal}
    var tableCellParameters = new Array();
    {section show=$class_list}
    tableCellParameters["cellClass"] = document.getElementById("cellClass").value;
    {section-else}
    tableCellParameters["cellClass"] = -1;
    {/section}
    tableCellParameters["cellWidth"] = document.getElementById("cellWidth").value;
    var widthTarget = document.getElementsByName("widthTarget");
    if ( widthTarget[0].checked )
        tableCellParameters["widthTarget"] = widthTarget[0].value;
    if ( widthTarget[1].checked )
        tableCellParameters["widthTarget"] = widthTarget[1].value;
    if ( widthTarget[2].checked )
        tableCellParameters["widthTarget"] = widthTarget[2].value;
    {section show=$class_list}
    var classTarget = document.getElementsByName("classTarget");
    if ( classTarget[0].checked )
        tableCellParameters["classTarget"] = classTarget[0].value;
    if ( classTarget[1].checked )
        tableCellParameters["classTarget"] = classTarget[1].value;
    if ( classTarget[2].checked )
        tableCellParameters["classTarget"] = classTarget[2].value;
    {/section}
    var editorID = document.getElementById("editorID").value;
    opener.addTableCellProperty( editorID, tableCellParameters );
    window.close();
{literal}}{/literal}
// -->
</script>

<input type="hidden" id="editorID" value="" />

<div class="onlineeditor">

<h1>{"Edit Cell properties"|i18n("design/standard/ezdhtml")}</h1>

<div class="block">
<label>{"Width"|i18n("design/standard/ezdhtml")}:</label>
<input id="cellWidth" type="text" size="4" name="cellWidth" />
<fieldset>
<legend>{"Apply to"|i18n("design/standard/ezdhtml")}</legend>
{"Cell"|i18n("design/standard/ezdhtml")}<input type="radio" name="widthTarget" value="cell" checked />
{"Row"|i18n("design/standard/ezdhtml")}<input type="radio" name="widthTarget" value="row"/>
{"Column"|i18n("design/standard/ezdhtml")}<input type="radio" name="widthTarget" value="column" />
</fieldset>
</div>

<div class="block">
<label>{"Class"|i18n("design/standard/ezdhtml")}:</label>
{section show=$class_list}
<select id="cellClass" align="left">
<option value="-1">[{"none"|i18n("design/standard/ezdhtml")}]</option>
{let classDescriptionTD=ezini( 'td', 'ClassDescription', 'content.ini')
     classDescriptionTH=ezini( 'th', 'ClassDescription', 'content.ini')
     classDescription=$classDescriptionTD|merge($classDescriptionTH)}
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

<fieldset>
<legend>{"Apply to"|i18n("design/standard/ezdhtml")}</legend>
{"Cell"|i18n("design/standard/ezdhtml")}<input class="radio" type="radio" name="classTarget" value="cell" checked />
{"Row"|i18n("design/standard/ezdhtml")}<input class="radio" type="radio" name="classTarget" value="row" />
{"Column"|i18n("design/standard/ezdhtml")}<input type="radio" name="classTarget" value="column" />
</fieldset>
{section-else}
    {"No classes are available for the element: "|i18n("design/standard/ezdhtml")}<strong>&lt;td&gt;</strong>
{/section}
</div>

<div class="block">
	<button id="ok" onclick="insert();">{"OK"|i18n("design/standard/ezdhtml")}</button>
	<button onclick="window.close();">{"Cancel"|i18n("design/standard/ezdhtml")}</button>
</div>

</div>
