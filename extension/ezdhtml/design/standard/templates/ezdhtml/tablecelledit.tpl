<script type="text/javascript" for="window" event="onload">
<!--
    // When window gets created, set some default values
    cellWidth.value  = window.dialogArguments["width"];
    
    {section show=$class_list}
    cellClass.value  = window.dialogArguments["class"];
    if ( window.dialogArguments["class"] == "" )
	     cellClass.value = -1;
	  {/section}
// -->
</script>

<script type="text/javascript" for="ok" event="onclick">
<!--
  var arr = new Array();
  arr["width"] = cellWidth.value;
  
  {section show=$class_list}
  arr["class"] = cellClass.value;
  {section-else}
  arr["class"] = -1;
  {/section}
  
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

<div class="onlineeditor">
<h1>{"Edit Cell properties"|i18n("design/standard/ezdhtml")}</h1>

<div class="block">
<label>{"Width"|i18n("design/standard/ezdhtml")}:</label>
<input id="cellWidth" type="text" size="4" name="cellWidth" />
</div>

<div class="block">
<fieldset>
<legend>{"Apply to"|i18n("design/standard/ezdhtml")}</legend>
{"Cell"|i18n("design/standard/ezdhtml")}<input type="radio" name="widthTarget" value="cell" checked />
{"Row"|i18n("design/standard/ezdhtml")}<input type="radio" name="widthTarget" value="row"/>
{"Column"|i18n("design/standard/ezdhtml")}<input type="radio" name="widthTarget" value="column" />
</fieldset>
</div>

{section show=$class_list}
<div class="block">
<label>{"Class"|i18n("design/standard/ezdhtml")}:</label>
    <select name="cellClass" align="left">
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
</div>

<div class="block">
<fieldset>
<legend>{"Apply to"|i18n("design/standard/ezdhtml")}</legend>
{"Cell"|i18n("design/standard/ezdhtml")}<input class="radio" type="radio" name="classTarget" value="cell" checked />
{"Row"|i18n("design/standard/ezdhtml")}<input class="radio" type="radio" name="classTarget" value="row" />
{"Column"|i18n("design/standard/ezdhtml")}<input type="radio" name="classTarget" value="column" />
</fieldset>
</div>
{section-else}
    {"No classes are available for the element: "|i18n("design/standard/ezdhtml")}<strong>&lt;td&gt;</strong>
{/section}

<div class="block">
	<button class="button" id="ok" type="submit">{"OK"|i18n("design/standard/ezdhtml")}</button>
  <button onclick="window.close();">{"Cancel"|i18n("design/standard/ezdhtml")}</button>
</div>

</div>
