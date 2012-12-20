{default input_handler=$attribute.content.input
         attribute_base='ContentObjectAttribute'
         editorRow=10}

{section show=gt($attribute.contentclass_attribute.data_int1,10)}
    {set editorRow=$attribute.contentclass_attribute.data_int1}
{/section}

{section show=and($input_handler.is_editor_enabled,$input_handler.is_compatible_version)}
<!-- DHTML editor textarea field -->
<script type="text/javascript">
    var textStrings=new Array();
    textStrings["InsertObject"]="{'Insert object'|i18n('design/standard/ezdhtml')}";
    textStrings["InsertLink"]="{'Insert link'|i18n('design/standard/ezdhtml')}";
    textStrings["InsertTable"]="{'Insert table'|i18n('design/standard/ezdhtml')}";
    textStrings["Undo"]="{'Undo'|i18n('design/standard/ezdhtml')}";
    textStrings["Redo"]="{'Redo'|i18n('design/standard/ezdhtml')}";
    textStrings["Bold"]="{'Bold'|i18n('design/standard/ezdhtml')}";
    textStrings["Italic"]="{'Italic'|i18n('design/standard/ezdhtml')}";
    textStrings["Numbered"]="{'Numbered list'|i18n('design/standard/ezdhtml')}";
    textStrings["BulletList"]="{'Bullet list'|i18n('design/standard/ezdhtml')}";
    textStrings["InsertSpecialCharacter"]="{'Insert special character'|i18n('design/standard/ezdhtml')}";
    textStrings["InsertLiteral"]="{'Insert literal text'|i18n('design/standard/ezdhtml')}";
    textStrings["InsertAnchor"]="{'Insert anchor'|i18n('design/standard/ezdhtml')}";
    textStrings["InsertCustomTag"]="{'Insert custom tag'|i18n('design/standard/ezdhtml')}";
    textStrings["InsertRow"]="{'Insert row'|i18n('design/standard/ezdhtml')}";
    textStrings["InsertColumn"]="{'Insert column'|i18n('design/standard/ezdhtml')}";
    textStrings["DeleteRow"]="{'Delete row'|i18n('design/standard/ezdhtml')}";
    textStrings["DeleteColumn"]="{'Delete column'|i18n('design/standard/ezdhtml')}";
    textStrings["SplitCell"]="{'Split cell'|i18n('design/standard/ezdhtml')}";
    textStrings["MergeCell"]="{'Merge cell'|i18n('design/standard/ezdhtml')}";
    textStrings["MergeDown"]="{'Merge down'|i18n('design/standard/ezdhtml')}";
    textStrings["DecreaseListIndent"]="{'Decrease list indent'|i18n('design/standard/ezdhtml')}";
    textStrings["IncreaseListIndent"]="{'Increase list indent'|i18n('design/standard/ezdhtml')}";
    textStrings["Find"]="{'Find'|i18n('design/standard/ezdhtml')}";
    textStrings["Help"]="{'Help'|i18n('design/standard/ezdhtml')}";
    textStrings["Heading1"]="{'Heading 1'|i18n('design/standard/ezdhtml')}";
    textStrings["Heading2"]="{'Heading 2'|i18n('design/standard/ezdhtml')}";
    textStrings["Heading3"]="{'Heading 3'|i18n('design/standard/ezdhtml')}";
    textStrings["Heading4"]="{'Heading 4'|i18n('design/standard/ezdhtml')}";
    textStrings["Heading5"]="{'Heading 5'|i18n('design/standard/ezdhtml')}";
    textStrings["Heading6"]="{'Heading 6'|i18n('design/standard/ezdhtml')}";
    textStrings["Normal"]="{'Normal'|i18n('design/standard/ezdhtml')}";
    textStrings["Properties"]="{'Properties'|i18n('design/standard/ezdhtml')}";
    textStrings["LinkProperties"]="{'Link Properties'|i18n('design/standard/ezdhtml')}";
    textStrings["Cut"]="{'Cut'|i18n('design/standard/ezdhtml')}";
    textStrings["Copy"]="{'Copy'|i18n('design/standard/ezdhtml')}";
    textStrings["Delete"]="{'Delete'|i18n('design/standard/ezdhtml')}";
    textStrings["Paste"]="{'Paste'|i18n('design/standard/ezdhtml')}";
    textStrings["MergeCells"]="{'Merge Cells'|i18n('design/standard/ezdhtml')}";
    textStrings["SelectAll"]="{'Select All'|i18n('design/standard/ezdhtml')}";
    textStrings["SplitCell"]="{'Split Cell'|i18n('design/standard/ezdhtml')}";
    textStrings["SelectedImageTypeIsNotAnchor"]="{'Selected image type is not an anchor'|i18n('design/standard/ezdhtml')}";
    textStrings["Class"]="{'Class: '|i18n('design/standard/ezdhtml')}";
    textStrings["ClassNone"]="{'Class: [none]'|i18n('design/standard/ezdhtml')}";
    textStrings["MakeLink"]="{'Make link'|i18n('design/standard/ezdhtml')}";
    textStrings["RemoveLink"]="{'Remove link'|i18n('design/standard/ezdhtml')}";
    textStrings["Separator"]="{'Separator'|i18n('design/standard/ezdhtml')}";
    textStrings["TableProperties"]="{'Table Properties'|i18n('design/standard/ezdhtml')}";
    textStrings["CellProperties"]="{'Cell Properties'|i18n('design/standard/ezdhtml')}";
    textStrings["ChangeToTH"]="{'Change To TH'|i18n('design/standard/ezdhtml')}";
    textStrings["ChangeToTD"]="{'Change To TD'|i18n('design/standard/ezdhtml')}";
    textStrings["HeadingInsideListIsNotAllowed"]="{'Headings are not allowed inside a list.'|i18n('design/standard/ezdhtml')}";
    textStrings["ErrorTheNumberOfRowsIsRequiredAndHasToBeAtLeast1"]="{'Error: The number of rows is required and has to be at least 1!'|i18n('design/standard/ezdhtml')}";
    textStrings["ErrorTheNumberOfColumnsIsRequiredAndHasToBeAtLeast1"]="{'Error: The number of columns is required and has to be at least 1!'|i18n('design/standard/ezdhtml')}";

    // The next line remain untranstaled cause they should never appear in normal OE usage
    textStrings["ProblemToInsertSpecialCharacter"]='Problem to insert special character';
    textStrings["ProblemToInsertClassAttribute"]='Problem to insert class attribute';
    textStrings["MergeCellsIsNotPossible"]='Merge cells is not possible';
    textStrings["SplitCellIsNotPossible"]='Split cell is not possible';
    textStrings["DeleteColumnIsNotPossible"]='Delete column is not possible';
    textStrings["DeleteRowIsNotPossible"]='Delete row is not possible';	
    textStrings["InsertRowIsNotPossible"]='Insert row is not possible';
    textStrings["ProblemToInsertTable"]='Problem to insert a table';
    textStrings["ProblemToInsertLiteral"]='Problem to insert literal';
    textStrings["SelectionIsNotALiteralTag"]='Selection is not a literal tag';
    textStrings["ProblemToInsertInlineCustomTag"]='Problem to insert an inline custom tag';
    textStrings["SelectedImageTypeIsNotCustomTag"]='Selected image type is not a custom tag';
    textStrings["SelectedTableTypeIsNotCustomTag"]='Selected table type is not a custom tag';
    textStrings["ProblemToInsertObject"]='Problem to insert an object';
    textStrings["ProblemToInsertAnchor"]='Problem to insert an anchor';
    textStrings["ProblemToAddLink"]='Problem to add a link';

    var EditorCSSFileList=new Array();
    {section loop = ezini( 'StylesheetSettings', 'EditorCSSFileList', 'design.ini' )}
    EditorCSSFileList[{$index}] = {$:item|ezdesign};
    {/section}
</script>
{section show=eq($input_handler.browser_supports_dhtml_type,"IE")}
    {run-once}
    <script type="text/javascript" src={"javascripts/ezdhtml/ezeditor.js"|ezdesign} charset="iso-8859-1"></script>
    <script type="text/javascript">
        document.createStyleSheet('{"stylesheets/ezdhtml/toolbar.css"|ezdesign(no)}');
    </script>
    {/run-once}
<div class="oe-window">
    <textarea class="box" name="{$attribute_base}_data_text_{$attribute.id}" cols="90" rows="{$editorRow}">{$input_handler.input_xml}</textarea>
    <script type="text/javascript">
    var Editor = new eZEditor( '{$attribute_base}_data_text_{$attribute.id}', {"/extension/ezdhtml/"|ezroot}, {'images/ezdhtml/'|ezdesign},
    '{$input_handler.version}', '{$attribute.contentobject_id}', '{$attribute.version}', '{ezsys('indexdir')}', '{$input_handler.ezpublish_version}' );
    Editor.startEditor();
    </script>
    <br />
</div>
<!-- End editor -->
{/section}
{section show=eq($input_handler.browser_supports_dhtml_type,"Gecko")}
    {run-once}
    <script type="text/javascript" src={"javascripts/ezdhtml/ezmozillaeditor.js"|ezdesign} charset="iso-8859-1"></script>
    <script type="text/javascript">
        document.styleSheets[0].insertRule('@import url({"stylesheets/ezdhtml/toolbar.css"|ezdesign(no)});', 0);
        document.styleSheets[0].insertRule('@import url({"stylesheets/ezdhtml/contextmenu.css"|ezdesign(no)});', 0);
    </script>
    <input type="hidden" id="iframeID" value="i got it" />
    {/run-once}
<div class="oe-window">
    <textarea class="box" id="{$attribute_base}_data_text_{$attribute.id}" name="{$attribute_base}_data_text_{$attribute.id}" cols="88" rows="{$editorRow}" style="display:none;">{$input_handler.input_xml}</textarea>
    <script type="text/javascript">
    var Editor = new eZEditor( '{$attribute_base}_data_text_{$attribute.id}', {'/extension/ezdhtml/'|ezroot}, {'images/ezdhtml/'|ezdesign},
    '{$input_handler.version}', '{$attribute.contentobject_id}', '{$attribute.version}', '{ezsys('indexdir')}', '{$input_handler.ezpublish_version}' );
    Editor.startEditor();
    </script>
</div>
<!-- End editor -->
{/section}
{section show=eq($input_handler.browser_supports_dhtml_type,"Vista")}
    {"You're running Internet Explorer on Windows Vista. The Online Editor is currently not compatible with this configuration. Please disable the editor or use Firefox/Mozilla browser."|i18n('design/standard/ezdhtml')}
{/section}
<div class="block">
<input class="button" type="submit" name="CustomActionButton[{$attribute.id}_disable_editor]" value="{'Disable editor'|i18n('design/standard/content/datatype')}" />
</div>
{section-else}
{section show=$input_handler.is_editor_enabled}
<h5>( OE version is {$input_handler.version}, while eZ publish requires {$input_handler.required_version} )</h5>
{let aliased_handler=$input_handler.aliased_handler}

{include uri=concat("design:content/datatype/edit/",$aliased_handler.edit_template_name,".tpl") input_handler=$aliased_handler}

{/let}
{section-else}
{let aliased_handler=$input_handler.aliased_handler}

{include uri=concat("design:content/datatype/edit/",$aliased_handler.edit_template_name,".tpl") input_handler=$aliased_handler}

<input class="button" type="submit" name="CustomActionButton[{$attribute.id}_enable_editor]" value="{'Enable editor'|i18n('design/standard/content/datatype')}" /><br />

{/let}
{/section}
{/section}
{/default}
