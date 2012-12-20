//
// Javascript HTML WYSIWYG Editor
//
// Created on: <25-Oct-2002 11:34:57 kd>
//
// Copyright (C) 1999-2004 eZ systems as. All rights reserved.
//


/*! \file ezhtmleditor.js
    WYSIWYG HTML editor written in Javascript

    Needs Microsoft Internet Explorer 5 or newer

    Important documentation:

    Microsoft HTML and DHTML Reference
    http://msdn.microsoft.com/library/default.asp?url=/workshop/author/dhtml/reference/dhtml_reference_entry.asp

*/

// ***************************************************************************
// ********************* Definition of some constants ************************
// ***************************************************************************

var DECMD_BOLD =                   5000; var DECMD_COPY =               5002;
var DECMD_CUT =                    5003; var DECMD_DELETE =             5004;
var DECMD_DELETECELLS =            5005; var DECMD_DELETECOLS =         5006;
var DECMD_DELETEROWS =             5007; var DECMD_FINDTEXT =           5008;
var DECMD_FONT =                   5009; var DECMD_GETBACKCOLOR =       5010;
var DECMD_GETBLOCKFMT =            5011; var DECMD_GETBLOCKFMTNAMES =   5012;
var DECMD_GETFONTNAME =            5013; var DECMD_GETFONTSIZE =        5014;
var DECMD_GETFORECOLOR =           5015; var DECMD_HYPERLINK =          5016;
var DECMD_IMAGE =                  5017; var DECMD_INDENT =             5018;
var DECMD_INSERTCELL =             5019; var DECMD_INSERTCOL =          5020;
var DECMD_INSERTROW =              5021; var DECMD_INSERTTABLE =        5022;
var DECMD_ITALIC =                 5023; var DECMD_JUSTIFYCENTER =      5024;
var DECMD_JUSTIFYLEFT =            5025; var DECMD_JUSTIFYRIGHT =       5026;
var DECMD_LOCK_ELEMENT =           5027; var DECMD_MAKE_ABSOLUTE =      5028;
var DECMD_MERGECELLS =             5029; var DECMD_ORDERLIST =          5030;
var DECMD_OUTDENT =                5031; var DECMD_PASTE =              5032;
var DECMD_REDO =                   5033; var DECMD_REMOVEFORMAT =       5034;
var DECMD_SELECTALL =              5035; var DECMD_SEND_BACKWARD =      5036;
var DECMD_BRING_FORWARD =          5037; var DECMD_SEND_BELOW_TEXT =    5038;
var DECMD_BRING_ABOVE_TEXT =       5039; var DECMD_SEND_TO_BACK =       5040;
var DECMD_BRING_TO_FRONT =         5041; var DECMD_SETBACKCOLOR =       5042;
var DECMD_SETBLOCKFMT =            5043; var DECMD_SETFONTNAME =        5044;
var DECMD_SETFONTSIZE =            5045; var DECMD_SETFORECOLOR =       5046;
var DECMD_SPLITCELL =              5047; var DECMD_UNDERLINE =          5048;
var DECMD_UNDO =                   5049; var DECMD_UNLINK =             5050;
var DECMD_UNORDERLIST =            5051; var DECMD_PROPERTIES =         5052;

// OLECMDEXECOPT
var OLECMDEXECOPT_DODEFAULT =         0; var OLECMDEXECOPT_PROMPTUSER =    1;
var OLECMDEXECOPT_DONTPROMPTUSER =    2;

// DHTMLEDITCMDF
var DECMDF_NOTSUPPORTED =             0; var DECMDF_DISABLED =             1;
var DECMDF_ENABLED =                  3; var DECMDF_LATCHED =              7;
var DECMDF_NINCHED =                 11;

// DHTMLEDITAPPEARANCE
var DEAPPEARANCE_FLAT =               0; var DEAPPEARANCE_3D =             1;

// OLE_TRISTATE
var OLE_TRISTATE_UNCHECKED =          0; var OLE_TRISTATE_CHECKED =        1;
var OLE_TRISTATE_GRAY =               2;

// Custom constants

var CUSTOM_INSERTOBJECT =        -2;  var CUSTOM_INSERTLINK  =     -3;
var CUSTOM_INSERTTABLE =         -4;  var CUSTOM_INSERTANCHOR =    -5;
var CUSTOM_INSERTCUSTOMTAG =         -6;  var CUSTOM_SETTH =               -7;
var CUSTOM_INSERTLITERAL =       -8;  var CUSTOM_INSERTCUSTOMCLASS =   -9;
var CUSTOM_CELLPROPERTIES =      -10; var CUSTOM_HELP =            -11;
var CUSTOM_MERGEDOWN =               -12; var CUSTOM_REMOVELINK =          -13;
var CUSTOM_INSERTCHARACTER =         -14; var CUSTOM_TABLEPROPERTIES = -15;
var CUSTOM_CUSTOMTAGPROPERTIES = -16;

// ***************************************************************************
// ************************** End of constants *******************************
// ***************************************************************************

// Global variables

// Separator for context menu
var MENU_SEPARATOR = "";
var ContextMenu = new Array();
var GeneralContextMenu = new Array();
var TableContextMenu = new Array();
var ImageContextMenu = new Array();
var LinkContextMenu = new Array();
var AnchorContextMenu = new Array();
var LiteralContextMenu = new Array();
var CustomContextMenu = new Array();
var AnchorContextMenu = new Array();
var TablePropertyContextMenu = new Array();
var ParagraphContextMenu = new Array();
var LiteralTextContextMenu = new Array();
var HeaderContextMenu = new Array();
var DefaultContextMenu = new Array();
var InsertLinkContextMenu = new Array();

/*!

    Constructor of object eZEditor

*/
function eZEditor( fieldName, extensionPath, imagePath, version, objectID, objectVersion, indexDir, eZPublishVersion )
{
    // Textarea field
    var textareaField = document.all[fieldName];

    // Add functions to object
    this.startEditor = startEditor;
    this.createToolbar = createToolbar;
    this.createStatusbar = createStatusbar;

    // Get a unique name for the object reference so we can have
    // several instances on one pages
    this.objectRef = "eZEditor_" + fieldName + "_";

    // Set input field name
    this.fieldName = fieldName;

    // Set editing object id
    this.objectID = objectID;

    // Set editing object version
    this.objectVersion = objectVersion;

    // Set index directory
    this.indexDir = indexDir === '/' ? '' : indexDir;

    this.extensionPath = extensionPath;

    //alert('ep: ' + extensionPath );

    this.eZPublishVersion = eZPublishVersion;
    this.OEVersion = version;

    // Set size of input field
    // TODO: What if nothing is used. why does textareaField.cols always return something?
    // this.width = 513;
    // this.height = 200;
    this.width = textareaField.cols*7;
    this.height = textareaField.rows*17;
    /*
    if ( textareaField.style.width )
    {
        this.width = textareaField.style.width;
    }
    else
    {
        this.width = textareaField.cols*8;
    }

    if ( textareaField.style.height )
    {
        this.height = textareaField.style.height;
    }
    else
    {
        this.height = textareaField.rows*17;
    }
    */

    // Set path to images
    this.imagePath = imagePath;

    // Set input text
    if ( textareaField.value == "" )
    {
       textareaField.value = " ";
    }
    this.content = textareaField.value;


    // Set HTML page to show, when the table insert function gets called
    this.table = new Array();
    this.table["url"] = indexDir + "/layout/set/dialog/ezdhtml/inserttable/";
    this.table["parameters"] = "dialogWidth:23; dialogHeight:30; scroll:yes; resizable:yes; status:no; help:no;";

    // Set HTML page to show, when a custom tag gets inserted
    this.customTag = new Array();
    this.customTag["url"] = indexDir + "/layout/set/dialog/ezdhtml/insertcustomtag/";
    this.customTag["parameters"] = "dialogWidth:23; dialogHeight:30; scroll:yes; resizable:yes; status:no; help:no;";

    // Set HTML page to show, when a custom tag gets inserted
    this.literalTag = new Array();
    this.literalTag["url"] = indexDir + "/layout/set/dialog/ezdhtml/insertliteral/";
    this.literalTag["parameters"] = "dialogWidth:23; dialogHeight:23; scroll:yes; resizable:yes; status:no; help:no;";

    // Set HTML page to show, when an object gets inserted
    this.customObject = new Array();
    this.customObject["url"] = indexDir + "/layout/set/dialog/ezdhtml/insertobject/" + objectID + "/" + objectVersion + "/";
    this.customObject["parameters"] = "dialogWidth:33; dialogHeight:37; resizable:yes; scroll:yes; status:no; help:no;";

    // Set HTML page to show, when a link gets inserted
    this.customLink = new Array();
    this.customLink["url"] = indexDir +  "/layout/set/dialog/ezdhtml/insertlink/";
    this.customLink["parameters"] = "dialogWidth:28; dialogHeight:37; scroll:yes; resizable:yes; status:no; help:no;";

    // Set HTML page to show, when an anchor gets inserted
    this.customAnchor = new Array();
    this.customAnchor["url"] = indexDir +  "/layout/set/dialog/ezdhtml/insertanchor/";
    this.customAnchor["parameters"] = "dialogWidth:23; dialogHeight:23; scroll:yes; resizable:yes; status:no; help:no;";

    this.customClass = new Array();
    this.customClass["url"] = indexDir +  "/layout/set/dialog/ezdhtml/insertclassattribute/";
    this.customClass["parameters"] = "dialogWidth:23; dialogHeight:23; scroll:yes; resizable:yes; status:no; help:no;";

    this.customTableCell = new Array();
    this.customTableCell["url"] = indexDir +  "/layout/set/dialog/ezdhtml/tablecelledit/";
    this.customTableCell["parameters"] = "dialogWidth:16; dialogHeight:25; scroll:no; resizable:yes; status:no; help:no;";

    this.customHelp = new Array();
    this.customHelp["url"] = indexDir +  "/layout/set/dialog/ezdhtml/help/";
    this.customHelp["parameters"] = "dialogWidth:40; dialogHeight:45; resizable:yes; scroll:yes; status:no; help:no;";

    this.customCharacter = new Array();
    this.customCharacter["url"] = indexDir +  "/layout/set/dialog/ezdhtml/insertcharacter/";
    this.customCharacter["parameters"] = "dialogWidth:27; dialogHeight:20; resizable:yes; scroll:no; status:no; help:no;";

    // Toolbar array
    this.toolbar = new Array();

    this.toolbar.push( { title: textStrings["Undo"], image: "undo.gif", cmdid: DECMD_UNDO,
                         action: "ExecCommand", options: OLECMDEXECOPT_DODEFAULT } );
    this.toolbar.push( { title: textStrings["Redo"], image: "redo.gif", cmdid: DECMD_REDO,
                         action: "ExecCommand", options: OLECMDEXECOPT_DODEFAULT } );
    /*this.toolbar.push( { title: textStrings["Cut"], image: "cut.gif", cmdid: DECMD_CUT,
                         action: "ExecCommand", options: OLECMDEXECOPT_DODEFAULT } );
    this.toolbar.push( { title: textStrings["Copy"], image: "copy.gif", cmdid: DECMD_COPY,
                         action: "ExecCommand", options: OLECMDEXECOPT_DODEFAULT } );
    this.toolbar.push( { title: textStrings["Paste"], image: "paste.gif", cmdid: DECMD_PASTE,
                         action: "ExecCommand", options: OLECMDEXECOPT_DODEFAULT } );*/

    this.toolbar.push( { action: "New Section" } );

    this.toolbar.push( { title: textStrings["Bold"], image: "bold.gif", cmdid: DECMD_BOLD,
                         action: "ExecCommand", options: OLECMDEXECOPT_DODEFAULT } );
    this.toolbar.push( { title: textStrings["Italic"], image: "italic.gif", cmdid: DECMD_ITALIC,
                         action: "ExecCommand", options: OLECMDEXECOPT_DODEFAULT } );

    this.toolbar.push( { action: "New Section" } );

    this.toolbar.push( { title: textStrings["Numbered"], image: "numlist.gif", cmdid: DECMD_ORDERLIST,
                         action: "ExecCommand", options: OLECMDEXECOPT_DODEFAULT } );
    this.toolbar.push( { title: textStrings["BulletList"], image: "bullist.gif", cmdid: DECMD_UNORDERLIST,
                         action: "ExecCommand", options: OLECMDEXECOPT_DODEFAULT } );
    this.toolbar.push( { title: textStrings["DecreaseListIndent"], image: "reduce_indent.gif", cmdid: DECMD_OUTDENT,
                 action: "ExecCommand", options: OLECMDEXECOPT_DODEFAULT } );
    this.toolbar.push( { title: textStrings["IncreaseListIndent"], image: "indent.gif", cmdid: DECMD_INDENT,
                 action: "ExecCommand", options: OLECMDEXECOPT_DODEFAULT } );

    this.toolbar.push( { action: "New Section" } );


    this.toolbar.push( { title: textStrings["InsertObject"], image: "object.gif", cmdid: CUSTOM_INSERTOBJECT,
                         action: "insertObject", options: this.objectRef } );


    this.toolbar.push( { title: textStrings["InsertLink"], image: "link.gif", cmdid: CUSTOM_INSERTLINK,
                         action: "insertLink", options: this.objectRef } );
    this.toolbar.push( { title: textStrings["InsertAnchor"], image: "anchor.gif", cmdid: CUSTOM_INSERTANCHOR,
                         action: "insertAnchor", options: this.objectRef } );
    this.toolbar.push( { title: textStrings["InsertCustomTag"], image: "customtag.gif", cmdid: CUSTOM_INSERTCUSTOMTAG,
                         action: "newCustomTag", options: this.objectRef } );
    this.toolbar.push( { title: textStrings["InsertLiteral"], image: "literal.gif", cmdid: CUSTOM_INSERTLITERAL,
                         action: "insertLiteralText", options: this.objectRef } );
    this.toolbar.push( { title: textStrings["InsertSpecialCharacter"], image: "special.gif", cmdid: CUSTOM_INSERTCHARACTER,
                         action: "insertCharacter", options: this.objectRef } );

    // Table toolbar
    this.toolbar.push( { action: "New Section" } );
    this.toolbar.push( { title: textStrings["InsertTable"], image: "table.gif", cmdid: DECMD_INSERTTABLE,
                         action: "newTable", options: this.objectRef} );
    this.toolbar.push( { title: textStrings["InsertRow"], image: "insrow.gif", cmdid: DECMD_INSERTROW,
                         action: "ExecCommand", options: OLECMDEXECOPT_DODEFAULT } );
    this.toolbar.push( { title: textStrings["InsertColumn"], image: "inscol.gif", cmdid: DECMD_INSERTCOL,
                         action: "ExecCommand", options: OLECMDEXECOPT_DODEFAULT } );
    this.toolbar.push( { title: textStrings["DeleteRow"], image: "delrow.gif", cmdid: DECMD_DELETEROWS,
                         action: "ExecCommand", options: OLECMDEXECOPT_DODEFAULT } );
    this.toolbar.push( { title: textStrings["DeleteColumn"], image: "delcol.gif", cmdid: DECMD_DELETECOLS,
                         action: "ExecCommand", options: OLECMDEXECOPT_DODEFAULT } );
    this.toolbar.push( { title: textStrings["SplitCell"], image: "splitcell.gif", cmdid: DECMD_SPLITCELL,
                         action: "ExecCommand", options: OLECMDEXECOPT_DODEFAULT } );
    this.toolbar.push( { title: textStrings["MergeCell"], image: "mergecell.gif", cmdid: DECMD_MERGECELLS,
                         action: "ExecCommand", options: OLECMDEXECOPT_DODEFAULT } );

    this.toolbar.push( { action: "New Section" } );
    this.toolbar.push( { title: textStrings["Find"], image: "find.gif", cmdid: DECMD_FINDTEXT,
                         action: "ExecCommand", options: OLECMDEXECOPT_DODEFAULT } );
    this.toolbar.push( { title: textStrings["Help"], image: "help.gif", cmdid: CUSTOM_HELP,
                 action: "showHelpWindow", options: OLECMDEXECOPT_DODEFAULT } );
}

/*!
    Create HTML markup for the editor
*/
function startEditor()
{
    var editorHTML = '<script'
                    + ' language="Javascript"'
                    + ' for="' + this.objectRef + '"'
                    //+ ' event="DisplayChanged"'
                    + ' event="onkeyup"'
                    + '>'
                    + '<!-' + '-\n'
                    + '   return eventUpdateStatus("' + this.objectRef  + '");\n'
                    + '// -' + '->\n'
                    + '</script>';

    editorHTML += '<script'
                    + ' language="Javascript"'
                    + ' for="' + this.objectRef + '"'
                    //+ ' event="DisplayChanged"'
                    + ' event="onmouseup"'
                    + '>'
                    + '<!-' + '-\n'
                    + '    return eventUpdateStatus("' + this.objectRef  + '");\n'
                    + '// -' + '->\n'
                    + '</script>';

    editorHTML += '<script'
                    + ' language="Javascript"'
                    + ' for="' + this.objectRef + '"'
                    + ' event="onblur"'
                    + '>'
                    + '<!-' + '-\n'
                    + '    return eventUpdateContent("' + this.objectRef  + '");\n'
                    + '// -' + '->\n'
                    + '</script>';

    editorHTML += '<script'
                    + ' language="Javascript"'
                    + ' for="' + this.objectRef + '"'
                    + ' event="ShowContextMenu"'
                    + '>'
                    + '<!-' + '-\n'
                    + '    return eventShowContextMenu("' + this.objectRef  + '");\n'
                    + '// -' + '->\n'
                    + '</script>';

   editorHTML += '<script'
                    + ' language="Javascript"'
                    + ' for="' + this.objectRef + '"'
                    + ' event="DocumentComplete"'
                    + '>'
                    + '<!-' + '-\n'
                    + '    eventUpdateContent("' + this.objectRef  + '");\n'
                    + '    return setStyleSheet("' + this.objectRef  + '", "' + this.extensionPath  + '");\n'
                    + '// -' + '->\n'
                    + '</script>';

   editorHTML += '<script'
                    + ' language="Javascript"'
                    + ' for="' + this.objectRef + '"'
                    + ' event="ContextMenuAction(itemIndex)"'
                    + '>'
                    + '<!-' + '-\n'
                    + '    return contextMenuAction(itemIndex,' + '"' + this.objectRef  + '");\n'
                    + '// -' + '->\n'
                    + '</script>';

    // Create toolbar HTML
    editorHTML += this.createToolbar();

    // Create ActiveX objects and textarea field
    editorHTML += '<object classid="clsid:2D360201-FFF5-11d1-8D03-00A0C959BC0A"'
                    + ' defval="1001"'
                    + ' id="' + this.objectRef + '"'
                    + ' height="' + this.height + '"'
    //                + ' width="' + this.width + '"'
                    + ' width="100%"'
          //  + ' style="display:toolbar;"'
                    + ' viewastext'
         //   + '<param name=UseDivOnCarriageReturn value=true></object>';
            + '></object>'

                   // Table object for table editing.
                    + '<object'
                    + ' id="' + this.objectRef + 'ObjTableInfo"'
                    + ' classid="clsid:47B0DFC7-B7A3-11D1-ADC5-006008A5848C"'
                    + ' style="'
                    + 'display:none;'
                    + '"'
                    + ' viewastext'
                    + '></object>'

                   // Block formatting (e.g. <h1></h1>)
                    + '<object'
                    + ' id="' + this.objectRef + 'ObjBlockFormatInfo"'
                    + ' classid="clsid:8D91090E-B955-11D1-ADC5-006008A5848C"'
                    + ' style="'
                    + 'display:none;'
                    + '"'
                    + ' viewastext'
                    + '></object>'

                    // Textarea field for sending the form.
                    + '<textarea'
                    + ' name="' + this.fieldName + '"'
                    + ' id="textarea_' + this.objectRef  + '"'
                    + ' style="'
                    + 'display:none;'
                    + '"'
                    + '></textarea>'
                    ;
    // Create statusbar
    editorHTML += this.createStatusbar();

    // overwrite textareafield with our editor
    document.all[this.fieldName].outerHTML = editorHTML;

    // Make the editor object accessible
    var editorControl = document.all[this.objectRef];

    // Initialize the editor control with the supplied content text
    editorControl.DocumentHTML = this.content;

    editorControl.eZPublishVersion = this.eZPublishVersion;

    // Attach toolbar array to the editor control so it can be accessed for updates later
    editorControl.toolbar = this.toolbar;

    // Attach statusbar to the editor control so it can be accessed for updates later
    editorControl.statusbar = this.statusbar;

    // Attach tablePage to editor control
    editorControl.table = this.table;

    // Attach the customObject array to editor control
    editorControl.customObject = this.customObject;

    // Attach the customLink array to editor control
    editorControl.customLink = this.customLink;

    // Attach the customAnchor array to editor control
    editorControl.customAnchor = this.customAnchor;

    // Attach the customTag array to editor control
    editorControl.customTag = this.customTag;

    // Attach the literalTag array to editor control
    editorControl.literalTag = this.literalTag;

    // Attach the customClass array to editor control
    editorControl.customClass = this.customClass;

    // Attach the customTableCell array to editor control
    editorControl.customTableCell = this.customTableCell;

    // Attach the customHelp array to editor control
    editorControl.customHelp = this.customHelp;

    // Attach the customCharacter array to editor control
    editorControl.customCharacter = this.customCharacter;

    // Get the names of the format for different paragraph styles and attach this
    // array to the editor control
    var blockFormatObject = new ActiveXObject( "DEGetBlockFmtNamesParam.DEGetBlockFmtNamesParam" );
    editorControl.ExecCommand( DECMD_GETBLOCKFMTNAMES, OLECMDEXECOPT_DODEFAULT, blockFormatObject);
    editorControl.paragraphStyles = blockFormatObject.Names.toArray();

    // Initialize the context menu arrays.
    DefaultContextMenu[0] = new ContextMenuItem(textStrings["Undo"], DECMD_UNDO);
    DefaultContextMenu[1] = new ContextMenuItem(MENU_SEPARATOR, 0);
    DefaultContextMenu[2] = new ContextMenuItem(textStrings["Cut"], DECMD_CUT);
    DefaultContextMenu[3] = new ContextMenuItem(textStrings["Copy"], DECMD_COPY);
    DefaultContextMenu[4] = new ContextMenuItem(textStrings["Paste"], DECMD_PASTE);
//    DefaultContextMenu[5] = new ContextMenuItem(textStrings["Delete"], DECMD_DELETE);
    DefaultContextMenu[5] = new ContextMenuItem(MENU_SEPARATOR, 0);
    DefaultContextMenu[6] = new ContextMenuItem(textStrings["SelectAll"], DECMD_SELECTALL);

    GeneralContextMenu[0] = new ContextMenuItem(MENU_SEPARATOR, 0);
    GeneralContextMenu[1] = new ContextMenuItem(textStrings["InsertLink"], CUSTOM_INSERTLINK);
    GeneralContextMenu[2] = new ContextMenuItem(textStrings["InsertAnchor"], CUSTOM_INSERTANCHOR);
    GeneralContextMenu[3] = new ContextMenuItem(textStrings["InsertCustomTag"], CUSTOM_INSERTCUSTOMTAG);
    GeneralContextMenu[4] = new ContextMenuItem(textStrings["Properties"], CUSTOM_INSERTCUSTOMCLASS);

    HeaderContextMenu[0] = new ContextMenuItem(MENU_SEPARATOR, 0);
    HeaderContextMenu[1] = new ContextMenuItem(textStrings["InsertAnchor"], CUSTOM_INSERTANCHOR);
    HeaderContextMenu[2] = new ContextMenuItem(textStrings["Properties"], CUSTOM_INSERTCUSTOMCLASS);

    ParagraphContextMenu[0] = new ContextMenuItem(MENU_SEPARATOR, 0);
    ParagraphContextMenu[1] = new ContextMenuItem(textStrings["InsertObject"], CUSTOM_INSERTOBJECT);
    ParagraphContextMenu[2] = new ContextMenuItem(textStrings["InsertTable"], CUSTOM_INSERTTABLE);
    ParagraphContextMenu[3] = new ContextMenuItem(textStrings["InsertLink"], CUSTOM_INSERTLINK);
    ParagraphContextMenu[4] = new ContextMenuItem(textStrings["InsertAnchor"], CUSTOM_INSERTANCHOR);
    ParagraphContextMenu[5] = new ContextMenuItem(textStrings["InsertCustomTag"], CUSTOM_INSERTCUSTOMTAG);
    ParagraphContextMenu[6] = new ContextMenuItem(textStrings["InsertLiteral"], CUSTOM_INSERTLITERAL);
    ParagraphContextMenu[7] = new ContextMenuItem(textStrings["Properties"], CUSTOM_INSERTCUSTOMCLASS);

    ImageContextMenu[0] = new ContextMenuItem(textStrings["Cut"], DECMD_CUT);
    ImageContextMenu[1] = new ContextMenuItem(textStrings["Copy"], DECMD_COPY);
    ImageContextMenu[2] = new ContextMenuItem(textStrings["Delete"], DECMD_DELETE);
    ImageContextMenu[3] = new ContextMenuItem(textStrings["Properties"], CUSTOM_INSERTOBJECT);

    LinkContextMenu[0] = new ContextMenuItem(MENU_SEPARATOR, 0);
    LinkContextMenu[1] = new ContextMenuItem(textStrings["RemoveLink"], DECMD_UNLINK);
    LinkContextMenu[2] = new ContextMenuItem(textStrings["LinkProperties"], CUSTOM_INSERTLINK);

    InsertLinkContextMenu[0] = new ContextMenuItem(MENU_SEPARATOR, 0);
    InsertLinkContextMenu[1] = new ContextMenuItem(textStrings["InsertLink"], CUSTOM_INSERTLINK);

    LiteralContextMenu[0] = new ContextMenuItem(textStrings["Cut"], DECMD_CUT);
    LiteralContextMenu[1] = new ContextMenuItem(textStrings["Copy"], DECMD_COPY);
    LiteralContextMenu[2] = new ContextMenuItem(textStrings["Delete"], DECMD_DELETE);
    LiteralContextMenu[3] = new ContextMenuItem(textStrings["Properties"], CUSTOM_INSERTLITERAL);
    //LiteralContextMenu[4] = new ContextMenuItem(textStrings["RemoveLink"], CUSTOM_REMOVELINK);

    LiteralTextContextMenu[0] = new ContextMenuItem(textStrings["Undo"], DECMD_UNDO);
    LiteralTextContextMenu[1] = new ContextMenuItem(MENU_SEPARATOR, 0);
    LiteralTextContextMenu[2] = new ContextMenuItem(textStrings["Cut"], DECMD_CUT);
    LiteralTextContextMenu[3] = new ContextMenuItem(textStrings["Copy"], DECMD_COPY);
    LiteralTextContextMenu[4] = new ContextMenuItem(textStrings["Paste"], DECMD_PASTE);
//    LiteralTextContextMenu[5] = new ContextMenuItem(textStrings["Delete"], DECMD_DELETE);
    LiteralTextContextMenu[5] = new ContextMenuItem(MENU_SEPARATOR, 0);
    LiteralTextContextMenu[6] = new ContextMenuItem(textStrings["SelectAll"], DECMD_SELECTALL);

    CustomContextMenu[0] = new ContextMenuItem(textStrings["Cut"], DECMD_CUT);
    CustomContextMenu[1] = new ContextMenuItem(textStrings["Copy"], DECMD_COPY);
    CustomContextMenu[2] = new ContextMenuItem(textStrings["Delete"], DECMD_DELETE);
    CustomContextMenu[3] = new ContextMenuItem(textStrings["Properties"], CUSTOM_CUSTOMTAGPROPERTIES);

    AnchorContextMenu[0] = new ContextMenuItem(textStrings["Cut"], DECMD_CUT);
    AnchorContextMenu[1] = new ContextMenuItem(textStrings["Copy"], DECMD_COPY);
    AnchorContextMenu[2] = new ContextMenuItem(textStrings["Delete"], DECMD_DELETE);
    AnchorContextMenu[3] = new ContextMenuItem(textStrings["Properties"], CUSTOM_INSERTANCHOR);

    TableContextMenu[0] = new ContextMenuItem(MENU_SEPARATOR, 0);
    TableContextMenu[1] = new ContextMenuItem(textStrings["InsertRow"], DECMD_INSERTROW);
    TableContextMenu[2] = new ContextMenuItem(textStrings["DeleteRow"], DECMD_DELETEROWS);
    TableContextMenu[3] = new ContextMenuItem(MENU_SEPARATOR, 0);
    TableContextMenu[4] = new ContextMenuItem(textStrings["InsertColumn"], DECMD_INSERTCOL);
    TableContextMenu[5] = new ContextMenuItem(textStrings["DeleteColumn"], DECMD_DELETECOLS);
    TableContextMenu[6] = new ContextMenuItem(MENU_SEPARATOR, 0);
    TableContextMenu[7] = new ContextMenuItem(textStrings["MergeCells"], DECMD_MERGECELLS);
    TableContextMenu[8] = new ContextMenuItem(textStrings["MergeDown"], CUSTOM_MERGEDOWN);
    TableContextMenu[9] = new ContextMenuItem(textStrings["SplitCell"], DECMD_SPLITCELL);
    TableContextMenu[10] = new ContextMenuItem(MENU_SEPARATOR, 0);
    TableContextMenu[11] = new ContextMenuItem( "TH", CUSTOM_SETTH );
    TableContextMenu[12] = new ContextMenuItem(textStrings["CellProperties"], CUSTOM_CELLPROPERTIES);
    TableContextMenu[13] = new ContextMenuItem(textStrings["TableProperties"], CUSTOM_TABLEPROPERTIES);

    TablePropertyContextMenu[0] = new ContextMenuItem(textStrings["Cut"], DECMD_CUT);
    TablePropertyContextMenu[1] = new ContextMenuItem(textStrings["Copy"], DECMD_COPY);
    TablePropertyContextMenu[2] = new ContextMenuItem(textStrings["Delete"], DECMD_DELETE);
    TablePropertyContextMenu[3] = new ContextMenuItem(textStrings["Properties"], CUSTOM_TABLEPROPERTIES);
}

// Constructor for custom object that represents an item on the context menu
function ContextMenuItem(string, cmdId) {
    this.string = string;
    this.cmdId = cmdId;
}

function setStyleSheet( objectRef, extensionPath )
{
    var editorControl = document.all[objectRef];
    if ( editorControl.DOM.styleSheets.length==0 )
    {
        var serverAddress = location.protocol + "//" + location.host;
        for( var i=0; i < EditorCSSFileList.length; i++ )
        {
            var editorCSS = serverAddress + EditorCSSFileList[i];
            editorControl.DOM.createStyleSheet( editorCSS );
        }
    }
}

function eventShowContextMenu( objectRef )
{
    var editorControl = document.all[objectRef];
    var menuStrings = new Array();
    var menuStates = new Array();
    var state;
    var i;
    var index = 0;
    var parentTag = "";
    var currentObject = "";

    var tableEditEnabled = checkTableEditStatus( editorControl );

    var selection = editorControl.DOM.selection;
    var selectionRange = selection.createRange();

    var textSelected = isTextSelected( editorControl );

    if ( selectionRange.length == 1 )
    {
        parentTag = selectionRange.item(0).tagName;
        if ( parentTag == "TABLE" )
        {
           var tableID =  selectionRange.item(0).getAttribute( 'id' );
           if ( tableID == "" )
                tableID = "table";
        }

        if ( parentTag == "IMG" )
        {
           var imageType =  selectionRange.item(0).getAttribute( 'type' );
           if ( imageType == null )
                imageType = "object";
        }
    }
    else
    {
        current = selectionRange.parentElement();
        if ( current.tagName == "A" )
        {
            selectionRange.moveToElementText( current );
            selectionRange.select();
            parentTag = "a";
        }

        if ( current.tagName == "P" ||
             current.tagName == "TD" ||
             current.tagName == "TH" )
        {
            parentTag = "p";
        }

        if ( current.tagName == "H1" ||
             current.tagName == "H2" ||
             current.tagName == "H3" ||
             current.tagName == "H4" ||
             current.tagName == "H5" ||
             current.tagName == "H6" )
        {
            parentTag = "header";
        }

        if ( current.tagName == 'SPAN' && current.getAttribute( 'type' ) == 'custom' )
        {
            parentTag = "custom";
        }

        tableObject = getElement( selectionRange.parentElement(),"TABLE" );
        if ( tableObject )
        {
            var tableID = tableObject.getAttribute( 'id' );
            if ( tableID == "literal" )
                parentTag = "literal";
            if ( tableID == "custom" )
                parentTag = "custom";
            if ( tableID == "" )
                tableID = "table";
        }
    }
    // Rebuild the context menu.
    ContextMenu.length = 0;

    // If the selection is inside a table, use table context menu.
    if ( editorControl.QueryStatus( DECMD_INSERTROW ) != DECMDF_DISABLED &&
         tableEditEnabled )
    {
        for ( i=0; i<DefaultContextMenu.length; i++ )
        {
            ContextMenu[index++] = DefaultContextMenu[i];
        }

        if ( tableID == 'table' )
        {
            for ( i=0; i<TableContextMenu.length; i++ )
            {
               ContextMenu[index++] = TableContextMenu[i];
            }
        }
        if ( parentTag == "p" )
        {
            // Add paragraph context menu if parent tag is paragraph
            for ( i=0; i<ParagraphContextMenu.length; i++ )
            {
                ContextMenu[index++] = ParagraphContextMenu[i];
            }
        }
        else if ( parentTag == "header" )
        {
            // Add header context menu.
            for ( i=0; i<HeaderContextMenu.length; i++ )
            {
                ContextMenu[index++] = HeaderContextMenu[i];
            }
        }
        else if ( parentTag == "custom" )
        {
            for ( i=0; i<CustomContextMenu.length; i++ )
            {
                ContextMenu[index++] = CustomContextMenu[i];
            }
        }
        else if ( parentTag == "a" )
        {
                // do nothing.
        }
        else
        {
            for ( i=0; i<GeneralContextMenu.length; i++ )
            {
                ContextMenu[index++] = GeneralContextMenu[i];
            }
        }
    }
    else if ( imageType == "object" )
    {
    // Use the image menu
        for ( i=0; i<ImageContextMenu.length; i++ )
        {
            ContextMenu[index++] = ImageContextMenu[i];
        }
    }
    else if ( imageType == "anchor" )
    {
    // Use anchor context menu if selected object is an anchor tag.
        for ( i=0; i<AnchorContextMenu.length; i++ )
        {
            ContextMenu[index++] = AnchorContextMenu[i];
        }
    }
    else if ( parentTag == "literal" )
    {
    // Use literal text context menu.
        for ( i=0; i<LiteralTextContextMenu.length; i++ )
        {
            ContextMenu[index++] = LiteralTextContextMenu[i];
        }
    }
    else if ( tableID == "custom" || imageType == "custom" || parentTag == "custom" )
    {
        // Use custom context menu if selected object is a custom tag.
        for ( i=0; i<CustomContextMenu.length; i++ )
        {
            ContextMenu[index++] = CustomContextMenu[i];
        }
    }
    else if ( tableID == "table" )
    {
        // Use table property menu if selected object is table.
        for ( i=0; i<TablePropertyContextMenu.length; i++ )
        {
            ContextMenu[index++] = TablePropertyContextMenu[i];
        }
    }
    else if ( tableID == "literal" )
    {
    // Use literal context menu if selected object is literal.
        for ( i=0; i<LiteralContextMenu.length; i++ )
        {
            ContextMenu[index++] = LiteralContextMenu[i];
        }
    }
    else if ( textSelected )
    {
        for ( i=0; i<DefaultContextMenu.length; i++ )
        {
            ContextMenu[index++] = DefaultContextMenu[i];
        }
        if ( parentTag == "a" )
        {
                // do nothing
        }
        else
        {
            for ( i=0; i<InsertLinkContextMenu.length; i++ )
            {
                ContextMenu[index++] = InsertLinkContextMenu[i];
            }
        }

    }
    else if ( parentTag == "p" )
    {
        for ( i=0; i<DefaultContextMenu.length; i++ )
        {
            ContextMenu[index++] = DefaultContextMenu[i];
        }
        // Add paragraph context menu if parent tag is paragraph
            for ( i=0; i<ParagraphContextMenu.length; i++ )
        {
            ContextMenu[index++] = ParagraphContextMenu[i];
        }
    }
    else if ( parentTag == "header" )
    {
        for ( i=0; i<DefaultContextMenu.length; i++ )
        {
            ContextMenu[index++] = DefaultContextMenu[i];
        }
    // Add header context menu.
        for ( i=0; i<HeaderContextMenu.length; i++ )
        {
            ContextMenu[index++] = HeaderContextMenu[i];
        }
    }
    else if ( parentTag == "a" )
    {
        // Add default context menu.
        for ( i=0; i<DefaultContextMenu.length; i++ )
        {
            ContextMenu[index++] = DefaultContextMenu[i];
        }
    }
    else
    {
        // Use the general menu
        for ( i=0; i<DefaultContextMenu.length; i++ )
        {
            ContextMenu[index++] = DefaultContextMenu[i];
        }
        for ( i=0; i<GeneralContextMenu.length; i++ )
        {
            ContextMenu[index++] = GeneralContextMenu[i];
        }
    }

    // Add link context menu if selected text is a link
    if ( parentTag == "a" )
    {
        for ( i=0; i<LinkContextMenu.length; i++ )
        {
            ContextMenu[index++] = LinkContextMenu[i];
        }
    }

    // Add link context menu if selected image is a link
    if ( parentTag == "IMG" && imageType == "object" )
    {
        if ( selectionRange.item(0).parentElement.tagName == "A" )
        {
            for ( i=0; i<LinkContextMenu.length; i++ )
            {
                ContextMenu[index++] = LinkContextMenu[i];
            }
        }
        else
        {
            var objectSrc = selectionRange.item(0).src;
            if ( !objectSrc.match(/object_insert/g) )
                ContextMenu[index++] = GeneralContextMenu[1];
        }
    }

    // Set up the actual arrays that get passed to SetContextMenu
    for ( i=0; i<ContextMenu.length; i++)
    {
        menuStrings[i] = ContextMenu[i].string;
        if ( menuStrings[i] != MENU_SEPARATOR &&
             menuStrings[i] != textStrings["Properties"] &&
             menuStrings[i] != textStrings["LinkProperties"] &&
             menuStrings[i] != textStrings["InsertObject"] &&
             menuStrings[i] != textStrings["InsertTable"] &&
             menuStrings[i] != textStrings["InsertLink"] &&
             menuStrings[i] != textStrings["InsertAnchor"] &&
             menuStrings[i] != textStrings["InsertCustomTag"] &&
             menuStrings[i] != textStrings["InsertLiteral"] &&
             menuStrings[i] != textStrings["CellProperties"] &&
             menuStrings[i] != textStrings["MergeDown"] &&
             menuStrings[i] != textStrings["RemoveLink"] &&
             menuStrings[i] != textStrings["TableProperties"] &&
             menuStrings[i] != "TH" )
        {
            state = editorControl.QueryStatus( ContextMenu[i].cmdId );
        }
        else
        {
            state = DECMDF_ENABLED;
        }

        if ( state == DECMDF_DISABLED || state == DECMDF_NOTSUPPORTED )
        {
            menuStates[i] = OLE_TRISTATE_GRAY;
        }
        else if ( state == DECMDF_ENABLED || state == DECMDF_NINCHED )
        {
            menuStates[i] = OLE_TRISTATE_UNCHECKED;
        }
        else
        {
            menuStates[i] = OLE_TRISTATE_CHECKED;
        }

        if ( menuStrings[i] == "TH" )
        {
            isTableHead = isTH( editorControl );
            if ( isTableHead )
                menuStates[i] = OLE_TRISTATE_CHECKED;
        }
    }

    // Set the context menu
    editorControl.SetContextMenu( menuStrings, menuStates );
}

function contextMenuAction( itemIndex,objectRef )
{
    var editorControl = document.all[objectRef];
    if ( ContextMenu[itemIndex].cmdId == CUSTOM_INSERTOBJECT )
    {
       insertObject( objectRef, -1, objectRef );
    }
    else if ( ContextMenu[itemIndex].cmdId == CUSTOM_INSERTLINK )
    {
       insertLink( objectRef, -1, objectRef );
    }
    else if ( ContextMenu[itemIndex].cmdId == CUSTOM_INSERTTABLE )
    {
       insertTable( objectRef, 1 );
    }
    else if ( ContextMenu[itemIndex].cmdId == CUSTOM_INSERTLITERAL )
    {
       insertLiteralText( objectRef, -1, objectRef );
    }
    else if ( ContextMenu[itemIndex].cmdId == CUSTOM_INSERTCUSTOMTAG )
    {
       insertCustomTag( objectRef, 1 );
    }
    else if ( ContextMenu[itemIndex].cmdId == CUSTOM_CUSTOMTAGPROPERTIES )
    {
       insertCustomTag( objectRef, 0 );
    }
    else if ( ContextMenu[itemIndex].cmdId == CUSTOM_INSERTANCHOR )
    {
       insertAnchor( objectRef, -1, objectRef );
    }
    else if ( ContextMenu[itemIndex].cmdId == CUSTOM_INSERTCUSTOMCLASS )
    {
       showClassDialog( objectRef, -1, objectRef );
    }
    else if ( ContextMenu[itemIndex].cmdId == CUSTOM_CELLPROPERTIES )
    {
       showTableCellProperty( objectRef, -1, objectRef );
    }
    else if ( ContextMenu[itemIndex].cmdId == CUSTOM_TABLEPROPERTIES )
    {
       insertTable( objectRef, 0 );
    }
    else if ( ContextMenu[itemIndex].cmdId == CUSTOM_SETTH )
    {
       isTableHead = isTH( editorControl );
       if ( isTableHead )
           setAsTD( editorControl );
       else
           setAsTH( editorControl );
    }
    else if ( ContextMenu[itemIndex].cmdId == CUSTOM_MERGEDOWN )
    {
        mergeDown( editorControl );
    }
    else if ( ContextMenu[itemIndex].cmdId == CUSTOM_REMOVELINK )
    {
        removeLink( editorControl );
    }
    else
      editorControl.ExecCommand(ContextMenu[itemIndex].cmdId, OLECMDEXECOPT_DODEFAULT);
      eventUpdateContent( objectRef );
}

/*!
    Create the toolbar of the editor
*/
function createToolbar()
{
    // Header for toolbar
    var toolbarTags = '<table'
    //                + ' width="' + this.width + '"'
     + ' width="100%"'
                    + ' cellpadding="0"'
                    + ' cellspacing="0"'
                    + ' border="0"'
                    + ' class="toolbar"'
                    + ' unselectable="on"'
                    + '>'
                    + '<tr>'
                    + '    <td>';

    // Define HTML for a separator between groups of icons
    var toolbarSectionStart = '<table'
                            + ' border="0"'
                            + ' cellspacing="1"'
                            + ' cellpadding="0"'
                            + ' class="toolbarSection"'
                            + ' style="float:left;"'
                            + ' unselectable="on"'
                            + '>'
                            + '<tr>'
                            + '<td style="border:inset 1px;">'
    var toolbarSectionStop = '</td></tr></table>';

    // Loop over all toolbar items and create entries
    toolbarTags += toolbarSectionStart;
    toolbarTags += "<select id='" + this.objectRef + "_select_header' onChange=changeHeading('" + this.objectRef + "')>"
        + "   <option value='normal' selected>"+textStrings["Normal"]+"</option>\n"
        + "   <option value='Heading 1'>"+textStrings["Heading1"]+"</option>"
        + "   <option value='Heading 2'>"+textStrings["Heading2"]+"</option>"
        + "   <option value='Heading 3'>"+textStrings["Heading3"]+"</option>"
        + "   <option value='Heading 4'>"+textStrings["Heading4"]+"</option>"
        + "   <option value='Heading 5'>"+textStrings["Heading5"]+"</option>"
        + "   <option value='Heading 6'>"+textStrings["Heading6"]+"</option>"
        + "   </select>";
    for ( i=0; i < this.toolbar.length; i++ )
    {
        if ( this.toolbar[i]["action"] == "New Section" )
        {
            toolbarTags += toolbarSectionStop;
            toolbarTags += toolbarSectionStart;
        }
        else
        {
            // Create command string for onclick action
            if ( this.toolbar[i]["action"] != "ExecCommand" )
            {
                var execCommand = this.toolbar[i]["action"] + "("
                                + "'" + this.objectRef + "'"
                                + "," + this.toolbar[i]["cmdid"]
                                + ",'" + this.toolbar[i]["options"] + "'"
                                + ");";
            }
            else
            {
                var execCommand = this.objectRef + "." + this.toolbar[i]["action"]
                                + "(" + this.toolbar[i]["cmdid"]
                                + "," + this.toolbar[i]["options"] + ");";
            }

            execCommand = "if ( this.style.filter == '' ) " + execCommand + " eventUpdateContent('" + this.objectRef + "');";

            // Create the button
            // (buttons have the advantage over just images that they don't take the focus!)
            toolbarTags += '<button'
                            + ' id="' + this.objectRef + this.toolbar[i]["cmdid"] + '"'
                            + ' onclick="' + execCommand + '"'
                + ' onmouseover=toolbarButtonOver("' + this.objectRef + this.toolbar[i]["cmdid"] + '");'
                + ' onmouseout=toolbarButtonOut("' + this.objectRef + this.toolbar[i]["cmdid"] + '");'
                            + ' title="' + this.toolbar[i]["title"] + '"'
                            + ' unselectable="on"'
                            + ' class="toolbarButton"'
                            + '>'
                            + '<img'
                            + ' src="' + this.imagePath + this.toolbar[i]["image"] + '"'
                            + ' width="16"'
                            + ' height="16"'
                            + ' align="absmiddle"'
                            + ' />'
                            + '</button>';
          }
    }
    toolbarTags += toolbarSectionStop;

    // Footer for toolbar
    toolbarTags += "</td></tr></table>";

    // Return the finished HTML for the toolbar
    return toolbarTags;
}

function toolbarButtonOver( buttonID )
{
    var button = document.all[buttonID];
    if ( button.style.filter == "" )
    {
        if ( button.className == "toolbarButtonSelected" )
            button.className = "toolbarButtonOverSelected";
        else if ( button.className != "toolbarButtonOver" )
            button.className = "toolbarButtonOver";
    }

    if ( button.title == textStrings["InsertLink"] || button.title == textStrings["MakeLink"] )
    {
        var editorID = buttonID.replace( "-3", "" );
          var editorControl = document.all[editorID];
        var selection = editorControl.DOM.selection;
        var selectionRange = selection.createRange();
        if ( selectionRange.length == 1 )
        {
            button.title = textStrings["MakeLink"];
        }
        else if ( selectionRange.length != 1 && selectionRange.text != "" )
        {
            button.title = textStrings["MakeLink"];
        }
        else
        {
              button.title = textStrings["InsertLink"];
        }
    }
}

function toolbarButtonOut( buttonID )
{
    var button = document.all[buttonID];
    if ( button.className == "toolbarButtonOverSelected" ||  button.className == "toolbarButtonSelected" )
        button.className = "toolbarButtonSelected";
    else if ( button.className != "toolbarButtonOut" )
        button.className = "toolbarButtonOut";
}

/*!
    Create the statusbar of the editor
*/
function createStatusbar()
{
   var statusbarTags = '<table'
//            + ' width="' + this.width + '"'
                      + ' width="100%"'
              + ' border="1"'
              + ' cellpadding="0"'
              + ' cellspacing="0"'
              + ' class="statusbar">'
              + ' <tr><td colspan="3"'
              + ' id="statusbar_' + this.objectRef  + '" class="statusbarTD">'
              + ' &nbsp;</td></tr>'
              + ' <td id="statusbar_info_' + this.objectRef + '"'
              + ' width="190" align="center" class="statusbarTD">'
              + ' </td>'
              + ' <td id="statusbar_class_' + this.objectRef + '"'
              + ' width="110" align="center" class="statusbarTD">'
              + ' ' + textStrings["ClassNone"]
              + '</td>'
              + '<td width="120" align="right" class="editorName"><img src="'
              + this.imagePath + 'ezicon.gif" align="bottom">Online editor ' + this.OEVersion + '</td></tr></table>';

    // Return the finished HTML for the statusbar
    return statusbarTags;
}

/*!
    Gets called when the editor changed and updates textarea field.
*/
function eventUpdateStatus( objectRef )
{
    try
    {
        updateToolbar( objectRef );
    }
    catch( errorObject )
    {
      alert( "Update toolbar error" );
    }

    // Update statusbar
    try
    {
        updateStatusbar( objectRef );
    }
    catch( errorObject )
    {
      alert( "Update statusbar error" );
    }
}

function eventUpdateContent( objectRef )
{
    var editorControl = document.all[objectRef];
    var editorControlText = document.all["textarea_" + objectRef];

    // Update textarea field with new values
    try
    {
        editorControlText.value = editorControl.DOM.body.innerHTML;
    }
    catch( errorObject )
    {
     //alert( "Update content error" );
    }
}

/*!
    Disable table editing if inside block custom tag or literal tag.
*/
function checkTableEditStatus( editorControl )
{
    var tableEditEnabled = true;
    // Get the selected text
    var selection = editorControl.DOM.selection;
    var selectionRange = selection.createRange();

    if ( selectionRange.length != 1 )
    {
        var tableObject = getElement( selectionRange.parentElement(), "TABLE" );
        if ( tableObject != null )
        {
            if ( tableObject.id == "custom" || tableObject.id == "literal" )
            {
                tableEditEnabled = false;
            }
        }
    }
    return tableEditEnabled;
}

function checkTableType( editorControl )
{
    var tableType = "table";
    var table = null;
    // Get the selected text
    var selection = editorControl.DOM.selection;
    var selectionRange = selection.createRange();
    if ( selectionRange.length != 1 )
    {
        table = getElement( selectionRange.parentElement(), "TABLE" );
    }

    if ( selectionRange.length == 1 )
    {
        if ( selectionRange.item(0).tagName == "TABLE" )
        {
            table = selectionRange.item(0);
        }
    }

    if ( table )
    {
        if ( table.getAttribute( 'id' ) == "custom" )
        {
            tableType = "customTag";
        }
        else if ( table.getAttribute( 'id' ) == "literal" )
        {
            tableType = "literalTag";
        }
        else
        {
            tableType = "table";
        }
    }
    return tableType;
}

function isTextSelected( editorControl )
{
    var textSelected = false;
    // Get the selected text
    var selection = editorControl.DOM.selection;
    var selectionRange = selection.createRange();
    if ( selectionRange.length != 1 )
    {
        if ( selectionRange.text != "" )
        textSelected = true;
    }
    return textSelected;
}

function mergeDown ( editorControl )
{
    // Get the selected text
    var selection = editorControl.DOM.selection;
    var selectionRange = selection.createRange();

    if ( selectionRange.length != 1 )
    {
        var tdElement = getElement( selectionRange.parentElement(),"TD" )

    if ( tdElement != null )
    {
        var trElement = getElement( selectionRange.parentElement(),"TR" );
        var tableElement = getElement( selectionRange.parentElement(),"TABLE" );
        var rowE = tableElement.rows;
            var cellIndex = tdElement.cellIndex;
        var rowIndex = trElement.rowIndex;
        var cellText = tdElement.innerText;
        var cells = rowE[(rowIndex+1)].cells;
        var mergedCellText = cellText + cells[cellIndex].innerText;
        tdElement.setAttribute( "rowSpan", 2 );
        tdElement.innerText = mergedCellText;
        rowE[(rowIndex+1)].removeChild( cells[cellIndex] );
    }
    }
}

function removeLink( editorControl )
{
    editorControl.ExecCommand( DECMD_UNLINK, OLECMDEXECOPT_DODEFAULT);
}


function setAsTH ( editorControl )
{
    // Get the selected text
    var selection = editorControl.DOM.selection;
    var selectionRange = selection.createRange();

    if ( selectionRange.length != 1 )
    {
        var tdObject = getElement( selectionRange.parentElement(),"TD" )

    if ( tdObject != null )
    {
        var tdContent = tdObject.innerHTML;
        var width = tdObject.getAttribute( 'width' );
        var colSpan = tdObject.getAttribute( 'colSpan' );
        var rowSpan = tdObject.getAttribute( 'rowSpan' );
        var thNode = editorControl.DOM.createElement("TH");
        tdObject.replaceNode( thNode );
        thNode.innerHTML = tdContent;
        thNode.setAttribute( 'width', width );
        thNode.setAttribute( 'colSpan', colSpan );
        thNode.setAttribute( 'rowSpan', rowSpan );
    }
    }
}

function setAsTD ( editorControl )
{
    // Get the selected text
    var selection = editorControl.DOM.selection;
    var selectionRange = selection.createRange();

    if ( selectionRange.length != 1 )
    {
        var thObject = getElement( selectionRange.parentElement(),"TH" )

    if ( thObject != null )
    {
        var thContent = thObject.innerHTML;
        var width = thObject.getAttribute( 'width' );
        var colSpan = thObject.getAttribute( 'colSpan' );
        var rowSpan = thObject.getAttribute( 'rowSpan' );
        var tdNode = editorControl.DOM.createElement("TD");
        thObject.replaceNode( tdNode );
        tdNode.innerHTML = thContent;
        tdNode.setAttribute( 'width', width );
        tdNode.setAttribute( 'colSpan', colSpan );
        tdNode.setAttribute( 'rowSpan', rowSpan );
    }
    }
}

function isTH ( editorControl )
{
    // Get the selected text
    var selection = editorControl.DOM.selection;
    var selectionRange = selection.createRange();

    var isTH = false;
    if ( selectionRange.length != 1 )
    {
        var thObject = getElement( selectionRange.parentElement(),"TH" )

    if ( thObject != null )
    {
        isTH = true;
    }
    }
    return isTH;
}

/*!
    Updates the statusbar
*/
function updateStatusbar( objectRef )
{
    var editorControl = document.all[objectRef];
    var statusbar = document.all['statusbar_' + objectRef];
    var classInfo = document.all['statusbar_class_' + objectRef];
    var additionalInfo = document.all['statusbar_info_' + objectRef];
    var status = " ";
    var parentTag = "";
    var tagClass = "";
    var contentInfo = " ";

    // Get the selected text
    var selection = editorControl.DOM.selection;
    var selectionRange = selection.createRange();

    if ( selectionRange.length == 1 )
    {
        parentTagList = getParentTagList( selectionRange.item(0), editorControl );
        currentTag = selectionRange.item(0);

        if ( currentTag.tagName == 'TABLE' )
            tagClass = currentTag.getAttribute( 'title' );
        else
            tagClass = currentTag.className;
        tagID = currentTag.getAttribute( 'id' );
        if ( tagID != null )
        {
            if ( tagID.match(/eZObject_/g ) )
             contentInfo = tagID.replace( "eZObject_", "ezobject://" );

            if ( tagID.match(/eZNode_/g ) )
             contentInfo = tagID.replace( "eZNode_", "eznode://" );
        }
        if ( currentTag.nodeName == 'IMG' )
        {
            imageType = currentTag.getAttribute( 'type' );
            if ( imageType == 'custom' )
            {
                value = currentTag.getAttribute( 'value' );
                if ( value.length > 40 )
                    value = value.substr( 0, 40 ) + '...';

                contentInfo = currentTag.getAttribute( 'name' ) + ' : "' + value + '"';
            }
        }
    }
    else
    {
        currentTag = selectionRange.parentElement();
        parentTagList = getParentTagList( currentTag, editorControl );

        if ( currentTag.tagName == "LI" )
            tagClass = currentTag.parentElement.className;
        else
        {
            if ( currentTag.tagName == 'TD' )
            {
                var table = currentTag.parentElement.parentElement.parentElement;
                if ( table && table.tagName == 'TABLE' && table.getAttribute( 'id' ) == 'literal' )
                    tagClass = table.getAttribute( 'title' );
                else
                    tagClass = currentTag.className;
            }
            else
                tagClass = currentTag.className;
        }
        if ( currentTag.tagName == "A" )
            contentInfo = currentTag.getAttribute( 'href' );
    }

    for ( var i=(parentTagList.length-1);i>=0;i-- )
    {
        var tagName = parentTagList[i].toLowerCase();
        switch ( tagName )
        {
            case 'span':
            {
                status += "<custom> ";
                break;
            }
            case 'strong':
            {
                status += "<b> ";
                break;
            }
            case 'em':
            {
                status += "<i> ";
                break;
            }
            case 'ul':
            case 'ol':
            {
                if ( i != parentTagList.length-1 )
                {
                    if ( parentTagList[i+1].toLowerCase() == "ul" ||  parentTagList[i+1].toLowerCase() == "ol" )
                    {
                         status += "<li> ";
                    }
                }
                status += "<ol> ";
                break;
            }
            case 'tbody':
                break;
            default:
            {
                status += "<";
                status += tagName;
                status += "> ";
            }
        }
    }
    additionalInfo.innerText = contentInfo;
    statusbar.innerText = status;

    /*/ Debug mode:
    editorHtml = editorControl.DOM.body.innerHTML;
    var re = /</g;
    statusbar.innerHTML = editorHtml.replace( re, '&lt;' );
    */
    if ( currentTag.tagName == 'SPAN' )
    {
        classInfo.innerText = textStrings["Class"] + currentTag.getAttribute( 'name' );
    }
    else
    {
        if ( tagClass != "" && tagClass != null )
            classInfo.innerText = textStrings["Class"] + tagClass;
        else
            classInfo.innerText = textStrings["ClassNone"];
    }
}

function getParentByName( editorControl, parentName )
{
    var selection = editorControl.DOM.selection;
    var selectionRange = selection.createRange();
    var parent = null;

    if ( selection.type != 'Control' )
        parent = selectionRange.parentElement();
    else
        parent = selectionRange.commonParentElement();

    return getElement( parent, parentName );
}

/*!
    Updates the buttons of the toolbar
*/

function updateToolbar( objectRef )
{
    var editorControl = document.all[objectRef];
    tableID = checkTableType( editorControl );
    var textSelected = false;
    textSelected = isTextSelected( editorControl );

    var isList = getParentByName ( editorControl , 'LI' ) != null;

    // Get the current format of the paragraph
    var blockFormatNow = editorControl.ExecCommand( DECMD_GETBLOCKFMT, OLECMDEXECOPT_DODEFAULT );
    var selectorName = objectRef + "_select_header";
    var button_obj = document.all[selectorName];

    var isHeading = true;

    if ( blockFormatNow.match( 1 ) )
        button_obj.selectedIndex = 1;
    else if ( blockFormatNow.match( 2 ) )
        button_obj.selectedIndex = 2;
    else if ( blockFormatNow.match( 3 ) )
        button_obj.selectedIndex = 3;
    else if ( blockFormatNow.match( 4 ) )
        button_obj.selectedIndex = 4;
    else if ( blockFormatNow.match( 5 ) )
        button_obj.selectedIndex = 5;
    else if ( blockFormatNow.match( 6 ) )
        button_obj.selectedIndex = 6;
    else
    {
        button_obj.selectedIndex = 0;
          isHeading = false;
    }

    for( var i=0; i < editorControl.toolbar.length; i++ )
    {
        var cmdID = editorControl.toolbar[i]["cmdid"];
        var buttonControl = document.all[editorControl.id+cmdID];
        switch ( editorControl.toolbar[i]["action"] )
        {
            // Normal MS DHTML commands
            case "ExecCommand":
            {
                // Get status of button
                var cmdStatus = editorControl.QueryStatus( cmdID );

                if ( cmdStatus == DECMDF_DISABLED || cmdStatus == DECMDF_NOTSUPPORTED )
                {
                    // disabled
                    buttonState( buttonControl, false, false );
                }
                else if ( cmdStatus == DECMDF_ENABLED || cmdStatus == DECMDF_NINCHED )
                {
                    if ( cmdID == DECMD_INDENT || cmdID == DECMD_OUTDENT )
                    {
                       if ( !isList )
                           buttonState( buttonControl, false, false );
                       else
                           buttonState( buttonControl, true, false );
                    }
                    else if ( cmdID == DECMD_ORDERLIST || cmdID == DECMD_UNORDERLIST )
                    {
                       if ( isHeading )
                           buttonState( buttonControl, false, false );
                       else
                           buttonState( buttonControl, true, false );
                    }
                    else if ( ( cmdID != DECMD_INSERTROW ) && ( cmdID != DECMD_INSERTCOL ) &&
                         ( cmdID != DECMD_DELETEROWS ) && ( cmdID != DECMD_DELETECOLS ) &&
                         ( cmdID != DECMD_SPLITCELL ) && ( cmdID != DECMD_MERGECELLS ) )
                    {
                        if ( tableID == "literalTag" && cmdID != DECMD_FINDTEXT  && cmdID != DECMD_UNDO && cmdID != DECMD_REDO )
                                   buttonState( buttonControl, false, false );
                              else
                                   buttonState( buttonControl, true, false );
                    }
                    else if ( ( ( cmdID == DECMD_INSERTROW ) || ( cmdID == DECMD_INSERTCOL ) ||
                                ( cmdID == DECMD_DELETEROWS ) || ( cmdID == DECMD_DELETECOLS ) ||
                                ( cmdID == DECMD_SPLITCELL ) || ( cmdID == DECMD_MERGECELLS ) ) && tableID == "table" )
                                buttonState( buttonControl, true, false );
                    else
                        buttonState( buttonControl, false, false );
                }
                else
                {
                   // enabled and selected
                   buttonState( buttonControl, true, true );
                }

                /*if ( button_obj.selectedIndex != 0 && ( cmdID == DECMD_ITALIC || cmdID == DECMD_BOLD ) )
                {
                     buttonState( buttonControl, false, false );
                }*/
            }break;
            case "insertObject":
            case "insertAnchor":
            case "insertCustomTag":
            case "insertLiteralText":
            case "insertTable":
            {
                  if ( tableID == "literalTag" || textSelected )
                      buttonState( buttonControl, false, false );
                  else
                      buttonState( buttonControl, true, false );
              }break;

        case "insertLink":
        {
            if ( tableID == "literalTag" )
                buttonState( buttonControl, false, false );
            else
                buttonState( buttonControl, true, false );
        }break;

        case "insertCharacter":
        {
                if ( textSelected )
                    buttonState( buttonControl, false, false );
                else
                    buttonState( buttonControl, true, false );
        }
        break;
        }
    }
}

/*!
    Update the appearance of a button
*/
function buttonState( buttonControl, enabled, selected )
{
    // Button enabled, but not selected
    if ( enabled == true ) //&& selected == false ) //&&
       //  ( buttonControl.isDisabled == true || buttonControl.className != "toolbarButton" ) )
    {
        if ( selected )
        {
            if ( buttonControl.className != "toolbarButtonSelected" )
                buttonControl.className = "toolbarButtonSelected";
        }
        else
        {
            if ( buttonControl.className != "toolbarButton" )
                buttonControl.className = "toolbarButton";
        }

        if ( buttonControl.style.filter != "" )
            buttonControl.style.filter = "";
        //if ( buttonControl.isDisabled == true )
        //    buttonControl.disabled     = false;
    }
    // Button enabled and selected
    /*
    else if ( enabled == true && selected == true  )
    {
        buttonControl.className    = "toolbarButtonSelected";
        buttonControl.style.filter = "";
        buttonControl.disabled     = false;
    }*/
    // Button disabled
    else
    {
        //if ( buttonControl.className != "toolbarButton" )
        //    buttonControl.className = "toolbarButton";

        if ( buttonControl.style.filter == "" )
            buttonControl.style.filter = "alpha(opacity=25)";
        //if ( buttonControl.isDisabled != true )
        //    buttonControl.disabled     = true;
    }
}

function showTableCellProperty ( objectRef )
{
    var objectControl = document.all[objectRef];

    var argArray = new Array();
    var selection = objectControl.DOM.selection;
    var selectionRange = selection.createRange();

    var tagName = 'td';
    var tdElement = getElement( selectionRange.parentElement(),"TD" );

    if ( tdElement == null )
    {
        tagName = 'th';
        tdElement = getElement( selectionRange.parentElement(),"TH" );
    }

    argArray["class"] = tdElement.className;

    if (  argArray["class"] == null )
        argArray["class"] = "";

    argArray["width"] = tdElement.width;

    var resultArray = showModalDialog( objectControl.customTableCell["url"] + tagName + "/", argArray, objectControl.customTableCell["parameters"] );

    // Return if the dialog wasn't completed
    if ( resultArray == null ) { return; }

    var trElement = getElement( selectionRange.parentElement(),"TR" );

    var tableElement = getElement( selectionRange.parentElement(),"TABLE" );

    var rowE = tableElement.rows;

    var cellIndex = tdElement.cellIndex;

    var rowIndex = trElement.rowIndex;

    var classTarget = resultArray["classTarget"];

    var widthTarget = resultArray["widthTarget"];

    // Get class name
    className = resultArray["class"];

    if ( classTarget == "row" )
    {
        var cells = rowE[rowIndex].cells;
        for ( var j=0; j<cells.length; j++ )
        {
            if ( className != -1 )
                cells[j].className = className;
            else
                cells[j].className = "";
        }
    }
    else if ( classTarget == "column" )
    {
        for ( var i=0; i<rowE.length; i++ )
        {
            var cells = rowE[i].cells;
            for ( var j=0; j<cells.length; j++ )
            {
                if ( j == cellIndex )
                    if ( className != -1 )
                        cells[j].className = className;
                    else
                        cells[j].className = "";
            }
        }
    }
    else
    {
        if ( className != -1 )
            tdElement.className = className;
        else
            tdElement.className = "";
    }

    if ( resultArray["width"] == null )
    {
        resultArray["width"] = -1;
    }

    if ( resultArray["width"] != -1 )
    {
        if ( widthTarget == "row" )
    {
        var cells = rowE[rowIndex].cells;
        for ( var j=0; j<cells.length; j++ )
        {
            cells[j].setAttribute( "width", resultArray["width"] );
        }
    }
    else if ( widthTarget == "column" )
    {
        for ( var i=0; i<rowE.length; i++ )
        {
            var cells = rowE[i].cells;
        for ( var j=0; j<cells.length; j++ )
        {
            if ( j == cellIndex )
            cells[j].setAttribute( "width", resultArray["width"] );
        }
         }
    }
    else
    {
            tdElement.setAttribute( "width", resultArray["width"]);
        }
    }
}

function showClassDialog ( objectRef )
{
    var objectControl = document.all[objectRef];

    var argArray = new Array();
    var selection = objectControl.DOM.selection;
    var selectionRange = selection.createRange();
    var pElement = selectionRange.parentElement();
    var tagName = pElement.tagName;
    tagName = tagName.toLowerCase();
    if ( tagName == "li" )
    {
        oElement = pElement.parentElement;
        tagName =  oElement.tagName;
        tagName = tagName.toLowerCase();
        pElement = oElement;
    }

    argArray["class"] = pElement.className;

    if (  argArray["class"] == null )
        argArray["class"] = "";

    /*if ( argArray["class"] != "" )
    {
        success = pElement.removeAttribute( "ezclass" );
    }*/

    argArray["customAttributes"] = pElement.customAttributes;
    if ( argArray["customAttributes"] == null )
        argArray["customAttributes"] = -1;

    var url = objectControl.customClass["url"];
    url = objectControl.customClass["url"] + tagName + "/";

    var resultArray = showModalDialog( url, argArray, objectControl.customClass["parameters"] );

    // Return if the dialog wasn't completed
    if ( resultArray == null ) { return; }

    // Get class name
    className = resultArray["class"];

    if ( className != -1 )
    {
        pElement.className = className;
    }
    else
    {
        pElement.className = "";
    }

    var customAttributesValue = createCustomAttrString( resultArray["customAttributes"] );

    if ( customAttributesValue != "" )
       pElement.setAttribute( "customAttributes", customAttributesValue );
    else
       pElement.removeAttribute( "customAttributes" );
}

function showHelpWindow ( objectRef )
{
    var objectControl = document.all[objectRef];
    var argArray = new Array();
    var resultArray = showModalDialog( objectControl.customHelp["url"], argArray, objectControl.customHelp["parameters"] );
}

/*
  Utility function; Goes up the DOM from the element oElement, till a parent element with the tag
  that matches sTag is found. Returns that parent element.
*/
function getElement( oElement, sTag )
{
  while (oElement!=null && oElement.tagName!=sTag){
    oElement = oElement.parentElement;
  }
  return oElement;
}

/*
  Utility function; Goes up the DOM from the element oElement, returns all parent tags
*/
function getParentTagList( oElement, editorControl )
{
    var parentTagList = new Array();
    var index = 0;
    while ( oElement.tagName != "BODY" && oElement != null )
    {
        var currentTagName = oElement.tagName;
        var isTable = true;
        if ( currentTagName == "TABLE" )
        {
            currentTagName = oElement.getAttribute( 'id' );
            if ( currentTagName == "" || currentTagName == "table" )
            {
                currentTagName = "table";
            }
            else
            {
                isTable = false;
            }
        }

        if ( currentTagName == "IMG" )
        {
        currentTagName = oElement.getAttribute( 'type' );
        if ( currentTagName == null )
        {
               if ( oElement.getAttribute( 'inline' ) == 'true' )
                   currentTagName = "embed-inline";
               else
                   currentTagName = "embed";
        }
        }

        // Remove td and tr tag from list for literal tag or custom tag.
        if ( !isTable && parentTagList.length>=3 && parentTagList[index-3] == "TD" )
        {
            parentTagList[index-1] = "";
            parentTagList[index-2] = "";
            parentTagList[index-3] = "";
            parentTagList.length = parentTagList.length - 3;
            index = index - 3;
        }
        parentTagList[index] = currentTagName;
        oElement = oElement.parentElement;
        index++;
    }
    return parentTagList;
}

function createCustomAttrString( customAttributes )
{
    var customAttributeString = "";
    if ( customAttributes && customAttributes.length != 0 )
    {
        customAttributeString += customAttributes[0];
        for( var j=1;j<customAttributes.length;j++ )
        {
            customAttributeString += 'attribute_separation' + customAttributes[j];
        }
    }
    return customAttributeString;
}

function insertLiteralText ( objectRef )
{
    var objectControl = document.all[objectRef];
    var objectTableInfo = document.all[objectRef+"ObjTableInfo"];
    var oldObjectTableinfo = objectTableInfo;

    var argArray = new Array();
    var selection = objectControl.DOM.selection;
    var selectionRange = selection.createRange();

    // If we choose an existing literal tag, put its information in the input window
    if ( selectionRange.length == 1 )
    {
        if ( selectionRange.item(0).tagName == "TABLE")
        {
            selectedTable = selectionRange.item(0);
            if ( selectedTable.id != "literal" )
            {
                alert( textStrings["SelectionIsNotALiteralTag"] );
                return;
            }
            argArray["class"] = selectedTable.title;

            if (  argArray["class"] == null )
                argArray["class"] = "";

            argArray["customAttributes"] = selectedTable.customAttributes;
            if ( argArray["customAttributes"] == null )
                argArray["customAttributes"] = -1;

            var resultArray = showModalDialog( objectControl.literalTag["url"], argArray, objectControl.literalTag["parameters"] );
            if ( resultArray == null ) { return; }

            var className = resultArray["class"];

            var tr = selectedTable.lastChild;
            if ( tr.nodeName == 'TBODY' )
            {
                tr = tr.lastChild;
            }
            var td = tr.lastChild;

            if ( className != -1 )
            {
                selectedTable.setAttribute( "title", className );
                td.className = className;
            }
            else
            {
                selectedTable.removeAttribute( "title" );
                td.className = "";
            }

            var customAttributesValue = createCustomAttrString( resultArray["customAttributes"] );

            if ( customAttributesValue != "" )
                selectedTable.setAttribute( "customAttributes", customAttributesValue );
            else
                selectedTable.removeAttribute( "customAttributes" );
        }
        else
        {
            alert( textStrings["SelectionIsNotALiteralTag"] );
        }
    }
    else
    {
        argArray["class"] = "";
        argArray["customAttributes"] = -1;

        var resultArray = showModalDialog( objectControl.literalTag["url"], argArray, objectControl.literalTag["parameters"] );

        var border = 1;
        var width = "100%";

        // Return if the dialog wasn't completed
        if ( resultArray == null ) { return; }

        // Get class name
        classification = resultArray["class"];

        // Set the parameters of the table
        objectTableInfo.NumRows = 1;
        objectTableInfo.NumCols = 1;

        var tableAttributes = 'border="' + border + '"';
        tableAttributes += ' width="' + width + '"';
        tableAttributes += ' class="literal" id="literal"';

        var customAttributesValue = createCustomAttrString( resultArray["customAttributes"] );

        if ( customAttributesValue != "" )
            customAttributesValue = ' customAttributes="' + customAttributesValue + '"';

        if ( classification != -1 )
            tableAttributes += ' title="' + classification + '"';
        objectTableInfo.TableAttrs = tableAttributes + customAttributesValue;
        objectTableInfo.CellAttrs = 'class="classification"';
        objectControl.ExecCommand(DECMD_INSERTTABLE,OLECMDEXECOPT_DODEFAULT, oldObjectTableinfo);
    }
}

function insertHTMLText ( objectRef )
{
    var objectControl = document.all[objectRef];
    var objectTableInfo = document.all[objectRef+"ObjTableInfo"];
    var oldObjectTableinfo = objectTableInfo;

    var border = 1;
    var width = "100%";
    var id = "html";

    // Set the parameters of the table
    objectTableInfo.NumRows = 1;
    objectTableInfo.NumCols = 1;

    var tableAttributes = 'border="' + border + '"';
    tableAttributes += ' width="' + width + '"';
    tableAttributes += ' id="' + id + '"';
    objectTableInfo.TableAttrs = tableAttributes;
    objectTableInfo.CellAttrs = 'bgcolor="#ffffcc"';
    objectControl.ExecCommand(DECMD_INSERTTABLE,OLECMDEXECOPT_DODEFAULT, oldObjectTableinfo);
}

/*!
    Changes the text heading in display
*/
function changeHeading( objectRef )
{
    var editorControl = document.all[objectRef];

    // Get the current format of the paragraph
    var blockFormatNow = editorControl.ExecCommand( DECMD_GETBLOCKFMT, OLECMDEXECOPT_DODEFAULT );

    var selectorName = objectRef + "_select_header";
    var button_obj = document.all[selectorName];

    var index = button_obj.selectedIndex;
    if ( index != null )
    {
    var selectedValue = button_obj[ index ].value;
    }

    var blockFormatNames = editorControl.paragraphStyles;

    switch ( selectedValue )
    {
    case 'normal' :

         // If format is not normal, change it to normal
         if ( blockFormatNow != blockFormatNames[0] )
         {
        editorControl.ExecCommand(DECMD_SETBLOCKFMT, OLECMDEXECOPT_DODEFAULT, blockFormatNames[0]);
         }
         break
    case 'Heading 1' :
         if ( blockFormatNow != blockFormatNames[3] )
         {
             if ( blockFormatNow == blockFormatNames[9] || blockFormatNow == blockFormatNames[10] )
             alert( textStrings["HeadingInsideListIsNotAllowed"] );
         else
             editorControl.ExecCommand(DECMD_SETBLOCKFMT, OLECMDEXECOPT_DODEFAULT, blockFormatNames[3]);
         }
         break
    case 'Heading 2' :
         if ( blockFormatNow != blockFormatNames[4] )
         {
             if ( blockFormatNow == blockFormatNames[9] || blockFormatNow == blockFormatNames[10] )
             alert( textStrings["HeadingInsideListIsNotAllowed"] );
         else
             editorControl.ExecCommand(DECMD_SETBLOCKFMT, OLECMDEXECOPT_DODEFAULT, blockFormatNames[4]);
         }
         break
    case 'Heading 3' :
         if ( blockFormatNow != blockFormatNames[5] )
         {
             if ( blockFormatNow == blockFormatNames[9] || blockFormatNow == blockFormatNames[10] )
             alert( textStrings["HeadingInsideListIsNotAllowed"] );
         else
             editorControl.ExecCommand(DECMD_SETBLOCKFMT, OLECMDEXECOPT_DODEFAULT, blockFormatNames[5]);
         }
         break
    case 'Heading 4' :
         if ( blockFormatNow != blockFormatNames[6] )
         {
             if ( blockFormatNow == blockFormatNames[9] || blockFormatNow == blockFormatNames[10] )
             alert( textStrings["HeadingInsideListIsNotAllowed"] );
         else
             editorControl.ExecCommand(DECMD_SETBLOCKFMT, OLECMDEXECOPT_DODEFAULT, blockFormatNames[6]);
         }
         break
    case 'Heading 5' :
         if ( blockFormatNow != blockFormatNames[7] )
         {
             if ( blockFormatNow == blockFormatNames[9] || blockFormatNow == blockFormatNames[10] )
             alert( textStrings["HeadingInsideListIsNotAllowed"] );
         else
             editorControl.ExecCommand(DECMD_SETBLOCKFMT, OLECMDEXECOPT_DODEFAULT, blockFormatNames[7]);
         }
         break
    case 'Heading 6' :
         if ( blockFormatNow != blockFormatNames[8] )
         {
             if ( blockFormatNow == blockFormatNames[9] || blockFormatNow == blockFormatNames[10] )
             alert( textStrings["HeadingInsideListIsNotAllowed"] );
         else
             editorControl.ExecCommand(DECMD_SETBLOCKFMT, OLECMDEXECOPT_DODEFAULT, blockFormatNames[8]);
         }
         break
    default:
        editorControl.ExecCommand(DECMD_SETBLOCKFMT, OLECMDEXECOPT_DODEFAULT, blockFormatNames[0]);
    }
}


function newTable( objectRef )
{
    insertTable( objectRef, 1 );
}

/*!
    Shows "tablePage" and uses the chosen values to insert a table
*/
function insertTable( objectRef, isNew )
{
    var objectControl = document.all[objectRef];
    var objectTableInfo = document.all[objectRef+"ObjTableInfo"];
    var argArray = new Array();
//    var isNew = 1;

    if ( !isNew )
    {
        var selection = objectControl.DOM.selection;
        var selectionRange = selection.createRange();
        if ( selection.type == 'None' || selection.type == 'Text' )
        {
            selectionRange.collapse();
            var currentNode = selectionRange.parentElement();
        }
        else
            var currentNode = selectionRange.item(0);

        var currentNode = getElement( currentNode, "TABLE" );
        if ( currentNode == null )
            return;
        var rowObject = currentNode.rows;
        var cellObject = rowObject.item(0).cells;
        argArray["tableRows"] = rowObject.length;
        argArray["tableCols"] = cellObject.length;
        argArray["tableClass"] = currentNode.className;
        if ( argArray["tableClass"] == "" || argArray["tableClass"] == null )
            argArray["tableClass"] = -1;

        argArray["tableBorder"] = currentNode.getAttribute( "ezborder" );;
        argArray["tableWidth"] = currentNode.width;
        argArray["enableRowEdit"] = false;

        argArray["customAttributes"] = currentNode.customAttributes;
        if ( argArray["customAttributes"] == null )
            argArray["customAttributes"] = -1;

        var resultArray = showModalDialog( objectControl.table["url"] + "0", argArray, objectControl.table["parameters"] );

        // Return if the dialog wasn't completed
        if ( resultArray == null ) { return; }

        // Set the parameters of the table
        var border = resultArray["tableBorder"];
        var width = resultArray["tableWidth"];
        var className = resultArray["tableClass"];
        if ( border == 0 )
        {
            border = 1;
            currentNode.setAttribute( "ezborder", resultArray["tableBorder"] );
            currentNode.setAttribute( "borderColor", "#ff0000" );
        }
        else
        {
            currentNode.setAttribute( "ezborder", border );
            currentNode.removeAttribute( "borderColor" );
        }
        currentNode.setAttribute( "width", width );
        currentNode.setAttribute( "border", border );
        if ( className != -1 )
            currentNode.className = className;
        else
            currentNode.className = "";

        var customAttributesValue = createCustomAttrString( resultArray["customAttributes"] );

        if ( customAttributesValue != "" )
            currentNode.setAttribute( 'customAttributes', customAttributesValue );
        else
            currentNode.removeAttribute( 'customAttributes' );
    }
    else
    {
    argArray["tableCols"] = 2;
    argArray["tableRows"] = 2;
    argArray["tableBorder"] = 1;
    argArray["tableClass"] = -1;
    argArray["tableWidth"] = "100%";
    argArray["enableRowEdit"] = true;
    argArray["customAttributes"] = -1;

    var resultArray = showModalDialog( objectControl.table["url"] + "1" , argArray, objectControl.table["parameters"] );
      var border = 0;

    // Return if the dialog wasn't completed
    if ( resultArray == null ) { return; }

    // Only continue, if rows and columns are set
    if ( resultArray["tableCols"] == null || isNaN(resultArray["tableCols"]) == true || resultArray["tableCols"] < 1 )
    {
        alert( textStrings["ErrorTheNumberOfColumnsIsRequiredAndHasToBeAtLeast1"] );
        return;
    }
    if ( resultArray["tableRows"] == null || isNaN(resultArray["tableRows"]) == true || resultArray["tableRows"] < 1 )
    {
        alert( textStrings["ErrorTheNumberOfRowsIsRequiredAndHasToBeAtLeast1"] );
        return;
    }

          // Set some default for border and width in case none were entered
    if ( resultArray["tableBorder"] == null || isNaN(resultArray["tableBorder"]) == true )
    {
        resultArray["tableBorder"] = 1;
    }

    if ( resultArray["tableWidth"] == null )
    {
        resultArray["tableWidth"] == "100%";
    }

    className = resultArray["tableClass"];

    if ( resultArray["tableBorder"] == 0 )
    {
        border = 1;
        // Set parameters of the table
        objectTableInfo.NumRows = resultArray["tableRows"];
        objectTableInfo.NumCols = resultArray["tableCols"];
        var tableAttributes = 'border="' + border + '"';
        tableAttributes += ' ezborder="' + resultArray["tableBorder"] + '"';
        tableAttributes += ' ezbordercolor="red"';
        tableAttributes += ' bordercolor="red"';
        tableAttributes += ' width="' + resultArray["tableWidth"] + '"';
    }
    else
    {
        border = resultArray["tableBorder"];
        // Set the parameters of the table
        objectTableInfo.NumRows = resultArray["tableRows"];
        objectTableInfo.NumCols = resultArray["tableCols"];
        var tableAttributes = 'border="' + border + '"';
        tableAttributes += ' ezborder="' + border + '"';
        tableAttributes += ' width="' + resultArray["tableWidth"] + '"';
    }

    if ( className != -1 )
    {
        tableAttributes += ' class="' + className + '"';
    }

    var customAttributesValue = createCustomAttrString( resultArray["customAttributes"] );

    if ( customAttributesValue != "" )
        tableAttributes += ' customAttributes="' + customAttributesValue + '"';

    objectTableInfo.TableAttrs = tableAttributes;
    //objectTableInfo.CellAttrs = 'bgcolor="#FFFFFF"';
    objectControl.ExecCommand(DECMD_INSERTTABLE,OLECMDEXECOPT_DODEFAULT, objectTableInfo);
    }
}

function newCustomTag( objectRef )
{
    insertCustomTag( objectRef, 1 );
}

function insertCustomTag( objectRef, isNew )
{
    var objectControl = document.all[objectRef];
    var objectTableInfo = document.all[objectRef+"ObjTableInfo"];
    var oldObjectTableinfo = objectTableInfo;

    var argArray = new Array();
    var selection = objectControl.DOM.selection;
    var selectionRange = selection.createRange();
    var selectedTable = null;

    // If we choose an existing custom tag, put its information in the input window
    if ( selectionRange.length == 1 && selectionRange.item(0).tagName == "IMG" && isNew == 0 )
    {
        selectedImage = selectionRange.item(0);
        var imgType = selectedImage.type;
        var tagName = selectedImage.name;
        var tagText = selectedImage.value;
        argArray["customTagName"] = tagName;
        argArray["customTagText"] = tagText;
        argArray["customAttributes"] = selectedImage.customAttributes;

        if ( argArray["customAttributes"] == "" || argArray["customAttributes"] == null )
            argArray["customAttributes"] = -1;
        if ( imgType == "custom" )
        {
            argArray["customTagType"] = "inline";
            var resultArray = showModalDialog( objectControl.customTag["url"] + "0", argArray, objectControl.customTag["parameters"] );
        }
        else
        {
            alert( textStrings["SelectedImageTypeIsNotCustomTag"] );
        }
    }
    else if ( selectionRange.length != 1 && selectionRange.parentElement().tagName == "SPAN" && isNew == 0 )
    {
        var selected = selectionRange.parentElement();
        var type = selected.getAttribute( 'type' );
        var name = selected.getAttribute( 'name' );
        var text = selected.innerHTML;
        argArray["customTagName"] = name;
        argArray["customTagText"] = text;
        argArray["customAttributes"] = selected.customAttributes;

        if ( argArray["customAttributes"] == "" || argArray["customAttributes"] == null )
            argArray["customAttributes"] = -1;
        if ( type == "custom" )
        {
            argArray["customTagType"] = "inline";
            var resultArray = showModalDialog( objectControl.customTag["url"] + "0", argArray, objectControl.customTag["parameters"] );
        }
    }
    else if ( ( selectionRange.length == 1 && selectionRange.item(0).tagName == "TABLE" && isNew == 0 ) ||
            ( selectionRange.length != 1 && isNew == 0 ) )
    {
        if ( selectionRange.length != 1 )
        {
            selectedTable = getElement( selectionRange.parentElement(), "TABLE" );
        }
        else
        {
            selectedTable = selectionRange.item(0);
        }
        var tableType = selectedTable.id;
        argArray["customTagName"] = selectedTable.title;
        argArray["customTagType"] = "block";
        argArray["customTagText"] = "";
        argArray["customAttributes"] = selectedTable.customAttributes;

        if ( argArray["customAttributes"] == "" || argArray["customAttributes"] == null )
            argArray["customAttributes"] = -1;
        if ( tableType == "custom" )
        {
            var resultArray = showModalDialog( objectControl.customTag["url"] + "0", argArray, objectControl.customTag["parameters"] );
        }
        else
        {
            alert( textStrings["SelectedTableTypeIsNotCustomTag"] );
        }
    }
    else
    {
        argArray["customTagName"] = "";
        argArray["customTagText"] = "";
        argArray["customTagType"] = "";
        argArray["customAttributes"] = -1;
        var resultArray = showModalDialog( objectControl.customTag["url"]  + "1", argArray, objectControl.customTag["parameters"] );
    }

    // Return if the dialog wasn't completed
    if ( resultArray == null ) { return; }

    // Get the custom tag name
    name = resultArray["customTagName"];
    name = name.replace( "inline_", "" );

    var customAttributes = resultArray["customAttributes"];

    var customAttributesValue = "";
    if ( customAttributes && customAttributes.length != 0 )
    {
        customAttributesValue = customAttributes[0];
        for( var j=1;j<customAttributes.length;j++ )
        {
            customAttributesValue += 'attribute_separation' + customAttributes[j];
        }
    }

    // Get the tag type
    type = resultArray["customTagType"];

    if ( type == "block" )
    {
        if ( isNew == 0 && selectedTable )
        {
            selectedTable.setAttribute( "title", name );
            if ( customAttributesValue != "" )
                selectedTable.setAttribute( "customAttributes", customAttributesValue );
            else
                selectedTable.removeAttribute( "customAttributes" );
        }
        else
        {
            var border = 1;
            var width = "100%";
            // Set the parameters of the table
            objectTableInfo.NumRows = 1;
            objectTableInfo.NumCols = 1;

            var tableAttributes = 'border="' + border + '"';
            tableAttributes += ' width="' + width + '"';
            tableAttributes += ' id="custom"';
            tableAttributes += ' title="' + name + '"';
            tableAttributes += ' class="custom" ';
            tableAttributes += ' customAttributes="' + customAttributesValue + '"';
            objectTableInfo.TableAttrs = tableAttributes;
            objectTableInfo.CellAttrs = 'class="' + name + '"';
            objectControl.ExecCommand(DECMD_INSERTTABLE, OLECMDEXECOPT_DODEFAULT, oldObjectTableinfo);
        }
    }
    else
    {
        selectionRange.execCommand('Delete');
        var selection = objectControl.DOM.selection;
        var selectionRange = selection.createRange();

        text = resultArray["customTagText"];

        if ( isNew == 0 && selectionRange.parentElement().tagName == "SPAN" )
        {
            span = selectionRange.parentElement();
            span.setAttribute( 'type', 'custom' );
            span.setAttribute( 'name', name );
            span.className = name;

            if ( customAttributesValue != "" )
                span.setAttribute( "customAttributes", customAttributesValue );
            else
                span.removeAttribute( "customAttributes" );

            span.innerHTML = text;
        }
        else if ( isNew == 1 && text != '' )
        {
            selectionRange.pasteHTML( '<span type="custom"'
                           + ' name="' + name
                           + '" class="' + name
                           + '" customAttributes="' + customAttributesValue + '"/>' + text + '</span>&nbsp;' );
            selectionRange.collapse(false);
            selectionRange.select();
        }
        else
        {
            selectionRange.pasteHTML( '<img type="custom"'
                           + ' src="' + resultArray["imgSrc"]
                           + '" name="' + name
                           + '" value="' + text
                           + '" customAttributes="' + customAttributesValue + '"/>' );
        }
    }
}

/*!
    Shows "objectPage" and uses the chosen values to insert an object into the table object
*/
function insertObject( objectRef )
{
    var editorControl = document.all[objectRef];

    var objectControl = document.all[objectRef];
    var argArray = new Array();
    var selection = objectControl.DOM.selection;
    var selectionRange = selection.createRange();
    var isChanged = false;
    var linkElement = -1;

    // If we choose an existing image, put its information in the input window
    if ( selectionRange.length == 1 )
    {
        if ( selectionRange.item(0).tagName == "IMG")
        {
            selectedImage = selectionRange.item(0);
            argArray["objectAlign"] = selectedImage.align;
            argArray["objectID"] = selectedImage.id;
            argArray["objectSrc"] = selectedImage.src;
            argArray["objectClass"] = selectedImage.className;
            argArray["objectView"] = selectedImage.view;
            argArray["htmlID"] = selectedImage.html_id;
            argArray["embedInline"] = selectedImage.inline;
            if ( argArray["embedInline"] == 'false' )
                argArray["embedInline"] = false;
            else if ( argArray["embedInline"] == 'true' )
                argArray["embedInline"] = true;

            argArray["customAttributes"] = selectedImage.customAttributes;

            if ( argArray["customAttributes"] == "" || argArray["customAttributes"] == null )
                argArray["customAttributes"] = -1;
            if ( argArray["objectClass"] == "" || argArray["objectClass"] == null )
                argArray["objectClass"] = -1;

            if ( !argArray["objectView"] )
            {
                if ( argArray["embedInline"] == true )
                    argArray["objectView"] = "embed-inline";
                else
                    argArray["objectView"] = "embed";
            }

            if ( argArray["htmlID"] == "" || argArray["htmlID"] == null )
                argArray["htmlID"] = "";
            if ( argArray["objectAlign"] == "" || argArray["objectAlign"] == null )
                argArray["objectAlign"] = "center";

            var size = selectedImage.alt;
            if ( size == "" || size == null )
                size = "medium";
            argArray["objectSize"] = size;
            argArray["imageExist"] = true;
            var resultArray = showModalDialog( objectControl.customObject["url"], argArray, objectControl.customObject["parameters"] );
            if ( resultArray == null )
            {
                return;
            }

            var attributeArray = resultArray["customAttributes"];
            var attributeString = "";

            if ( attributeArray != null )
            {
                attributeString = attributeArray[0];
                for ( var j=1;j<attributeArray.length;j++ )
                {
                    attributeString += 'attribute_separation' + attributeArray[j];
                }
            }
            if ( resultArray["objectAlign"] != argArray["objectAlign"] )
            {
                isChanged = true;
            }
            if ( resultArray["objectSize"] != argArray["objectSize"] )
            {
                isChanged = true;
            }
            if ( resultArray["objectClass"] != argArray["objectClass"] )
            {
                isChanged = true;
            }
            if ( resultArray["objectView"] != argArray["objectView"] )
            {
                isChanged = true;
            }
            if ( resultArray["htmlID"] != argArray["htmlID"] )
            {
                isChanged = true;
            }
            if ( resultArray["embedInline"] != argArray["embedInline"] )
            {
                isChanged = true;
            }
            if ( attributeString != argArray["customAttributes"] )
            {
                isChanged = true;
            }
            if ( isChanged )
            {
                if ( selectionRange.item(0).tagName == "IMG" )
                {
                    var pElement = selectionRange.item(0).parentElement;
                    if ( pElement.tagName == "A" )
                    {
                        linkElement = pElement;
                        pElement.removeNode(true);
                    }
                    else
                        selectionRange.execCommand('Delete');
                }
                else
                {
                    selectionRange.execCommand('Delete');
                }
            }
        }
    }
    else
    {
        argArray["objectAlign"] = "center";
        argArray["objectID"] = "";
        argArray["objectClass"] = -1;
        argArray["objectView"] = "";
        //argArray["embedInline"] = true;
        argArray["htmlID"] = "";
        argArray["objectSize"] = "";
        argArray["imageExist"] = false;
        argArray["customAttributes"] = -1;
        argArray["objectSrc"] = "";
        var resultArray = showModalDialog( objectControl.customObject["url"],  argArray, objectControl.customObject["parameters"] );
    }

    if ( resultArray == null )
    {
        return;
    }

    if ( resultArray["objectIDString"] == null )
    {
        return;
    }
    if ( resultArray["objectAlign"] == null )
    {
        resultArray["objectAlign"] = "center";
    }

    var standardAttributeString = "";
    if ( resultArray["objectClass"] != -1 )
    {
        standardAttributeString += ' class="' + resultArray["objectClass"] + '"';
    }
    if ( resultArray["objectSize"] != "" )
    {
        standardAttributeString += ' alt="' + resultArray["objectSize"] + '"';
    }

    standardAttributeString += ' inline="' + resultArray["embedInline"] + '"';

    if ( ( resultArray["embedInline"] == true && resultArray["objectView"] != 'embed-inline' ) ||
         ( resultArray["embedInline"] == false && resultArray["objectView"] != 'embed' ) )
    {
        standardAttributeString += ' view="' + resultArray["objectView"] + '"';
    }
    if (  resultArray["htmlID"] != "" )
    {
        standardAttributeString += ' html_id="' + resultArray["htmlID"] + '"';
    }

    var sourceString = resultArray["objectIDString"];
    var selection = objectControl.DOM.selection;
    var selectionRange = selection.createRange();

    var customAttributes = resultArray["customAttributes"];
    var customAttributeString = "";

    if ( linkElement != -1 )
    {
        var linkHref = linkElement.href;
        var linkTarget = linkElement.target;
        var linkTitle = linkElement.title;
        var linkID = linkElement.id;
        var optionalLinkParameters = "";
        if (  linkTitle != null )
            optionalLinkParameters += ' title="' + linkTitle + '"';
        if (  linkID != null )
            optionalLinkParameters += ' id="' + linkID + '"';

    }

    if ( customAttributes.length != 0 )
    {
        customAttributeString += ' customAttributes="'
        customAttributeString += customAttributes[0];
        for ( var j=1;j<customAttributes.length;j++ )
        {
            customAttributeString += 'attribute_separation' + customAttributes[j];
        }
        customAttributeString += '"';
    }

    if ( resultArray["objectSize"] != "original" && selectionRange.length != 1 )
    {
        sourceString = sourceString.replace( "_small", "_" + resultArray["objectSize"] );
    }
    else if ( resultArray["objectSize"] == "original" && selectionRange.length != 1 )
    {
        sourceString = sourceString.replace( "_small", "" );
    }
    else
    {
        return;
    }
    if ( linkElement != -1 )
    {
        selectionRange.pasteHTML('<a href="' + linkHref + '" target="' + linkTarget + '"'  + optionalLinkParameters + '><img ' + sourceString
                                 + ' align="' + resultArray["objectAlign"] + '"'
                                 + standardAttributeString
                                 + customAttributeString
                                 + ' /></a>');
    }
    else
    {
        selectionRange.pasteHTML('<img ' + sourceString
                                 + ' align="' + resultArray["objectAlign"] + '"'
                                 + standardAttributeString
                                 + customAttributeString
                                 + ' />');
    }
}

function insertLink( objectRef )
{
    var editorControl = document.all[objectRef];
    var argArray = new Array();

    var isNew = 0;

    // Get the selected text
    var selection = editorControl.DOM.selection;
    var selectionRange = selection.createRange();
    if ( selectionRange.length == 1 )
    {
        // Add link to existing image
        if ( selectionRange.item(0).tagName == "IMG")
        {
            var imageElement = selectionRange.item(0);
            argArray["linkUrl"] = "";
            argArray["linkType"] = "";
            argArray["linkWindow"] = "_self";
            argArray["linkText"] = "ez_image";
            argArray["linkClass"] = -1;
            argArray["linkView"] = -1;


            argArray["linkTitle"] = "";
            argArray["linkID"] = "";

            argArray["customAttributes"] = -1;

            if ( imageElement.parentElement.tagName == "A" )
            {
                var pElement = imageElement.parentElement;
                var href =  pElement.href;
                linkType = "";
                if( href.match(/http/g) )
                {
                    linkType = "http:\/\/";
                }
                else if ( href.match(/mailto/g) )
                {
                    linkType = "mailto:";
                }
                else if ( href.match(/file/g) )
                {
                  linkType = "file:\/\/";
                  href = href.replace( /\\\\/, "" );
                  while ( href.match(/\\/) )
                  {
                    href = href.replace( /\\/, "\/" );
                  }
                }
                else if ( href.match(/ftp/g) )
                {
                    linkType = "ftp:\/\/";
                }
                else if ( href.match(/https/g) )
                {
                    linkType = "https:\/\/";
                }
                else if ( href.match(/eznode/g) )
                {
                linkType = "eznode:\/\/";
                }
                else if ( href.match(/ezobject/g) )
                {
                linkType = "ezobject:\/\/";
                }
                else
                {
                linkType = "";
                }

                argArray["linkUrl"] = href;
                argArray["linkType"] = linkType;
                argArray["linkWindow"] = pElement.target;
                argArray["linkText"] = "ez_image";
                argArray["linkView"] = pElement.getAttribute( 'view' );
                if ( !pElement.className )
                    argArray["linkClass"] = -1;
                else
                    argArray["linkClass"] = pElement.className;

                argArray["linkTitle"] = pElement.title;
                argArray["linkID"] = pElement.id;

                argArray["customAttributes"] = pElement.customAttributes;
                if ( argArray["customAttributes"] == null )
                    argArray["customAttributes"] = -1;

                var resultArray = showModalDialog( editorControl.customLink["url"] + "0", argArray, editorControl.customLink["parameters"] );
                if ( resultArray == null ) { return; }
                pElement.replaceNode( imageElement );
            }
            else
            {
                var resultArray = showModalDialog( editorControl.customLink["url"] + "1", argArray, editorControl.customLink["parameters"] );
                if ( resultArray == null ) { return; }
            }

            imageSource = imageElement.src;
            imageAlignment = imageElement.align;
            imageSize = imageElement.alt;
            imageID = imageElement.id;
            imageClass = imageElement.className;

            imageHtmlID = imageElement.getAttribute( 'html_id' );

            imageViewMode = imageElement.getAttribute( 'view' );
            imageCustomAttributes = imageElement.customAttributes;
            var imageAttributes = "";
            if ( imageCustomAttributes != null )
                imageAttributes = "customAttributes='" + imageCustomAttributes + "'";
            var linkElement = editorControl.DOM.createElement('<a href="' + resultArray["linkUrl"] + '" >' + '</a>');
            linkElement.setAttribute( "target", resultArray["linkWindow"] );

            if ( resultArray["linkClass"] != -1 )
                linkElement.className = resultArray["linkClass"];


            if ( resultArray["linkID"] != "" )
                linkElement.setAttribute( "id", resultArray["linkID"] );
            if ( resultArray["linkTitle"] != "" )
                linkElement.setAttribute( "title", resultArray["linkTitle"] );

            var customAttributesValue = createCustomAttrString( resultArray["customAttributes"] );

            if ( customAttributesValue != '' )
                linkElement.setAttribute( "customAttributes", customAttributesValue );

            var optionalAttributes = "";
            if ( imageClass != null )
                  optionalAttributes += " class='" + imageClass + "'";
            if ( imageHtmlID != null )
                  optionalAttributes += " html_id='" + imageHtmlID + "'";
            if ( imageViewMode != null )
                  optionalAttributes += " view='" + imageViewMode + "'";
           /* if ( imageClass != null )
                linkElement.innerHTML = '<img id="' + imageID + '" src="' + imageSource + '" align="' + imageAlignment + '"' + ' ezclass="'
            + imageClass + '"' + ' alt="' + imageSize   + '" ' + imageAttributes + '>';
            else
                linkElement.innerHTML = '<img id="' + imageID + '" src="' + imageSource + '" align="' + imageAlignment + '"'
            + ' alt="' + imageSize   + '" ' + imageAttributes + '>';*/
            linkElement.innerHTML = '<img id="' + imageID + '" src="' + imageSource + '" align="' + imageAlignment + '"' + optionalAttributes + ' alt="' + imageSize   + '" ' + imageAttributes + '>';
            imageElement.replaceNode( linkElement );
        }
    }
    else
    {
      if ( selectionRange.parentElement().tagName == "A" )
      {
        selectionRange.moveToElementText( selectionRange.parentElement() );
        selectionRange.select();
        argArray["linkUrl"] = selectionRange.parentElement().href;
        argArray["linkClass"] = selectionRange.parentElement().className;
        argArray["linkView"] = selectionRange.parentElement().getAttribute( 'view' );


        argArray["linkTitle"] = selectionRange.parentElement().title;
        argArray["linkID"] = selectionRange.parentElement().id;

        if ( argArray["linkClass"] == "" || argArray["linkClass"] == null )
            argArray["linkClass"] = -1;

        if ( argArray["linkView"] == "" || argArray["linkView"] == null )
            argArray["linkView"] = -1;

        argArray["customAttributes"] = selectionRange.parentElement().customAttributes;
        if ( argArray["customAttributes"] == null )
            argArray["customAttributes"] = -1;

        var url = argArray["linkUrl"];
        var urlString = url.toString();
        var linkType ="";
        argArray["linkWindow"] = selectionRange.parentElement().target;

        if( urlString.match(/http/g) )
        {
            linkType = "http:\/\/";
        }
        else if ( urlString.match(/mailto/g) )
        {
            linkType = "mailto:";
        }
        else if ( urlString.match(/file/g) )
        {
            linkType = "file:\/\/";
            argArray["linkUrl"] = argArray["linkUrl"].replace( /\\\\/, "" );
            while ( argArray["linkUrl"].match(/\\/) )
            {
               argArray["linkUrl"] = argArray["linkUrl"].replace( /\\/, "\/" );
            }
        }
        else if ( urlString.match(/ftp/g) )
        {
            linkType = "ftp:\/\/";
        }
        else if ( urlString.match(/https/g) )
        {
            linkType = "https:\/\/";
        }
        else if ( urlString.match(/eznode/g) )
        {
              linkType = "eznode:\/\/";
        }
        else if ( urlString.match(/ezobject/g) )
        {
              linkType = "ezobject:\/\/";
        }
        else
        {
            linkType = "";
        }
        argArray["linkType"] = linkType;
      }
        else
        {
          argArray["linkUrl"] = "";
          argArray["linkType"] = "";
          argArray["linkClass"] = -1;
          argArray["linkView"] = -1;
          argArray["linkWindow"] = "_self";

          argArray["linkTitle"] = "";
          argArray["linkID"] = "";

          argArray["customAttributes"] = -1;

          isNew = 1;
        }

        // If we have selected something, put the selected text in the input window
        if ( selectionRange.text != "" )
        {
          argArray["linkText"] = selectionRange.text;
        }
        else
        {
          argArray["linkText"] = "";
        }
        // Ask for the link details.
        var linkArray = showModalDialog( editorControl.customLink["url"] + isNew, argArray, editorControl.customLink["parameters"] );

        if ( linkArray == null ) { return; }

        var selection = editorControl.DOM.selection;
        var selectionRange = selection.createRange();

        var optionalParameters = "";

        if (  linkArray["linkTitle"] != "" )
        {
            optionalParameters += ' title="' + linkArray["linkTitle"] + '"';
        }
        if (  linkArray["linkID"] != "" )
        {
            optionalParameters += ' id="' + linkArray["linkID"]  + '"';
        }

        if ( linkArray["linkView"] != -1 )
        {
            optionalParameters += ' view="' + linkArray["linkView"]  + '"';
        }

        var customAttributesValue = createCustomAttrString( linkArray["customAttributes"] );

        if ( customAttributesValue != "" )
            customAttributesValue = ' customAttributes="' + customAttributesValue + '"';

        if ( linkArray["linkClass"] != -1 )
            selectionRange.pasteHTML('<a class="' + linkArray["linkClass"] + '" href="' + linkArray["linkUrl"] + '" target="' + linkArray["linkWindow"] + '"' + optionalParameters + customAttributesValue + '>' + linkArray["linkText"] + '</a>');
        else
            selectionRange.pasteHTML('<a href="' + linkArray["linkUrl"] + '" target="' + linkArray["linkWindow"] + '"' + optionalParameters + customAttributesValue + '>' + linkArray["linkText"] + '</a>');
    }
}

function insertAnchor( objectRef )
{
    var objectControl = document.all[objectRef];
    var argArray = new Array();
    var selection = objectControl.DOM.selection;
    var selectionRange = selection.createRange();

    // If we choose an existing anchor image, put its information in the input window
    if ( selectionRange.length == 1 )
    {
        if ( selectionRange.item(0).tagName == "IMG")
        {
            selectedImage = selectionRange.item(0);
            var imageSource = selectedImage.src;
            var imageType = selectedImage.type;
            var imageName = selectedImage.name;
            argArray["imgSrc"] = imageSource;
            argArray["imgName"] = imageName;
            argArray["imgType"] = imageType;

            argArray["customAttributes"] = selectedImage.customAttributes;
            if ( argArray["customAttributes"] == null )
                argArray["customAttributes"] = -1;

            if ( imageType == "anchor" )
            {
                var resultArray = showModalDialog( objectControl.customAnchor["url"], argArray, objectControl.customAnchor["parameters"] );
                var isChanged = false;
                if ( resultArray == null ) { return; }
                if ( resultArray["imgName"] != argArray["imgName"] )
                {
                    isChanged = true;
                }
                /*if ( resultArray["customAttributes"] != argArray["customAttributes"] )
                {
                    isChanged = true;
                }*/
                if ( isChanged )
                {
                    selectionRange.execCommand('Delete');
                }
            }
            else
            {
                alert( textStrings["SelectedImageTypeIsNotAnchor"] );
            }
        }
    }
    else
    {
        argArray["imgSrc"] = "";
        argArray["imgName"] = "";
        argArray["imgType"] = "";
        argArray["customAttributes"] = -1;
        var resultArray = showModalDialog( objectControl.customAnchor["url"],  argArray, objectControl.customAnchor["parameters"] );
    }

    var customAttributesValue = createCustomAttrString( resultArray["customAttributes"] );

    if ( customAttributesValue != "" )
        customAttributesValue = ' customAttributes="' + customAttributesValue + '"';

    if ( resultArray == null ) { return; }

    if ( resultArray["imgName"] == null ) { return; }

    var selection = objectControl.DOM.selection;
    var selectionRange = selection.createRange();
    if ( selectionRange.length != 1 )
       selectionRange.pasteHTML('<img src="' + resultArray["imgSrc"] + '" name="' + resultArray["imgName"] + '" type="' + resultArray["imgType"] + '"' + customAttributesValue + ' />' );

}

function insertCharacter ( objectRef )
{
    var objectControl = document.all[objectRef];
    var selection = objectControl.DOM.selection;
    var selectionRange = selection.createRange();
    var argArray = new Array();
    var resultArray = showModalDialog( objectControl.customCharacter["url"], argArray, objectControl.customCharacter["parameters"] );
    if ( resultArray == null ) { return; }
    if ( selectionRange.length != 1 )
        selectionRange.pasteHTML( resultArray['charValue'] );
}


function isHeader( editorControl )
{
    // Get current paragraph format
    var blockFormatNow = editorControl.ExecCommand( DECMD_GETBLOCKFMT, OLECMDEXECOPT_DODEFAULT );
//    var blockFormatNames = editorControl.paragraphStyles;

    // If the current paragraph is one of the headers, return true
    if ( blockFormatNow == "Heading 1" ||
         blockFormatNow == "Heading 2" ||
         blockFormatNow == "Heading 3" ||
         blockFormatNow == "Heading 4" ||
         blockFormatNow == "Heading 5" ||
         blockFormatNow == "Heading 6" )
    {
        return true;
    }
    else
    {
        return false;
    }
}

/*!
    Test if the browser can use this editor
    We need IE 5.5+ (Windows)
*/
function testBrowser()
{
    var browserAgent = navigator.userAgent;

    // Using Internet Explorer on Windows?
    if ( browserAgent.indexOf('MSIE') > 0
        && browserAgent.indexOf('Windows') > 0 )
    {
        var browserVersion = Array();
        browserVersion = browserAgent.split(";");

        // Using Version >= 5.5?
        if ( browserVersion[1].substr(6,3) >= 5.5 )
        {
            return true;
        }
        else
        {
            return false;
        }
      }
      else
      {
          return false;
      }
}
