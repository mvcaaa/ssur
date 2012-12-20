//
// Javascript HTML WYSIWYG Editor
//
// Created on: <25-Oct-2002 11:34:57 kd>
//
// Copyright (C) 1999-2003 eZ systems as. All rights reserved.
//


/*! \file ezhtmleditor.js
    WYSIWYG HTML editor written in Javascript
*/

// ***************************************************************************
// ********************* Definition of some constants ************************
// ***************************************************************************

var DECMD_BOLD =                   "bold";   var DECMD_DELETE =             "delete";
var DECMD_DELETECELLS =            5005;     var DECMD_DELETECOLS =         "deletecol";
var DECMD_DELETEROWS =             "deleterow";     var DECMD_FINDTEXT =           5008;
var DECMD_FONT =                   5009;     var DECMD_GETBACKCOLOR =       5010;
var DECMD_GETBLOCKFMT =            5011;     var DECMD_GETBLOCKFMTNAMES =   5012;
var DECMD_GETFONTNAME =            5013;     var DECMD_GETFONTSIZE =        5014;
var DECMD_GETFORECOLOR =           5015;     var DECMD_HYPERLINK =          5016;
var DECMD_IMAGE =                  5017;     var DECMD_INDENT =             "indent";
var DECMD_INSERTCELL =             5019;     var DECMD_INSERTCOL =          "insertcol";
var DECMD_INSERTROW =              "insertrow";     var DECMD_INSERTTABLE =        5022;
var DECMD_ITALIC =                 "italic"; var DECMD_JUSTIFYCENTER =      5024;
var DECMD_JUSTIFYLEFT =            5025;     var DECMD_JUSTIFYRIGHT =       5026;
var DECMD_LOCK_ELEMENT =           5027;     var DECMD_MAKE_ABSOLUTE =      5028;
var DECMD_MERGECELLS =             "mergecell";  var DECMD_ORDERLIST =      "insertorderedlist";
var DECMD_OUTDENT =            "outdent";    var DECMD_PASTE =              5032;
var DECMD_REDO =                   "redo";   var DECMD_REMOVEFORMAT =       5034;
var DECMD_SELECTALL =              5035;     var DECMD_SEND_BACKWARD =      5036;
var DECMD_BRING_FORWARD =          5037;     var DECMD_SEND_BELOW_TEXT =    5038;
var DECMD_BRING_ABOVE_TEXT =       5039;     var DECMD_SEND_TO_BACK =       5040;
var DECMD_BRING_TO_FRONT =         5041;     var DECMD_SETBACKCOLOR =       5042;
var DECMD_SETBLOCKFMT =            5043;     var DECMD_SETFONTNAME =        5044;
var DECMD_SETFONTSIZE =            5045;     var DECMD_SETFORECOLOR =       5046;
var DECMD_SPLITCELL =              "splitcell";     var DECMD_UNDERLINE =          5048;
var DECMD_UNDO =                  "undo";    var DECMD_UNLINK =           "unlink";
var DECMD_UNORDERLIST = "insertunorderedlist"; var DECMD_PROPERTIES =     5052;

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

var CUSTOM_INSERTOBJECT =             -2;  var CUSTOM_INSERTLINK  =           -3;
var CUSTOM_INSERTTABLE =             -4;  var CUSTOM_INSERTANCHOR =           -5;
var CUSTOM_INSERTCUSTOMTAG =             -6;  var CUSTOM_SETTH =                   -7;
var CUSTOM_INSERTLITERAL =             -8;  var CUSTOM_INSERTCUSTOMCLASS =   -9;
var CUSTOM_CELLPROPERTIES =             -10; var CUSTOM_HELP =                   -11;
var CUSTOM_MERGEDOWN =               -12; var CUSTOM_REMOVELINK =        -13;
var CUSTOM_INSERTCHARACTER =         -14;
// ***************************************************************************
// ************************** End of constants *******************************
// ***************************************************************************

/*!
    Constructor of object eZEditor
*/
function eZEditor( fieldName, extensionPath, imagePath, version, objectID, objectVersion, indexDir, eZPublishVersion )
{
    // Textarea field
    var textareaField = document.getElementById( fieldName );

    // Add functions to object
    this.startEditor = startEditor;
    this.createToolbar = createToolbar;
    this.createStatusbar = createStatusbar;

    this.fieldName = fieldName;
    this.editorID = "eZEditor_" + fieldName;

    // Set editing object id
    this.objectID = objectID;

    // Set editing object version
    this.objectVersion = objectVersion;

    // Set index directory
    this.indexDir = indexDir === '/' ? '' : indexDir;

    this.extensionPath = extensionPath;

    this.width = textareaField.cols*7;
    this.height = textareaField.rows*17;

    // Set path to images
    this.imagePath = imagePath; //extensionPath + 'design/standard/images/ezdhtml/';

    this.eZPublishVersion = eZPublishVersion;
    this.OEVersion = version;

    // Set input text
    if ( textareaField.value == "" )
    {
        this.content = "";
    }
    else
    {
        this.content = textareaField.value;
    }

    // Toolbar array
    this.toolbar = new Array();

    this.toolbar.push( { title: textStrings["Undo"], image: "undo.gif", cmdid: DECMD_UNDO,
                         action: "executeCommand" } );
    this.toolbar.push( { title: textStrings["Redo"], image: "redo.gif", cmdid: DECMD_REDO,
                         action: "executeCommand" } );

    this.toolbar.push( { action: "New Section" } );

    this.toolbar.push( { title: textStrings["Bold"], image: "bold.gif", cmdid: DECMD_BOLD,
                         action: "executeCommand" } );
    this.toolbar.push( { title: textStrings["Italic"], image: "italic.gif", cmdid: DECMD_ITALIC,
                         action: "executeCommand" } );

    this.toolbar.push( { action: "New Section" } );

    this.toolbar.push( { title: textStrings["Numbered"], image: "numlist.gif", cmdid: DECMD_ORDERLIST,
                         action: "executeCommand" } );
    this.toolbar.push( { title: textStrings["BulletList"], image: "bullist.gif", cmdid: DECMD_UNORDERLIST,
                         action: "executeCommand" } );
    this.toolbar.push( { title: textStrings["DecreaseListIndent"], image: "reduce_indent.gif", cmdid: DECMD_OUTDENT,
                         action: "executeCommand" } );
    this.toolbar.push( { title: textStrings["IncreaseListIndent"], image: "indent.gif", cmdid: DECMD_INDENT,
                         action: "executeCommand" } );

    this.toolbar.push( { action: "New Section" } );

    this.toolbar.push( { title: textStrings["InsertObject"], image: "object.gif", cmdid: CUSTOM_INSERTOBJECT,
                         action: "insertObject", options: this.customObject } );


    this.toolbar.push( { title: textStrings["InsertLink"], image: "link.gif", cmdid: CUSTOM_INSERTLINK,
                         action: "linkDialog" } );
    this.toolbar.push( { title: textStrings["InsertAnchor"], image: "anchor.gif", cmdid: CUSTOM_INSERTANCHOR,
                         action: "insertAnchor" } );
    this.toolbar.push( { title: textStrings["InsertCustomTag"], image: "customtag.gif", cmdid: CUSTOM_INSERTCUSTOMTAG,
                         action: "newCustomTag" } );
    this.toolbar.push( { title: textStrings["InsertLiteral"], image: "literal.gif", cmdid: CUSTOM_INSERTLITERAL,
                         action: "insertLiteralText" } );

    this.toolbar.push( { title: textStrings["InsertSpecialCharacter"], image: "special.gif", cmdid: CUSTOM_INSERTCHARACTER,
                         action: "insertCharacter" } );

    // Table toolbar
    this.toolbar.push( { action: "New Section" } );
    this.toolbar.push( { title: textStrings["InsertTable"], image: "table.gif", cmdid: DECMD_INSERTTABLE,
                         action: "newTable" } );
    this.toolbar.push( { title: textStrings["InsertRow"], image: "insrow.gif", cmdid: DECMD_INSERTROW,
                         action: "insertRow" } );
    this.toolbar.push( { title: textStrings["InsertColumn"], image: "inscol.gif", cmdid: DECMD_INSERTCOL,
                         action: "insertCol" } );
    this.toolbar.push( { title: textStrings["DeleteRow"], image: "delrow.gif", cmdid: DECMD_DELETEROWS,
                         action: "deleteRow" } );
    this.toolbar.push( { title: textStrings["DeleteColumn"], image: "delcol.gif", cmdid: DECMD_DELETECOLS,
                         action: "deleteCol" } );
    this.toolbar.push( { title: textStrings["SplitCell"], image: "splitcell.gif", cmdid: DECMD_SPLITCELL,
                         action: "splitCell" } );
    this.toolbar.push( { title: textStrings["MergeCell"], image: "mergecell.gif", cmdid: DECMD_MERGECELLS,
                         action: "mergeCell" } );

    this.toolbar.push( { action: "New Section" } );

    this.toolbar.push( { title: textStrings["Help"], image: "help.gif", cmdid: CUSTOM_HELP,
                         action: "showHelpWindow" } );
}

function startEditor()
{
    // Create toolbar HTML
    var editorToolbar = this.createToolbar();
    document.write( editorToolbar );
    var iframeWidth = this.width - 5;
    document.writeln('<input id="contextMenu_position" type="hidden" value=0 />' );
//    document.writeln('<iframe id="' + this.editorID + '" name="' + this.editorID + '" width="' + iframeWidth + '" height="' + this.height + '"></iframe>');
    document.writeln('<iframe id="' + this.editorID + '" name="' + this.editorID + '" width="99.5%" height="' + this.height + '"></iframe>');

    if ( !this.content )
    {
        this.content = "<p><br class='ignore'/></p>";
    }

    var editorDoc = document.getElementById(this.editorID).contentWindow.document;
    //var serverAddress = location.protocol + "//" + location.host;
    var frameHtml = "<html>\n";
    frameHtml += "<head id='head_" + this.editorID + "'>\n";
    for( var i=0; i < EditorCSSFileList.length; i++ )
    {
        frameHtml += '<link rel="stylesheet" type="text/css" href="' + EditorCSSFileList[i] + '">';
    }
    frameHtml += "</head>\n";
    frameHtml += "<body>";
    frameHtml += this.content;
    frameHtml += "</body>\n";
    frameHtml += "</html>";
    editorDoc.open();
    editorDoc.write(frameHtml);
    editorDoc.close();
    var editorStatusbar = this.createStatusbar();
    document.write( editorStatusbar );

    var editorID = this.editorID;
    var indexDir = this.indexDir;
    var objectID = this.objectID;
    var objectVersion = this.objectVersion;

    editorDoc.addEventListener("keypress", changeToParagraph, false);
    //editorDoc.addEventListener("keypress", eventDisplayChanged, false);
    //editorDoc.addEventListener("mouseout", eventUpdateStatus, false);
    //editorDoc.addEventListener("keyup", correctKeyBehavior, false);
    editorDoc.addEventListener("blur", eventUpdateContent, false);
    editorDoc.addEventListener("keyup", eventUpdateStatus, false);
    editorDoc.addEventListener("mouseup", eventUpdateStatus, false);
    editorDoc.addEventListener("drag", eventUpdateStatus, false);

    editorDoc.addEventListener( "contextmenu", disableDefaultContextMenu, false );
    editorDoc.addEventListener( "mousedown", removeContextMenu, false);
    editorDoc.addEventListener( "contextmenu", function(){ showContextMenu( editorID,indexDir,objectID,objectVersion);}, false);
    editorDoc.editorID = editorID;

    setTimeout(function(){enableDesignMode( editorID);}, 500 );
}

function getEditorIDFromEvent( evt )
{
    var headID = evt.currentTarget.firstChild.firstChild.getAttribute( 'id' );
    var editorID = headID.substr( 5 );
    return editorID;
}

function enableDesignMode( editorID )
{
     var editorWindow = document.getElementById(editorID).contentWindow;
     try
     {
         editorWindow.document.designMode = "on";
         //editorWindow.focus();
         displayChanged( editorID );
     }
     catch(e)
     {
         setTimeout( function(){enableDesignMode( editorID);}, 500 );
     }
}

function correctCursorPos( editorID )
{
    var editorControl = document.getElementById(editorID).contentWindow;
    var sel = editorControl.getSelection();

    // moving outside the link or span
    var fNode = sel.focusNode;
    if ( !fNode )
        return;

    var parent = fNode.parentNode;

    if ( parent.nodeName == 'A' || parent.nodeName == 'SPAN' )
    {
        var lastInlineParent = parent;
        if ( sel.focusOffset == fNode.length &&
             ( !fNode.nextSibling || fNode.nextSibling.data == '' || fNode.nextSibling.data == ' ' ||
               fNode.nextSibling.nodeName == 'BR' ) )
        {
            while( parent.nodeName == 'A' ||
                   parent.nodeName == 'SPAN' )
            {
                if ( parent.nextSibling && parent.nextSibling.data != '' && parent.nextSibling.data != ' '
                     && parent.nextSibling.nodeName != 'BR' )
                    break;

                lastInlineParent = parent;
                parent = parent.parentNode;
            }

            var newRange = document.createRange();
            //newRange.collapse();
            newRange.setStartAfter( lastInlineParent );
            sel.removeAllRanges();
            sel.addRange( newRange );
        }

        if ( sel.focusOffset == 0 &&
             ( !fNode.previousSibling || fNode.previousSibling.data == '' || fNode.previousSibling.data == ' ' ||
               fNode.previousSibling.nodeName == 'BR' ) )
        {
            while( parent.nodeName == 'A' ||
                parent.nodeName == 'SPAN' )
            {
                if ( parent.previousSibling && parent.previousSibling.data != '' && parent.previousSibling.data != ' '
                  && parent.previousSibling.nodeName != 'BR' )
                 break;

                lastInlineParent = parent;
                parent = parent.parentNode;
            }

            var newRange = document.createRange();
            //newRange.collapse();
            newRange.setStartBefore( lastInlineParent );
            sel.removeAllRanges();
            sel.addRange( newRange );
        }
    }

    /*
    var parent = fNode.parentNode;
    var lastInlineParent = parent;

    if ( sel.focusOffset == fNode.length &&
         ( !fNode.nextSibling || fNode.nextSibling.data == '' || fNode.nextSibling.data == ' ' ) &&
         ( parent.nodeName == 'A' || parent.nodeName == 'SPAN' ) )
    {
        do
        {
            if ( parent.nextSibling && parent.nextSibling.data != '' && parent.nextSibling.data != ' ' &&
                 parent.nextSibling.nodeName != 'BR' )
                return;

            lastInlineParent = parent;
            parent = parent.parentNode;
        }
        while( ( parent.nodeName == 'A' ||
                 parent.nodeName == 'SPAN' ) );

        var newRange = document.createRange();
        //newRange.collapse();
        newRange.setStartAfter( lastInlineParent );
        sel.removeAllRanges();
        sel.addRange( newRange );
    }*/
}

function changeToParagraph ( evt )
{
    var editorID = getEditorIDFromEvent( evt );
    var editorControl = document.getElementById(editorID).contentWindow;

    /*/ Debug mode: printing key code in status bar
    var editorControl = document.getElementById(editorID).contentWindow;
    var classInfo = document.getElementById('statusbar_class_' + editorID);
    classInfo.innerHTML = evt.keyCode;
    */
    if ( evt.keyCode == 13 )
    {
        correctCursorPos( editorID );

        if ( evt.shiftKey )
            return;

        var selection = editorControl.getSelection();

        var rngLeft = document.createRange();
        var rngRight = document.createRange();
        rngLeft.setStart(selection.anchorNode, selection.anchorOffset);
        rngRight.setStart(selection.focusNode, selection.focusOffset);
        rngLeft.collapse(true);
        rngRight.collapse(true);
        var direct = rngLeft.compareBoundaryPoints(rngLeft.START_TO_END, rngRight) < 0;

        var startNode = direct ? selection.anchorNode : selection.focusNode;
        var startOffset = direct ? selection.anchorOffset : selection.focusOffset;
        var endNode = direct ? selection.focusNode : selection.anchorNode;
        var endOffset = direct ? selection.focusOffset : selection.anchorOffset;
        var startBlock = parentBlock(startNode);
        var endBlock = parentBlock(endNode);
        var attrsLeft = new Array();
        var attrsRight = new Array();
        var chopHeader = false;

        var startName = startBlock.tagName;
        var endName = endBlock.tagName;

        if ( startName == 'LI' || endName == 'LI' )
            return;

        if ( /^H\d$/i.test( startName ) || /^H\d$/i.test( endName ) )
        {
            if( selection.anchorOffset == 0 )
            {
                var range = document.createRange();
                range.setEndBefore( startBlock );
                var pNode = document.createElement('p');
                pNode.innerHTML = '<br class="ignore">';
                range.insertNode(pNode);

                var newRange = document.createRange();
                newRange.setStart(pNode, 0);
                newRange.collapse(true);

                sel = editorControl.getSelection();
                sel.removeAllRanges();
                sel.addRange(newRange);
                evt.preventDefault();
                evt.stopPropagation();
                return;
            }

            /*var selectionOffset = selection.anchorOffset + 1;
            selection.selectAllChildren(selection.focusNode.parentNode);

            var extentedSelection = editorControl.getSelection();
            var headerString =  extentedSelection.toString();
            extentedSelection.collapseToEnd();
            if ( selectionOffset < headerString.length )
            {
                chopHeader = true;
            }
            */

            if ( !chopHeader )
            {
                var range = document.createRange();
                range.setEndAfter( endBlock );
                var pNode = document.createElement('p');
                pNode.innerHTML = '<br class="ignore">';
                range.insertNode(pNode);

                var newRange = document.createRange();
                newRange.setStart(pNode, 0);
                newRange.collapse(true);

                sel = editorControl.getSelection();
                sel.removeAllRanges();
                sel.addRange(newRange);
                evt.preventDefault();
                evt.stopPropagation();
                return;
            }
        }

        if ( startBlock.tagName == 'P' )
        {
            for (var i = 0; i < startBlock.attributes.length; i++)
            {
                attrsLeft[startBlock.attributes[i].nodeName] = startBlock.attributes[i].nodeValue;
            }
        }

        if ( endBlock.tagName == 'P' )
        {
            for (var i = 0; i < endBlock.attributes.length; i++)
            {
                if (endBlock != startBlock || endBlock.attributes[i].nodeName.toLowerCase() != 'id')
                    attrsRight[endBlock.attributes[i].nodeName] = endBlock.attributes[i].nodeValue;
            }
        }

        var startChop = startNode;
        if ( startNode.nodeName == 'P' || startNode.nodeName == 'BODY' || startNode.nodeName == 'TD' )
        {
            startChop = startNode.firstChild;
        }
        else
        {
                while ( ( startChop.previousSibling && ( startChop.previousSibling.tagName != 'P' ) )
                        || ( startChop.parentNode && startChop.parentNode != startBlock && startChop.parentNode.nodeType != 9 ) )
                {
                    startChop = startChop.previousSibling ? startChop.previousSibling : startChop.parentNode;
                }
        }

        var endChop = endNode;
        if ( endNode.nodeName == 'P' || endNode.nodeName == 'BODY' || endNode.nodeName == 'TD' )
        {
            endChop = endNode.lastChild;
        }
        else
        {
                while ( ( endChop.nextSibling && ( endChop.nextSibling.tagName != 'P' && endChop.nextSibling.tagName != 'BR' ) )
                        || ( endChop.parentNode && endChop.parentNode != endBlock && endChop.parentNode.nodeType != 9 ) )
                {
                    endChop = endChop.nextSibling ? endChop.nextSibling : endChop.parentNode;
                }
        }
        var pLeft = document.createElement('p');
        var pRight = document.createElement('p');
        for ( var attrName in attrsLeft)
        {
                var thisAttr = document.createAttribute(attrName);
                thisAttr.value = attrsLeft[attrName];
                pLeft.setAttributeNode(thisAttr);
        }

        for (var attrName in attrsRight)
        {
                var thisAttr = document.createAttribute(attrName);
                thisAttr.value = attrsRight[attrName];
                pRight.setAttributeNode(thisAttr);
        }
        rngLeft.setStartBefore( startChop );
        rngLeft.setEnd( startNode, startOffset );
        var leftPart = rngLeft.cloneContents();

        if ( leftPart.firstChild && leftPart.firstChild.nodeType == 3 && leftPart.firstChild.data == '' )
        {
            leftPart.removeChild( leftPart.firstChild );
        }
        if ( leftPart.childNodes.length == 0 )
        {
            leftPart = document.createElement('br');
        }
        pLeft.appendChild( leftPart );

        rngRight.setEndAfter(endChop);
        rngRight.setStart( endNode, endOffset );
        var rightPart = rngRight.cloneContents();

        if ( rightPart.firstChild && rightPart.firstChild.nodeType == 3 && rightPart.firstChild.data == '' )
        {
            rightPart.removeChild( rightPart.firstChild );
        }
        if ( rightPart.childNodes.length == 0 )
        {
            rightPart = document.createElement('br');
        }
        pRight.appendChild( rightPart );

        // Get a range for everything to be replaced and replace it
        var rngAround = document.createRange();
        if (!startChop.previousSibling && startChop.parentNode.tagName.toLowerCase() == 'p' )
                rngAround.setStartBefore(startChop.parentNode);
        else
                rngAround.setStart(rngLeft.startContainer, rngLeft.startOffset);

        if (!endChop.nextSibling && endChop.parentNode.tagName.toLowerCase() == 'p' )
                rngAround.setEndAfter(endChop.parentNode);
        else
                rngAround.setEnd(rngRight.endContainer, rngRight.endOffset);
        rngAround.deleteContents();
        rngAround.insertNode(pRight);
        rngAround.insertNode(pLeft);

        if (pRight.firstChild)
        {
            if( ( pRight.firstChild.data == "" || pRight.firstChild.data == " " ) && pRight.firstChild.nodeType == 3  )
            {
                pRight.innerHTML = "<br class='ignore' />";
            }

            if( pRight.firstChild.innerHTML == "" && /^(a|b|em|i|q|s|span|strike|strong|sub|sup|u)$/i.test(pRight.firstChild.nodeName) )
            {
                pRight.firstChild.innerHTML = "<br class='ignore' />";
            }
            while ( pRight.firstChild && /^(a|b|em|i|q|s|span|strike|strong|sub|sup|u)$/i.test(pRight.firstChild.nodeName) &&  pRight.firstChild.nodeType != 3 )
            {
                pRight = pRight.firstChild;
            }

            if( ( pRight.firstChild.data == "" || pRight.firstChild.data == " " ) && pRight.firstChild.nodeType == 3  )
            {
                pRight.innerHTML = "<br class='ignore' />";
            }

            var newRange = document.createRange();
            newRange.setStart(pRight, 0);
            newRange.collapse(true);

            sel = editorControl.getSelection();
            sel.removeAllRanges();
            sel.addRange(newRange);

        }
        evt.preventDefault();
        evt.stopPropagation();
    }
    else
    {
        /*if ( evt.keyCode == 0 )
        {
            // remove last <br />
            var para = getElement( selection.focusNode, 'P' );
            var last = para.lastChild;
            if ( last.nodeName == 'BR' ||
                 ( last.nodeName == 'SPAN' && last.childNodes.length == 0 ) )
            {
                para.removeChild( last );
            }
        }*/
        /*var selection = editorControl.getSelection();

        var next = selection.focusNode.nextSibling;
        if ( next.nodeName == 'SPAN' && next.innerHTML == '' )
        {
            next.parentNode.removeChild( next );
        }

        var prev = selection.focusNode.previousSibling;
        if ( prev.nodeName == 'SPAN' && prev.innerHTML == '' )
        {
            prev.parentNode.removeChild( prev );
        }*/
        if ( evt.keyCode == 8 )
        {
            var sel = editorControl.getSelection();
            var parent = sel.focusNode.parentNode;
            if ( sel.focusOffset == 1 && ( parent.nodeName == 'SPAN' || parent.nodeName == 'A' ) && parent.innerHTML.length == 1 )
            {
                parent.parentNode.removeChild( parent );
                evt.preventDefault();
            }
        }
        if ( evt.keyCode == 46 )
        {
            var sel = editorControl.getSelection();
            var parent = sel.focusNode.parentNode;
            if ( sel.focusOffset == 0 && ( parent.nodeName == 'SPAN' || parent.nodeName == 'A' ) && parent.innerHTML.length == 1 )
            {
                parent.parentNode.removeChild( parent );
                evt.preventDefault();
            }
        }
    }
}

// temporary
/*
function correctKeyBehavior( evt )
{
    var editorID = evt.target.ownerDocument.editorID;
    var editorControl = document.getElementById(editorID).contentWindow;

    var selection = editorControl.getSelection();

    if ( evt.keyCode == 8 )
    {
        var currentNode = selection.focusNode;
        //alert( currentNode.textContent + " node" );
        var next = currentNode.nextSibling;
        //alert( next.nodeName + " node" );
        if ( next.nodeName == 'BR' )
        {
            currentNode.parentNode.removeChild( next );
        }
    }
}
*/
function parentBlock ( node )
{
        while ( node.parentNode &&
                ( node.nodeType != 1 ||
                /^(a|b|em|i|q|s|span|strike|strong|sub|sup|u)$/i.test(node.tagName)))
        {
                node = node.parentNode;
        }
        return node;
}

/*!
    Create the toolbar of the editor
*/
function createToolbar()
{
    // Header for toolbar
    var toolbarTags = '<table'
//                    + ' width="' + this.width + '"'
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
                            + ' cellspacing="2"'
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
    toolbarTags += "<select id='" + this.editorID + "_select_header' onChange=changeHeading('" + this.editorID + "')>"
            + "   <option value='<p>' selected>"+textStrings["Normal"]+"</option>\n"
            + "   <option value='<h1>'>"+textStrings["Heading1"]+"</option>"
            + "   <option value='<h2>'>"+textStrings["Heading2"]+"</option>"
            + "   <option value='<h3>'>"+textStrings["Heading3"]+"</option>"
            + "   <option value='<h4>'>"+textStrings["Heading4"]+"</option>"
            + "   <option value='<h5>'>"+textStrings["Heading5"]+"</option>"
            + "   <option value='<h6>'>"+textStrings["Heading6"]+"</option>"
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
            if ( this.toolbar[i]["action"] == "executeCommand" )
            {
                var execCommand = this.toolbar[i]["action"] + "("
                                + "'" +  this.editorID + "'"
                                + ",\'" + this.toolbar[i]["cmdid"]
                                + "\','" + "'"
                                + ");";
            }
            else if ( this.toolbar[i]["action"] == "insertObject" )
            {
                var execCommand = this.toolbar[i]["action"] + "("
                                + "'" +  this.editorID + "'"
                                + ",'" + this.indexDir + "'"
                                + ",'" + this.objectID + "'"
                                + ",'" + this.objectVersion + "'"
                                + ");";
            }
            else
            {
                var execCommand = this.toolbar[i]["action"] + "("
                                + "'" + this.editorID + "'"
                                + ",'" + this.indexDir + "'"
                                + ");";
            }

            // Create the button
            // (buttons have the advantage over just images that they don't take the focus!)

            toolbarTags +=  '<button type="button"'
                            + ' id="' + this.editorID + this.toolbar[i]["cmdid"] + '"'
                            + ' onclick="' + execCommand + '"'
                            + ' onmouseover=toolbarButtonOver("' + this.editorID + this.toolbar[i]["cmdid"] + '");'
                            + ' onmouseout=toolbarButtonOut("' + this.editorID + this.toolbar[i]["cmdid"] + '");'
                            + ' title="' + this.toolbar[i]["title"] + '"'
                            + ' unselectable="on"'
                            + ' class="toolbarButton"'
                            + '>'
                            + '<img'
                            + ' src="' + this.imagePath + this.toolbar[i]["image"] + '"'
                            + ' style="margin-left: -1px; margin-top: -1px;"'
                            + ' title="' + this.toolbar[i]["title"] + '"'
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
    var button = document.getElementById(buttonID);
    if ( button.className == "toolbarButtonSelected" )
        button.className = "toolbarButtonOverSelected";
    else if ( button.className != "toolbarButtonOver" )
        button.className = "toolbarButtonOver";
    if ( button.title == textStrings["InsertLink"] || button.title == textStrings["MakeLink"] )
    {
        var editorID = buttonID.replace( "-3", "" );
            var editorControl = document.getElementById(editorID).contentWindow;
            var selection = editorControl.getSelection();
        if ( !selection.isCollapsed )
                button.title = textStrings["MakeLink"];
        else
                button.title = textStrings["InsertLink"];
    }
}

function toolbarButtonOut( buttonID )
{
    var button = document.getElementById(buttonID);
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
//                      + ' width="' + this.width + '"'
   + ' width="100%    "'
                      + ' border="1"'
                      + ' cellpadding="0"'
                      + ' cellspacing="0"'
                      + ' class="statusbar">'
                      + ' <tr><td colspan="3"'
                      + ' id="statusbar_' + this.editorID  + '" class="statusbarTD">'
                      + ' &nbsp;</td></tr>'
                      + ' <tr><td id="statusbar_info_' + this.editorID + '"'
                      + ' width="200" align="center" class="statusbarTD">'
                      + '</td>'
                      + ' <td id="statusbar_class_' + this.editorID + '"'
                      + ' width="110" align="center" class="statusbarTD">'
                      + ' ' + textStrings["ClassNone"]
                      +'</td>'
                      + '<td width="150" align="center" class="editorName"><img src="'
                      + this.imagePath + 'ezicon.gif" align="bottom"> Online Editor ' + this.OEVersion + '</td></tr></table>';

    // Return the finished HTML for the statusbar
    return statusbarTags;
}

function executeCommand( editorID, command, option )
{
    var        editorControl = document.getElementById( editorID ).contentWindow;

    try
    {
        var currentNode = this.findParentNode( editorID );
        if ( currentNode.tagName.toLowerCase() == "li" && ( command == "insertunorderedlist" || command == "insertorderedlist" ) )
        {
            if ( ( currentNode.parentNode.tagName.toLowerCase() == "ul" && command == "insertunorderedlist" ) ||
                 ( currentNode.parentNode.tagName.toLowerCase() == "ol" && command == "insertorderedlist" ) )
               command = "outdent";
        }
        editorControl.document.execCommand( command, false, option );
    } catch (e) {
        if ( command == "cut" || command == "copy" || command == "paste" )
        {
            if (confirm("Unprivileged scripts cannot invoke Cut, Copy or Paste commands " +
                    "for security reasons. Click OK to see how to change that."))
                window.open("http://mozilla.org/editor/midasdemo/securityprefs.html");
        }
    }
    updateToolbar( editorID );
    editorControl.focus();
}

/*!
    Changes the text heading in display
*/
function changeHeading( editorID )
{
    var editorControl = document.getElementById(editorID).contentWindow;
  /*  var selection = editorControl.getSelection();
    rng = selection.getRangeAt(selection.rangeCount - 1).cloneRange();*/
    var selectorName = editorID + "_select_header";
    var button_obj = document.getElementById( selectorName );

    var index = button_obj.selectedIndex;
    if ( index != null )
    {
        var selectedValue = button_obj[ index ].value;
    }
    var italicValue = editorControl.document.queryCommandState("italic");

    if ( italicValue )
        editorControl.document.execCommand( "italic", false, "" );

    var orderedlistValue = editorControl.document.queryCommandState("insertorderedlist");
    var unorderedlistValue = editorControl.document.queryCommandState("insertunorderedlist");
    if ( orderedlistValue || unorderedlistValue )
    {
        alert( textStrings["HeadingInsideListIsNotAllowed"] );
    }
    else
        editorControl.document.execCommand( "formatblock", false, selectedValue );
    updateToolbar( editorID );
    editorControl.focus();
}

/*!
    Gets called when the editor changed and updates textarea field.
*/
function eventUpdateContent( evt )
{
    var editorID = getEditorIDFromEvent( evt );
    updateContent( editorID );
}

function eventUpdateStatus( evt )
{
    var editorID = getEditorIDFromEvent( evt );
    updateToolbar( editorID );
    updateStatusbar( editorID );
}

function displayChanged( editorID )
{
    updateContent( editorID );
    updateToolbar( editorID );
    updateStatusbar( editorID );
}

function showContextMenu( editorID, indexDir, objectID, objectVersion )
{
    var menuItem = null;
    var editorFrame = document.getElementById(editorID);
    var editorControl = editorFrame.contentWindow;
    var div = document.createElement("div");
    div.id = "contextMenu";
    div.className = "context-menu";
    document.body.appendChild(div);
    var table =  document.createElement( "table" );
    div.appendChild(table);
    var tbody =  document.createElement( "tbody" );
    table.appendChild( tbody);
    // Set the context menu
    var contextMenuItems = this.buildContextMenu( editorID, indexDir, objectID, objectVersion );
    for ( var i=0; i<contextMenuItems.length; i++ )
    {
        menuItem = contextMenuItems[i];
        var menuName = menuItem.title;
        var menuAction = menuItem.action;
        var menuTr = document.createElement( "tr" );
        tbody.appendChild(  menuTr );
        var td = document.createElement( "td" );
        if ( menuName == textStrings["Separator"] )
        {
            menuTr.className = "separator";
        }
        else
        {
            menuTr.className = "menu-item";
            menuTr.contextAction = { action: menuItem["action"],
                                 activate: function() { this.action(); } };
            menuTr.onmouseover = function() { this.className = "menu-item hover"; };
            menuTr.onmouseout = function() { this.className = "menu-item"; };
            menuTr.onclick = function()
            {
                this.contextAction.activate();
                var cmenu = document.getElementById("contextMenu");
                cmenu.parentNode.removeChild(cmenu);
            };
            menuTr.oncontextmenu = function() { return false; };
            td.innerHTML = menuItem.title;
        }
        menuTr.appendChild(td);
    }

    var menuPositionValue = document.getElementById( "contextMenu_position" ).value;
    var menuPositionArray = menuPositionValue.split("_");
    var menuPositionX =  Math.round(menuPositionArray[0]);
    var menuPositionY =  Math.round(menuPositionArray[1]);
    var p = getPosition( editorFrame );
    if ( ( p.x + menuPositionX + div.offsetWidth - window.innerWidth - window.scrollX ) > 0 )
    {
        div.style.left = window.innerWidth + window.scrollX - div.offsetWidth - 10 + "px";
    }
    else
    {
        div.style.left =  p.x + menuPositionX + "px";
    }
    if ( ( p.y + menuPositionY + div.offsetHeight - window.innerHeight - window.scrollY ) > 0 )
    {
        div.style.top = window.innerHeight + window.scrollY - div.offsetHeight - 40 + "px";
    }
    else
    {
        div.style.top =  p.y + menuPositionY + "px";
    }
}


function buildContextMenu( editorID, indexDir, objectID, objectVersion )
{
    var editorControl = document.getElementById(editorID).contentWindow;
    var menu = new Array();
    var currentNode = this.findParentNode( editorID );
    var tableID = this.getTableID ( editorID );

    var textSelected = isTextSelected( editorID );
    var isInsideTH = isTH( editorID );

    if ( textSelected )
    {
            menu.push( { title: textStrings["Undo"], action: function(){executeCommand(editorID,"undo","");} } );
            menu.push( { title: textStrings["Separator"], action: "" } );
            menu.push( { title: textStrings["Cut"], action: function(){executeCommand(editorID,"cut","");} } );
            menu.push( { title: textStrings["Copy"], action: function(){executeCommand(editorID,"copy","");} } );
            menu.push( { title: textStrings["Paste"], action: function(){executeCommand(editorID,"paste","");} } );
             //menu.push( { title: textStrings["Delete"], action: function(){executeCommand(editorID,"delete","");} } );
            menu.push( { title: textStrings["Separator"], action: "" } );
            menu.push( { title: textStrings["SelectAll"], action: function(){executeCommand(editorID,"selectall","");} } );
            menu.push( { title: textStrings["Separator"], action: "" } );
            if ( currentNode.tagName.toLowerCase() == "a" )
            {
                menu.push( { title: textStrings["RemoveLink"], action: function(){removeLink(editorID);} } );
                menu.push( { title: textStrings["LinkProperties"], action: function(){linkDialog(editorID,indexDir);} } );
            }
            else
            {
                menu.push( { title: textStrings["InsertLink"], action: function(){linkDialog(editorID,indexDir);} } );
            }
    }
    else if ( currentNode.tagName == "IMG" )
    {
         var imageType = currentNode.getAttribute( 'type' );
         if ( imageType == null )
         {
             imageType = "object";
         }

         if ( imageType == "anchor" )
         {
             menu.push( { title: textStrings["Cut"], action: function(){executeCommand(editorID,"cut","");} } );
             menu.push( { title: textStrings["Copy"], action: function(){executeCommand(editorID,"copy","");} } );
             menu.push( { title: textStrings["Delete"], action: function(){executeCommand(editorID,"delete","");} } );
             menu.push( { title: textStrings["Properties"], action: function(){insertAnchor(editorID,indexDir);} } );
         }
         else if ( imageType == "custom" )
         {
             menu.push( { title: textStrings["Cut"], action: function(){executeCommand(editorID,"cut","");} } );
             menu.push( { title: textStrings["Copy"], action: function(){executeCommand(editorID,"copy","");} } );
             menu.push( { title: textStrings["Delete"], action: function(){executeCommand(editorID,"delete","");} } );
             menu.push( { title: textStrings["Properties"], action: function(){customTagProperties(editorID,indexDir);} } );
         }
         else if ( imageType == "object"        )
         {
             if (  currentNode.parentNode.tagName.toLowerCase() == "a" )
             {
                     menu.push( { title: textStrings["Cut"], action: function(){executeCommand(editorID,"cut","");} } );
                     menu.push( { title: textStrings["Copy"], action: function(){executeCommand(editorID,"copy","");} } );
                     menu.push( { title: textStrings["Delete"], action: function(){executeCommand(editorID,"delete","");} } );
                     menu.push( { title: textStrings["Properties"], action: function(){insertObject(editorID,indexDir,objectID,objectVersion);} } );
                     menu.push( { title: textStrings["Separator"], action: "" } );
                     menu.push( { title: textStrings["RemoveLink"], action: function(){removeLink(editorID);} } );
                     menu.push( { title: textStrings["LinkProperties"], action: function(){linkDialog(editorID,indexDir);} } );
             }
             else
             {
                     menu.push( { title: textStrings["Cut"], action: function(){executeCommand(editorID,"cut","");} } );
                     menu.push( { title: textStrings["Copy"], action: function(){executeCommand(editorID,"copy","");} } );
                     menu.push( { title: textStrings["Delete"], action: function(){executeCommand(editorID,"delete","");} } );
                     menu.push( { title: textStrings["Properties"], action: function(){insertObject(editorID,indexDir,objectID,objectVersion);} } );
                     menu.push( { title: textStrings["InsertLink"], action: function(){linkDialog(editorID,indexDir);} } );
             }
         }
    }
    else if ( tableID == "table" && currentNode.tagName != "IMG" && currentNode.tagName != "A" && currentNode.tagName != "SPAN" )
    {
            var currentTag = currentNode.tagName.toLowerCase();
            menu.push( { title: textStrings["Undo"], action: function(){executeCommand(editorID,"undo","");} } );
            menu.push( { title: textStrings["Separator"], action: "" } );
            menu.push( { title: textStrings["Cut"], action: function(){executeCommand(editorID,"cut","");} } );
            menu.push( { title: textStrings["Copy"], action: function(){executeCommand(editorID,"copy","");} } );
            menu.push( { title: textStrings["Paste"], action: function(){executeCommand(editorID,"paste","");} } );
            //menu.push( { title: textStrings["Delete"], action: function(){executeCommand(editorID,"delete","");} } );
            menu.push( { title: textStrings["Separator"], action: "" } );
            menu.push( { title: textStrings["SelectAll"], action: function(){executeCommand(editorID,"selectall","");} } );
            menu.push( { title: textStrings["Separator"], action: "" } );
            menu.push( { title: textStrings["InsertRow"], action: function(){insertRow(editorID);} } );
            menu.push( { title: textStrings["DeleteRow"], action: function(){deleteRow(editorID);} } );
            //menu.push( { title: textStrings["Separator"], action: "" } );
            menu.push( { title: textStrings["InsertColumn"], action: function(){insertCol(editorID);} } );
            menu.push( { title: textStrings["DeleteColumn"], action: function(){deleteCol(editorID);} } );
            menu.push( { title: textStrings["Separator"], action: "" } );
            menu.push( { title: textStrings["MergeCells"], action: function(){mergeCell(editorID);} } );
            menu.push( { title: textStrings["SplitCell"], action: function(){splitCell(editorID);} } );
            menu.push( { title: textStrings["Separator"], action: "" } );
            if ( isInsideTH )
            {
                menu.push( { title: textStrings["ChangeToTD"], action: function(){changeCellFormat(editorID);} } );
            }
            else
            {
                menu.push( { title: textStrings["ChangeToTH"], action: function(){changeCellFormat(editorID);} } );
            }
            menu.push( { title: textStrings["CellProperties"], action: function(){showTableCellProperty(editorID,indexDir);} } );
            menu.push( { title: textStrings["TableProperties"], action: function(){tableProperties(editorID,indexDir);} } );
            menu.push( { title: textStrings["Separator"], action: "" } );
            menu.push( { title: textStrings["InsertTable"], action: function(){newTable(editorID,indexDir);} } );
            if ( currentTag == "p" )
            {
                menu.push( { title: textStrings["InsertObject"], action: function(){insertObject(editorID,indexDir,objectID,objectVersion);} } );
                menu.push( { title: textStrings["InsertTable"], action: function(){newTable(editorID,indexDir);} } );
                menu.push( { title: textStrings["InsertLink"], action: function(){linkDialog(editorID,indexDir);} } );
                menu.push( { title: textStrings["InsertAnchor"], action: function(){insertAnchor(editorID,indexDir);} } );
                menu.push( { title: textStrings["InsertCustomTag"], action: function(){newCustomTag(editorID,indexDir);} } );
                menu.push( { title: textStrings["InsertLiteral"], action: function(){insertLiteralText(editorID,indexDir);} } );
            }
            else if ( currentTag == "h1" || currentTag == "h2" || currentTag == "h3" ||
                  currentTag == "h4" || currentTag == "h5" || currentTag == "h6" )
            {
                menu.push( { title: textStrings["InsertAnchor"], action: function(){insertAnchor(editorID,indexDir);} } );
                menu.push( { title: textStrings["Properties"], action: function(){showClassDialog(editorID,indexDir);} } );
            }
            else
            {
                menu.push( { title: textStrings["InsertLink"], action: function(){linkDialog(editorID,indexDir);} } );
                menu.push( { title: textStrings["InsertAnchor"], action: function(){insertAnchor(editorID,indexDir);} } );
                menu.push( { title: textStrings["InsertCustomTag"], action: function(){newCustomTag(editorID,indexDir);} } );
                menu.push( { title: textStrings["Properties"], action: function(){showClassDialog(editorID,indexDir);} } );
            }
    }
    else if ( tableID == "custom" )
    {
            menu.push( { title: textStrings["Cut"], action: function(){executeCommand(editorID,"cut","");} } );
            menu.push( { title: textStrings["Copy"], action: function(){executeCommand(editorID,"copy","");} } );
            //menu.push( { title: textStrings["Delete"], action: function(){executeCommand(editorID,"delete","");} } );
            menu.push( { title: textStrings["Properties"], action: function(){customTagProperties(editorID,indexDir);} } );
    }
    else if ( tableID == "literal" )
    {
            menu.push( { title: textStrings["Cut"], action: function(){executeCommand(editorID,"cut","");} } );
            menu.push( { title: textStrings["Copy"], action: function(){executeCommand(editorID,"copy","");} } );
            //menu.push( { title: textStrings["Delete"], action: function(){executeCommand(editorID,"delete","");} } );
            menu.push( { title: textStrings["Properties"], action: function(){insertLiteralText(editorID,indexDir);} } );
    }
    else if ( currentNode.tagName == "SPAN" && currentNode.getAttribute( 'type' ) == 'custom' )
    {
         menu.push( { title: textStrings["Cut"], action: function(){executeCommand(editorID,"cut","");} } );
         menu.push( { title: textStrings["Copy"], action: function(){executeCommand(editorID,"copy","");} } );
         menu.push( { title: textStrings["Delete"], action: function(){executeCommand(editorID,"delete","");} } );
         menu.push( { title: textStrings["Properties"], action: function(){customTagProperties(editorID,indexDir);} } );
    }
    else if ( currentNode.tagName == "H1" ||
              currentNode.tagName == "H2" ||
              currentNode.tagName == "H3" ||
              currentNode.tagName == "H4" ||
              currentNode.tagName == "H5" ||
              currentNode.tagName == "H6" )
    {
        menu.push( { title: textStrings["Undo"], action: function(){executeCommand(editorID,"undo","");} } );
        menu.push( { title: textStrings["Separator"], action: "" } );
        menu.push( { title: textStrings["Cut"], action: function(){executeCommand(editorID,"cut","");} } );
            menu.push( { title: textStrings["Copy"], action: function(){executeCommand(editorID,"copy","");} } );
            menu.push( { title: textStrings["Paste"], action: function(){executeCommand(editorID,"paste","");} } );
    //        menu.push( { title: textStrings["Delete"], action: function(){executeCommand(editorID,"delete","");} } );
            menu.push( { title: textStrings["Separator"], action: "" } );
            menu.push( { title: textStrings["SelectAll"], action: function(){executeCommand(editorID,"selectall","");} } );
            menu.push( { title: textStrings["InsertAnchor"], action: function(){insertAnchor(editorID,indexDir);} } );
            menu.push( { title: textStrings["Properties"], action: function(){showClassDialog(editorID,indexDir);} } );
    }
    else if ( currentNode.tagName == "P" )
    {
            menu.push( { title: textStrings["Undo"], action: function(){executeCommand(editorID,"undo","");} } );
            menu.push( { title: textStrings["Separator"], action: "" } );
            menu.push( { title: textStrings["Cut"], action: function(){executeCommand(editorID,"cut","");} } );
            menu.push( { title: textStrings["Copy"], action: function(){executeCommand(editorID,"copy","");} } );
            menu.push( { title: textStrings["Paste"], action: function(){executeCommand(editorID,"paste","");} } );
    //        menu.push( { title: textStrings["Delete"], action: function(){executeCommand(editorID,"delete","");} } );
            menu.push( { title: textStrings["Separator"], action: "" } );
            menu.push( { title: textStrings["SelectAll"], action: function(){executeCommand(editorID,"selectall","");} } );
            menu.push( { title: textStrings["Separator"], action: "" } );
            menu.push( { title: textStrings["InsertObject"], action: function(){insertObject(editorID,indexDir,objectID,objectVersion);} } );
            menu.push( { title: textStrings["InsertTable"], action: function(){newTable(editorID,indexDir);} } );
            menu.push( { title: textStrings["InsertLink"], action: function(){linkDialog(editorID,indexDir);} } );
            menu.push( { title: textStrings["InsertAnchor"], action: function(){insertAnchor(editorID,indexDir);} } );
            menu.push( { title: textStrings["InsertCustomTag"], action: function(){newCustomTag(editorID,indexDir);} } );
            menu.push( { title: textStrings["InsertLiteral"], action: function(){insertLiteralText(editorID,indexDir);} } );
            menu.push( { title: textStrings["Properties"], action: function(){showClassDialog(editorID,indexDir);} } );
    }
    else if ( currentNode.tagName.toLowerCase() == "a" )
    {
            menu.push( { title: textStrings["Undo"], action: function(){executeCommand(editorID,"undo","");} } );
            menu.push( { title: textStrings["Separator"], action: "" } );
            menu.push( { title: textStrings["Cut"], action: function(){executeCommand(editorID,"cut","");} } );
            menu.push( { title: textStrings["Copy"], action: function(){executeCommand(editorID,"copy","");} } );
            menu.push( { title: textStrings["Paste"], action: function(){executeCommand(editorID,"paste","");} } );
    //        menu.push( { title: textStrings["Delete"], action: function(){executeCommand(editorID,"delete","");} } );
            menu.push( { title: textStrings["Separator"], action: "" } );
            menu.push( { title: textStrings["SelectAll"], action: function(){executeCommand(editorID,"selectall","");} } );
            menu.push( { title: textStrings["Separator"], action: "" } );
            if ( tableID != -1 )
            {
                menu.push( { title: textStrings["InsertRow"], action: function(){insertRow(editorID);} } );
                menu.push( { title: textStrings["DeleteRow"], action: function(){deleteRow(editorID);} } );
                menu.push( { title: textStrings["Separator"], action: "" } );
                menu.push( { title: textStrings["InsertColumn"], action: function(){insertCol(editorID);} } );
                menu.push( { title: textStrings["DeleteColumn"], action: function(){deleteCol(editorID);} } );
                menu.push( { title: textStrings["Separator"], action: "" } );
                menu.push( { title: textStrings["MergeCells"], action: function(){mergeCell(editorID);} } );
                menu.push( { title: textStrings["SplitCell"], action: function(){splitCell(editorID);} } );
                menu.push( { title: textStrings["Separator"], action: "" } );
                if ( isInsideTH )
                {
                    menu.push( { title: textStrings["ChangeToTD"], action: function(){changeCellFormat(editorID);} } );
                }
                else
                {
                    menu.push( { title: textStrings["ChangeToTH"], action: function(){changeCellFormat(editorID);} } );
                }
                menu.push( { title: textStrings["CellProperties"], action: function(){showTableCellProperty(editorID,indexDir);} } );
                menu.push( { title: textStrings["TableProperties"], action: function(){tableProperties(editorID,indexDir);} } );
                menu.push( { title: textStrings["Separator"], action: "" } );
            }
            menu.push( { title: textStrings["RemoveLink"], action: function(){removeLink(editorID);} } );
            menu.push( { title: textStrings["LinkProperties"], action: function(){linkDialog(editorID,indexDir);} } );
    }
    else
    {
            menu.push( { title: textStrings["Undo"], action: function(){executeCommand(editorID,"undo","");} } );
            menu.push( { title: textStrings["Separator"], action: "" } );
            menu.push( { title: textStrings["Cut"], action: function(){executeCommand(editorID,"cut","");} } );
            menu.push( { title: textStrings["Copy"], action: function(){executeCommand(editorID,"copy","");} } );
            menu.push( { title: textStrings["Paste"], action: function(){executeCommand(editorID,"paste","");} } );
    //        menu.push( { title: textStrings["Delete"], action: function(){executeCommand(editorID,"delete","");} } );
            menu.push( { title: textStrings["Separator"], action: "" } );
            menu.push( { title: textStrings["SelectAll"], action: function(){executeCommand(editorID,"selectall","");} } );
            menu.push( { title: textStrings["Separator"], action: "" } );
            menu.push( { title: textStrings["InsertObject"], action: function(){insertObject(editorID,indexDir,objectID,objectVersion);} } );
            menu.push( { title: textStrings["InsertTable"], action: function(){newTable(editorID,indexDir);} } );
            menu.push( { title: textStrings["InsertLink"], action: function(){linkDialog(editorID,indexDir);} } );
            menu.push( { title: textStrings["InsertAnchor"], action: function(){insertAnchor(editorID,indexDir);} } );
            menu.push( { title: textStrings["InsertCustomTag"], action: function(){newCustomTag(editorID,indexDir);} } );
            menu.push( { title: textStrings["Properties"], action: function(){showClassDialog(editorID,indexDir);} } );
    }
    return menu;
}

function getPosition( element )
{
    var position = { x: element.offsetLeft, y: element.offsetTop };
    if ( element.offsetParent)
    {
        var pPosition = getPosition( element.offsetParent );
        position.x += pPosition.x;
        position.y += pPosition.y;
    }
    return position;
};

function disableDefaultContextMenu ( evt )
{
    evt.preventDefault();
    evt.stopPropagation();
    var evtPosition = document.getElementById( "contextMenu_position" );
    evtPosition.value = evt.clientX + "_" + evt.clientY;
}

function removeContextMenu( evt )
{
    try
    {
        var cmenu = document.getElementById("contextMenu");
        if ( cmenu )
            cmenu.parentNode.removeChild(cmenu);
    }
    catch( errorObject )
    {
        //do nothing
    }
}

/*!
    Updates the buttons of the toolbar
*/
function updateToolbar( editorID )
{
    var editorControl = document.getElementById(editorID).contentWindow;
    var tableID = getTableID ( editorID );

    if ( tableID == null )
        return;

    var tableEditEnabled = false;
    var textSelected = false;
    textSelected = isTextSelected( editorID );

    var currentNode = this.findParentNode( editorID );

    if ( !currentNode )
        return;

    var currentNodeName = currentNode.tagName.toLowerCase();

    var isHeading = false;
    //var isList = false;
    var isList = this.findParentByName( editorID, 'LI' );
    var blockFormatNow = editorControl.document.queryCommandValue("formatblock");
    var selectorName = editorID + "_select_header";
    var button_obj = document.getElementById( selectorName );

    var insertRowBtn = document.getElementById(editorID + "insertrow" );
    var deleteRowBtn = document.getElementById(editorID + "deleterow" );
    var insertColBtn = document.getElementById(editorID + "insertcol" );
    var deleteColBtn = document.getElementById(editorID + "deletecol" );
    var splitBtn = document.getElementById(editorID + "splitcell" );
    var mergeBtn = document.getElementById(editorID + "mergecell" );
    var boldBtn = document.getElementById(editorID + "bold" );
    var italicBtn = document.getElementById(editorID + "italic" );
    var orderedlistBtn = document.getElementById(editorID + "insertorderedlist" );
    var unorderedlistBtn = document.getElementById(editorID + "insertunorderedlist" );
    var insertObjectBtn = document.getElementById(editorID + CUSTOM_INSERTOBJECT );
    var insertLinkBtn = document.getElementById(editorID + CUSTOM_INSERTLINK );
    var insertAnchorBtn = document.getElementById(editorID + CUSTOM_INSERTANCHOR );
    var insertCustomTagBtn = document.getElementById(editorID + CUSTOM_INSERTCUSTOMTAG );
    var insertLiteralBtn = document.getElementById(editorID + CUSTOM_INSERTLITERAL );
    var insertTableBtn = document.getElementById(editorID + DECMD_INSERTTABLE );
    var insertCharacterBtn = document.getElementById(editorID + CUSTOM_INSERTCHARACTER );

    var indentBtn = document.getElementById(editorID + "indent" );
    var outdentBtn = document.getElementById(editorID + "outdent" );

    if ( tableID == "table" )
        tableEditEnabled = true;

    if ( !tableEditEnabled || textSelected )
    {
        insertRowBtn.className = "toolbarButtonDisabled";
        insertRowBtn.disabled = true;
        deleteRowBtn.className = "toolbarButtonDisabled";
        deleteRowBtn.disabled = true;
        insertColBtn.className = "toolbarButtonDisabled";
        insertColBtn.disabled = true;
        deleteColBtn.className = "toolbarButtonDisabled";
        deleteColBtn.disabled = true;
        splitBtn.className = "toolbarButtonDisabled";
        splitBtn.disabled = true;
        mergeBtn.className = "toolbarButtonDisabled";
        mergeBtn.disabled = true;

        if ( tableID == "literal" || textSelected )
        {
            insertObjectBtn.className = "toolbarButtonDisabled";
            insertObjectBtn.disabled = true;
            if ( textSelected )
            {
                insertLinkBtn.className = "toolbarButton";
                insertLinkBtn.disabled = false;
                insertCharacterBtn.className = "toolbarButtonDisabled";
                insertCharacterBtn.disabled = true;
            }
            else
            {
                insertLinkBtn.className = "toolbarButtonDisabled";
                insertLinkBtn.disabled = true;
                insertCharacterBtn.className = "toolbarButton";
                insertCharacterBtn.disabled = false;
            }
            insertAnchorBtn.className = "toolbarButtonDisabled";
            insertAnchorBtn.disabled = true;
            insertCustomTagBtn.className = "toolbarButtonDisabled";
            insertCustomTagBtn.disabled = true;
            insertLiteralBtn.className = "toolbarButtonDisabled";
            insertLiteralBtn.disabled = true;
            insertTableBtn.className = "toolbarButtonDisabled";
            insertTableBtn.disabled = true;
        }
        else
        {
            insertObjectBtn.className = "toolbarButton";
            insertObjectBtn.disabled = false;
            insertLinkBtn.className = "toolbarButton";
            insertLinkBtn.disabled = false;
            insertAnchorBtn.className = "toolbarButton";
            insertAnchorBtn.disabled = false;
            insertCustomTagBtn.className = "toolbarButton";
            insertCustomTagBtn.disabled = false;
            insertLiteralBtn.className = "toolbarButton";
            insertLiteralBtn.disabled = false;
            insertTableBtn.className = "toolbarButton";
            insertTableBtn.disabled = false;
            insertCharacterBtn.className = "toolbarButton";
            insertCharacterBtn.disabled = false;
        }
    }
    else
    {
        insertObjectBtn.className = "toolbarButton";
        insertObjectBtn.disabled = false;
        insertLinkBtn.className = "toolbarButton";
        insertLinkBtn.disabled = false;
        insertAnchorBtn.className = "toolbarButton";
        insertAnchorBtn.disabled = false;
        insertCustomTagBtn.className = "toolbarButton";
        insertCustomTagBtn.disabled = false;
        insertLiteralBtn.className = "toolbarButton";
        insertLiteralBtn.disabled = false;
        insertTableBtn.className = "toolbarButton";
        insertTableBtn.disabled = false;
        insertCharacterBtn.className = "toolbarButton";
        insertCharacterBtn.disabled = false;
        insertRowBtn.className = "toolbarButton";
        insertRowBtn.disabled = false;
        deleteRowBtn.className = "toolbarButton";
        deleteRowBtn.disabled = false;
        insertColBtn.className = "toolbarButton";
        insertColBtn.disabled = false;
        deleteColBtn.className = "toolbarButton";
        deleteColBtn.disabled = false;
        splitBtn.className = "toolbarButton";
        splitBtn.disabled = false;
        mergeBtn.className = "toolbarButton";
        mergeBtn.disabled = false;
    }
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
        button_obj.selectedIndex = 0;

    if ( button_obj.selectedIndex != 0 )
    {
        isHeading = true;
    }

    var boldValue = editorControl.document.queryCommandState("bold");
    if ( tableID == "literal" || currentNodeName == "img" )
    {
            boldBtn.className = "toolbarButtonDisabled";
            boldBtn.disabled = true;
    }
    else if( boldValue )
    {
            boldBtn.className = "toolbarButtonSelected";
            boldBtn.disabled = false;
    }
    else
    {
            boldBtn.className = "toolbarButton";
            boldBtn.disabled = false;
    }

    var italicValue = editorControl.document.queryCommandState("italic");
    if ( tableID == "literal" || currentNodeName == "img" )
    {
            italicBtn.className = "toolbarButtonDisabled";
            italicBtn.disabled = true;
    }
    else if( italicValue )
    {
            italicBtn.className = "toolbarButtonSelected";
            italicBtn.disabled = false;
    }
    else
    {
            italicBtn.className = "toolbarButton";
            italicBtn.disabled = false;
    }

    var orderedlistValue = editorControl.document.queryCommandState("insertorderedlist");
    if ( tableID == "literal" || currentNodeName == "img" || isHeading )
    {
            orderedlistBtn.className = "toolbarButtonDisabled";
            orderedlistBtn.disabled = true;
    }
    else if( orderedlistValue )
    {
        //isList = true;
            orderedlistBtn.className = "toolbarButtonSelected";
            orderedlistBtn.disabled = false;
    }
    else
    {
            orderedlistBtn.className = "toolbarButton";
            orderedlistBtn.disabled = false;
    }

    var unorderedlistValue = editorControl.document.queryCommandState("insertunorderedlist");
    if ( tableID == "literal" || currentNodeName == "img" || isHeading )
    {
        unorderedlistBtn.className = "toolbarButtonDisabled";
        unorderedlistBtn.disabled = true;
    }
    else if( unorderedlistValue )
    {
        //isList = true;
            unorderedlistBtn.className = "toolbarButtonSelected";
            unorderedlistBtn.disabled = false;
    }
    else
    {
            unorderedlistBtn.className = "toolbarButton";
            unorderedlistBtn.disabled = false;
    }

    if ( !isList )
    {
        indentBtn.disabled = true;
            indentBtn.className = "toolbarButtonDisabled";
            outdentBtn.disabled = true;
            outdentBtn.className = "toolbarButtonDisabled";
    }
    else
    {
            indentBtn.disabled = false;
            indentBtn.className = "toolbarButton";
            outdentBtn.disabled = false;
            outdentBtn.className = "toolbarButton";
    }
}

/*!
    Updates the statusbar
*/
function updateStatusbar( editorID )
{
    var editorControl = document.getElementById(editorID).contentWindow;
    var statusbar = document.getElementById('statusbar_' + editorID);
    var classInfo = document.getElementById('statusbar_class_' + editorID);
    var additionalInfo = document.getElementById('statusbar_info_' + editorID);
    var status = "&nbsp;";
    var parentTag = "";
    var tagClass = "";
    var contentInfo = "";

    var currentNode = this.findParentNode( editorID );

    // probably focus is not set to the window, then we don't need to update.
    if ( !currentNode )
        return;

    tagClass = currentNode.getAttribute( 'class' );

    if ( currentNode.tagName == "LI" )
        tagClass = currentNode.parentNode.getAttribute( 'class' );
    else
    {
        if ( currentNode.tagName == "TD" && currentNode.parentNode.parentNode.parentNode.id == "literal" )
            tagClass = currentNode.parentNode.parentNode.parentNode.getAttribute( 'title' );
        else
            tagClass = currentNode.getAttribute( 'class' );
    }

    parentTagList = getParentNodeList( currentNode );

    for ( var i=(parentTagList.length-1);i>=0;i-- )
    {
        var tagName = parentTagList[i].tagName.toLowerCase();

        switch ( tagName )
        {
            case 'span':
            {
                if ( parentTagList[i].getAttribute( "type" ) == 'custom' )
                {
                    status += " &lt;" + "custom" + "&gt;";
                    break;
                }

                var style = parentTagList[i].getAttribute( "style" );
                    status += " ";
                if ( style.match(/italic/g) && style.match(/bold/g) )
                    status += "&lt;b&gt; >> &lt;i&gt;";
                else if ( style.match(/italic/g) )
                    status += "&lt;i&gt;";
                else if ( style.match(/bold/g) )
                    status += "&lt;b&gt;";
                else
                    status += "&lt;" + tagName + "&gt;";
                break;
            }
            case 'table':
            {
                var tableNode = parentTagList[i];
                var tableID =  tableNode.id;
                if( tableID == "custom" )
                {
                    status += " &lt;" + "custom" + "&gt;";
                }
                else if( tableID == "literal" )
                {
                    status += " &lt;" + "literal" + "&gt;";
                }
                else
                {
                    status += " ";
                    status += "&lt;" + "table" + "&gt;";
                }
                break;
            }
            case 'img':
            {
                var imageNode = parentTagList[i];
                var imageType = imageNode.getAttribute( 'type' );
                if ( imageType == "anchor" )
                {
                    status += " ";
                    status += "&lt;" + "anchor" + "&gt;";
                }
                else if ( imageType == "custom" )
                {
                    status += " ";
                    status += "&lt;" + "custom" + "&gt;";

                    value = imageNode.getAttribute( 'value' );
                    if ( value.length > 40 )
                    value = value.substr( 0, 40 ) + '...';
                    contentInfo = imageNode.getAttribute( 'name' ) + ' : "' + value + '"';
                }
                else
                {
                    status += " ";
                    contentInfo = imageNode.getAttribute( 'id' );

                    if ( imageNode.getAttribute( 'inline' ) == 'true' )
                        status += "&lt;embed-inline&gt;";
                    else
                        status += "&lt;embed&gt;";
                    contentInfo = contentInfo.replace( "eZObject_", "ezobject://" );
                    contentInfo = contentInfo.replace( "eZNode_", "eznode://" );

                }
                break;
            }
            case 'ul':
            case 'ol':
            {
                if ( i != parentTagList.length-1 )
                {
                    if ( parentTagList[i+1].tagName.toLowerCase() == "ul" || parentTagList[i+1].tagName.toLowerCase() == "ol" )
                    {
                        status += " &lt;";
                        status += "li";
                        status += "&gt;";
                    }
                }
                status += " ";
                status += "&lt;" + tagName + "&gt;";
                break;
            }
            case 'tbody':
            break;
            case 'a':
            {
                contentInfo = parentTagList[i].getAttribute( 'href' );
                status += " ";
                status += "&lt;" + tagName + "&gt;";
                break;
            }
            default:
            {
                status += " ";
                status += "&lt;" + tagName + "&gt;";
            }
        }
        if ( i != 0  && tagName != "tbody" )
            status += " ";
    }

    additionalInfo.innerHTML = contentInfo;
    statusbar.innerHTML = status;

    /*/  Debug mode: full html snapshot in the status bar
    var editorHtml = editorControl.document.body.innerHTML;
    var statusbar = document.getElementById('statusbar_' + editorID);
    var re = /</g;
    statusbar.innerHTML = editorHtml.replace( re, '&lt;' );
    */

    if ( tagClass != "-1" && tagClass != null && tagClass != "")
        classInfo.innerHTML = textStrings["Class"] + tagClass;
    else
        classInfo.innerHTML =  textStrings["ClassNone"];

}

function updateContent( editorID )
{
    var textareaID = editorID.replace( "eZEditor_", "" );
    var editorControl = document.getElementById(editorID).contentWindow;
    document.getElementById(textareaID).value = editorControl.document.body.innerHTML;
}

/*
  Utility function; Returns all parent tags
*/
function getParentNodeList( oElement )
{
    var parentTagList = new Array();
    var index = 0;
    while ( oElement.tagName != "BODY" && oElement != null )
    {
        var currentTagName = oElement.tagName;
        var isTable = true;
        if ( currentTagName == "TABLE" )
        {
            tableID = oElement.getAttribute( 'id' );
            if ( tableID == "" || tableID == null || tableID == "table" )
            {
                tableID = "table";
            }
            else
            {
                isTable = false;
            }
        }

        // Remove td and tr tag from list for literal tag or custom tag.
        if ( !isTable && parentTagList.length>=3 && parentTagList[index-3].tagName == "TD" )
        {
            parentTagList[index-1] = "";
            parentTagList[index-2] = "";
            parentTagList[index-3] = "";
            parentTagList.length = parentTagList.length - 3;
            index = index - 3;
        }
        parentTagList[index] = oElement;
        oElement = oElement.parentNode;
        index++;
    }
    return parentTagList;
}

/*!
    Disable table editing if inside block custom tag or literal tag.
*/
function checkTableEditStatus( editorID )
{
    var tableEditEnabled = false;
    var tableID = "table";
    var currentTable = this.findParentNode( editorID );
    if ( currentTable.tagName == "TD" )
    {
        tableEditEnabled = true;
        currentTable = currentTable.parentNode;
        currentTable = currentTable.parentNode;
        currentTable = currentTable.parentNode;
        if ( /^table$/i.test(currentTable.tagName))
        {
           tableID = currentTable.id;
           if ( tableID == "literal" || tableID == "custom" )
           {
               var tableEditEnabled = false;
           }
        }
    }
    return tableEditEnabled;
}

function isTextSelected( editorID )
{
    var textSelected = false;
    var editorControl = document.getElementById(editorID).contentWindow;
    var selection = editorControl.getSelection();
    var selectedRange = selection.getRangeAt(0);
    if ( selectedRange.toString() != "" )
        textSelected = true;
    return textSelected;
}

/*
  Utility function; Goes up the DOM from the element oElement, till a parent element with the tag
  that matches sTag is found. Returns that parent element.
*/
function getElement( oElement, sTag )
{
  while ( oElement!=null && oElement.tagName!=sTag )
  {
    oElement = oElement.parentNode;
  }
  return oElement;
}

function getCurrentNode( editorID )
{
    var editorControl = document.getElementById(editorID).contentWindow;
    var selection = editorControl.getSelection();

    return selection.focusNode;
}

function findParentNode( editorID )
{
    var editorControl = document.getElementById(editorID).contentWindow;
    var selection = editorControl.getSelection();

/*    var pNode = selection.focusNode;
    if ( !pNode )
        return null;*/

    try
    {
        var selectedRange = selection.getRangeAt(0);
        var pNode = selectedRange.commonAncestorContainer;

        if ( !selectedRange.collapsed && selectedRange.startContainer == selectedRange.endContainer &&
             selectedRange.startOffset - selectedRange.endOffset <= 1 && selectedRange.startContainer.hasChildNodes() )
            pNode = selectedRange.startContainer.childNodes[selectedRange.startOffset];

        while (pNode.nodeType == 3)
        {
            pNode = pNode.parentNode;
        }
        return pNode;
    }
    catch (e)
    {
        //var pNode = selection.focusNode;
        return null;
    }
}

function insertNode( editorID, node )
{
    var editorControl = document.getElementById(editorID).contentWindow;
    var selection = editorControl.getSelection();
    var selectedRange = selection.getRangeAt(0);
    selection.removeAllRanges();
    selectedRange.deleteContents();
    var containerNode = selectedRange.startContainer;
    var pos = selectedRange.startOffset;
    switch ( containerNode.nodeType )
    {
        case 3:
        /*if ( node.nodeType == 3 )
        {
                containerNode.insertData( pos, node.data );
                range = document.createRange();
                range.setEnd( containerNode, pos + node.length);
                range.setStart( containerNode, pos + node.length);
                selection.addRange(range);
        }
        else
        {*/
                containerNode = containerNode.splitText(pos);
                var selnode = containerNode;

                containerNode.parentNode.insertBefore( node, containerNode );
                range = document.createRange();
                range.setEnd( selnode, 0 );
                range.setStart( selnode, 0 );
                selection.addRange( range );
        //}
        break;
        case 1:
        if ( containerNode.tagName == "TD" || containerNode.tagName == "LI" || containerNode.tagName == "P" )
        {
            if ( containerNode.lastChild.nodeName == 'BR' )
                containerNode.removeChild( containerNode.lastChild );

            containerNode.appendChild( node );
        }
        else if ( containerNode.tagName == "BODY" )
        {
            // TODO: Don't insert tables inside <p> ?

            var range = document.createRange();
            pNode = document.createElement("p");
            range.setEnd( containerNode, pos );
            range.setStart( containerNode, pos );
            range.insertNode( pNode );
            pNode.appendChild( node );
        }
        else
        {
            containerNode.parentNode.insertBefore( node, containerNode );
        }
        break;
    }
}

function appendNewParagraph( editorID, node )
{
    var appendPoint = this.getElement( node, 'P' );
    if ( !appendPoint )
    {
        appendPoint = node;
    }
    else
    {
        var next = node.nextSibling;
        if ( next && next.nodeName != 'BR' && !( next.nodeName == '#text' && next.textContent == '' ) )
            return;
    }

    var pNode = document.createElement("p");
    pNode.innerHTML = "<br class='ignore'/>";

    var next = appendPoint.nextSibling;
    if ( !next )
    {
        appendPoint.parentNode.appendChild( pNode );
    }
    else
    {
        var appendFlag = true;
        do
        {
            if ( next.nodeName != 'BR' && !( next.nodeName == '#text' && /\n/i.test( next.textContent ) ) )
                appendFlag = false;
            next = next.nextSibling;
        }
        while( next && appendFlag );

        if ( appendFlag )
        {
            next = appendPoint.nextSibling;
            while( next )
            {
                next.parentNode.removeChild( next );
                next = appendPoint.nextSibling;
            }
            appendPoint.parentNode.appendChild( pNode );
        }
    }

}

function createCustomAttrString( customAttributes )
{
    var customAttributeString = "";
    if ( customAttributes != -1 && customAttributes.length != 0 )
    {
        customAttributeString += customAttributes[0];
        for( var j=1;j<customAttributes.length;j++ )
        {
            customAttributeString += 'attribute_separation' + customAttributes[j];
        }
    }
    return customAttributeString;
}

function linkDialog( editorID, indexDir )
{
    var isNew = 0;
    var link = this.findParentByName( editorID, 'A' );
    if ( link == null )
        isNew = 1;

    var url = indexDir + "/layout/set/dialog/ezdhtml/insertlink/" + isNew;
    var windowParameters = "toolbar=no,menubar=no,personalbar=no,top=160,left=200,width=600,height=560,scrollbars=yes,resizable=yes";
    document.getElementById('iframeID').value = editorID;
    var linkWindow = window.open(url, "linkdialog", windowParameters );
    linkWindow.focus();
}

function linkParameters( editorID )
{
    var linkText = "";
    var argArray = new Array();
    var isImageLink = false;
    argArray["linkUrl"] = "";
    argArray["linkType"] = "";
    argArray["linkWindow"] = "_self";
    argArray["linkText"] = "";
    argArray["linkClass"] = -1;
    argArray["linkTitle"] = "";
    argArray["linkID"] = "";
    argArray["linkView"] = -1;

    var editorControl = document.getElementById(editorID).contentWindow;

    var link = this.findParentNode( editorID );

    if ( link.tagName.toLowerCase() == "img" )
    {
        isImageLink = true;
        link = link.parentNode;
        if ( link.tagName.toLowerCase() != "a" )
        {
            link = null;
        }
    }
    else
    {
        if ( link && !/^a$/i.test(link.tagName))
           link = link.nextSibling;

        if ( link && !/^a$/i.test(link.tagName))
            link = null;
    }

    if ( link != null )
    {
        argArray["linkUrl"] = link.getAttribute( 'href' );
        var urlString = link.href.toString();
        var linkType ="";
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
        else if ( urlString.match(/ezobject/g) )
        {
            linkType = "ezobject:\/\/";
        }
        else if ( urlString.match(/eznode/g) )
        {
            linkType = "eznode:\/\/";
        }
        else
        {
            linkType = "";
        }

        argArray["linkType"] = linkType;
        if ( isImageLink )
        {
            linkText =  "ez_image";
        }
        else
        {
            linkText = link.innerHTML;
        }

        argArray["customAttributes"] = link.getAttribute( "customattributes" );
        if ( argArray["customAttributes"] == null )
            argArray["customAttributes"] = -1;

        argArray["linkText"] = linkText;
        argArray["linkClass"] = link.getAttribute( "class" );
        argArray["linkWindow"] = link.target;
        argArray["linkTitle"] = link.getAttribute( "title" );
        argArray["linkID"] = link.getAttribute( "id" );
        argArray["linkView"] = link.getAttribute( "view" );
    }
    else
    {
        argArray["linkUrl"] = "";
        argArray["linkType"] = "";
        argArray["linkClass"] = -1;
        argArray["linkView"] = -1;
        argArray["customAttributes"] = -1;
        argArray["linkWindow"] = "_self";
        if ( isImageLink )
        {
            linkText =  "ez_image";
        }
        else
        {
            var selection = editorControl.getSelection();
            var selectedRange = selection.getRangeAt(0);
            linkText = selectedRange.toString();
        }
        argArray["linkText"] = linkText;
    }
    return argArray;
}

function addLink( editorID, parameters )
{
    var editorControl = document.getElementById(editorID).contentWindow;
    var url =  parameters.linkUrl;
    var target =  parameters.linkWindow;
    var className =  parameters.linkClass;
    var viewName =  parameters.linkView;
    var linkText =  parameters.linkText;
    var title =  parameters.linkTitle;
    var id =  parameters.linkID;

    var customAttributeString = createCustomAttrString( parameters.customAttributes );

    //try
    // {
    link = this.findParentNode( editorID );
    if ( link && !/^a$/i.test(link.tagName))
        link = link.nextSibling;

    if ( link && !/^a$/i.test(link.tagName))
        link = null;
    if ( link != null )
    {
        link.innerHTML = linkText;
        link.target = target;
        link.href = url;
        if ( className != -1 )
            link.setAttribute( "class", className );
        else
            link.removeAttribute( "class" );

        if ( viewName != -1 )
            link.setAttribute( "view", viewName );
        else
            link.removeAttribute( "view" );

        if ( customAttributeString != "" )
            link.setAttribute( "customattributes", customAttributeString );
        else
            link.removeAttribute( "customattributes" );

        if ( title != "" )
        {
            link.setAttribute( "title", title );
        }
        else
        {
            link.removeAttribute( "title" );
        }
        if ( id != "" )
        {
            link.setAttribute( "id", id );
        }
        else
        {
            link.removeAttribute( "id" );
        }
    }
    else
    {
        var currentNode = this.findParentNode( editorID );
        if ( currentNode.tagName.toLowerCase() == "img" )
        {
            var imageType = currentNode.getAttribute( 'type' );
            if ( imageType == null )
            {
                var imgParentNode = currentNode.parentNode;
                var newNode = editorControl.document.createElement( "a" );
                imageSource = currentNode.src;
                imageAlignment = currentNode.align;
                imageSize = currentNode.alt;
                imageID = currentNode.id;
                imageClass = currentNode.getAttribute( 'class' );

                imageHtmlID = currentNode.getAttribute( 'html_id' );

                imageViewMode = currentNode.getAttribute( 'view' );
                imageCustomAttributes = currentNode.customAttributes;
                var imageAttributes = "";
                if ( imageCustomAttributes != null )
                    imageAttributes = "customAttributes='" + imageCustomAttributes + "'";
                var optionalAttributes = "";
                if ( imageClass != null )
                    optionalAttributes += " class='" + imageClass + "'";
                if ( imageHtmlID != null )
                    optionalAttributes += " html_id='" + imageHtmlID + "'";
                if ( imageViewMode != null )
                    optionalAttributes += " view='" + imageViewMode + "'";
                    newNode.innerHTML = '<img id="' + imageID + '" src="' + imageSource +
                    '" align="' + imageAlignment + '"' +  optionalAttributes + '"' +
                    ' alt="' + imageSize   + '" ' + imageAttributes + '>';
                newNode.target = target;
                newNode.href = url;

                if ( className != -1 )
                    newNode.setAttribute( "class", className );

                if ( customAttributeString != "" )
                    newNode.setAttribute( "customattributes", customAttributeString );


                if ( title != "" )
                {
                    newNode.setAttribute( "title", title );
                }
                if ( id != "" )
                {
                    newNode.setAttribute( "id", id );
                }

                if ( imgParentNode.tagName.toLowerCase() == "a" )
                {
                    var imgGrandParentNode = imgParentNode.parentNode;
                    imgGrandParentNode.replaceChild( newNode, imgParentNode );
                }
                else
                {
                    imgParentNode.replaceChild( newNode, currentNode );
                }
            }
        }
        else
        {
            var link = editorControl.document.createElement( "a" );
            link.innerHTML = linkText;
            link.target = target;
            link.href = url;
            if ( className != -1 )
                link.setAttribute( "class", className );
            else
                link.removeAttribute( "class" );

            if ( viewName != -1 )
                link.setAttribute( "view", viewName );
            else
                link.removeAttribute( "view" );

            if ( title != "" )
            {
                link.setAttribute( "title", title );
            }
            else
            {
                link.removeAttribute( "title" );
            }
            if ( id != "" )
            {
                link.setAttribute( "id", id );
            }
            else
            {
                link.removeAttribute( "id" );
            }

            if ( customAttributeString != "" )
                link.setAttribute( "customattributes", customAttributeString );

            /*var spaceNode = editorControl.document.createTextNode( " " );
            this.insertNode( editorID, spaceNode );
            var pNode = spaceNode.parentNode;
            pNode.insertBefore( link, spaceNode );
            */

            /*this.insertNode( editorID, customSpan );

            var sel = editorControl.getSelection();
            var newRange = document.createRange();
            newRange.collapse(true);
            newRange.setStartAfter( customSpan );
            sel.removeAllRanges();
            sel.addRange( newRange );*/

            this.insertNode( editorID, link );

            var sel = editorControl.getSelection();
            var newRange = document.createRange();
            newRange.collapse(true);
            newRange.setStartAfter( link );
            sel.removeAllRanges();
            sel.addRange( newRange );

            //correctCursorPos( editorID );
        }
    }
    /*} catch (e)
    {
        alert( textStrings["ProblemToAddLink"] );
    }*/

    displayChanged( editorID );
    editorControl.focus();
}

function removeLink( editorID )
{
    var editorControl = document.getElementById(editorID).contentWindow;
    var link = this.findParentNode( editorID );
    if ( link.tagName.toLowerCase() == "img" )
    {
        link = link.parentNode;
        if ( link.tagName.toLowerCase() == "a" )
        {
            while ( link.firstChild )
            {
                link.parentNode.insertBefore( link.firstChild, link);
            }
            link.parentNode.removeChild(link);
        }
    }
    else
    {
        while ( link.firstChild )
        {
            link.parentNode.insertBefore( link.firstChild, link);
        }
        link.parentNode.removeChild(link);
    }
    displayChanged( editorID );
}

function insertAnchor( editorID, indexDir )
{
    var url = indexDir +  "/layout/set/dialog/ezdhtml/insertanchor/";
    var windowParameters = "toolbar=no,menubar=no,personalbar=no,top=300,left=300,width=330,height=300,scrollbars=no,resizable=yes";
    document.getElementById('iframeID').value = editorID;
    var anchorWindow = window.open( url, "anchordialog", windowParameters );
    anchorWindow.focus();
}

function anchorParameters( editorID )
{
    var argArray = new Array();

    anchorImage = this.findParentNode( editorID );
    if ( anchorImage && !/^img$/i.test(anchorImage.tagName))
       anchorImage = null;

    if ( anchorImage != null )
    {
        if( anchorImage.getAttribute( 'type' ) != "anchor" )
        {
            alert( textStrings["SelectedImageTypeIsNotAnchor"] );
            return null;
        }
        argArray["imgName"] = anchorImage.name;
        argArray["customAttributes"] = anchorImage.getAttribute( "customattributes" );
        if ( argArray["customAttributes"] == null )
            argArray["customAttributes"] = -1;
    }
    else
    {
        argArray["imgName"] = "";
        argArray["customAttributes"] = -1;
    }
    return argArray;
}

function addAnchor( editorID, parameters )
{
    var editorControl = document.getElementById(editorID).contentWindow;
    var src =  parameters.imgSrc;
    var name =  parameters.imgName;
    var type =  parameters.imgType;
    var imgType = "";

    var customAttributeString = createCustomAttrString( parameters.customAttributes );

    try
    {
        anchorImage = this.findParentNode( editorID );
        if ( anchorImage && !/^img$/i.test(anchorImage.tagName))
            anchorImage = null;
        if ( anchorImage != null )
        {
            imgType = anchorImage.getAttribute( "type" );
        }
        if ( anchorImage != null && imgType == "anchor" )
        {
            anchorImage.name = name;
        }
        else
        {
            var anchorImage = editorControl.document.createElement("img");
            anchorImage.name = name;
            anchorImage.src = src;
            anchorImage.setAttribute("type", type);
            this.insertNode( editorID, anchorImage );
        }

        if ( customAttributeString != "" )
            anchorImage.setAttribute( "customattributes", customAttributeString );
        else
            anchorImage.removeAttribute( "customattributes" );

    }catch (e) {
        alert( textStrings["ProblemToInsertAnchor"] );

        displayChanged( editorID );
    }
    editorControl.focus();
}

function insertObject( editorID, indexDir, objectID, objectVersion )
{
    var url = indexDir + "/layout/set/dialog/ezdhtml/insertobject/" + objectID + "/" + objectVersion + "/";
    var windowParameters = "toolbar=no,menubar=no,personalbar=no,top=50,left=200,width=600,height=700,scrollbars=yes,resizable=yes";
    document.getElementById('iframeID').value = editorID;
    var objectWindow = window.open( url, "objectdialog", windowParameters );
    objectWindow.focus();
}

function objectParameters( editorID )
{
    var argArray = new Array();
    objectImage = this.findParentNode( editorID );
    if ( objectImage && !/^img$/i.test(objectImage.tagName))
       objectImage = null;

    if ( objectImage != null )
    {
        argArray["objectAlign"] = objectImage.align;
        argArray["objectID"] = objectImage.id;
        argArray["objectSrc"] = objectImage.src;
        argArray["objectClass"] = objectImage.getAttribute( "class" );
        argArray["objectView"] = objectImage.getAttribute( "view" );
        argArray["htmlID"] = objectImage.getAttribute( "html_id" );
        argArray["customAttributes"] = objectImage.getAttribute( "customattributes" );
        if ( argArray["customAttributes"] == null )
            argArray["customAttributes"] = -1;
        if ( argArray["objectClass"] == null )
            argArray["objectClass"] = -1;

        argArray["embedInline"] = objectImage.getAttribute( "inline" );
        if ( argArray["objectView"] == null )
        {
            if ( argArray["embedInline"] == 'true' )
                argArray["objectView"] = "embed-inline";
            else
                argArray["objectView"] = "embed";
        }
        if ( argArray["htmlID"] == null )
            argArray["htmlID"] = "";
        if ( argArray["objectAlign"] == null )
            argArray["objectAlign"] = "center";
        var size = objectImage.alt;
        if ( size == "" || size == null )
            size = "medium";
        argArray["objectSize"] = size;
        argArray["imageExist"] = true;
    }
    else
    {
        argArray["objectAlign"] = "center";
        argArray["objectID"] = "";
        argArray["objectClass"] = -1;
        argArray["objectView"] = "";
        argArray["htmlID"] = "";
        argArray["objectSize"] = "";
        argArray["imageExist"] = false;
        argArray["customAttributes"] = -1;
        argArray["objectSrc"] = "";
        //argArray["embedInline"] = "true";
    }
    return argArray;
}

function addObject( editorID, parameters )
{
    var editorControl = document.getElementById(editorID).contentWindow;
    var srcString = parameters.objectIDString;
    src = srcString.replace( /id=([^ ]+) src='([^ ]+)'/ , "$2" );
    var id = srcString.replace( /id='([^ ]+)' src='([^ ]+)'/ , "$1" );
    var align = parameters.objectAlign;
    var size = parameters.objectSize;

    var sizeSuffix;
    if ( size == 'original' )
    {
        sizeSuffix = '';
    }
    else
    {
        sizeSuffix = "_" + size;
    }

    src = src.replace( "_small", sizeSuffix );
    var customAttributes = parameters.customAttributes;
    var customAttributeString = "";
    var className = parameters.objectClass;
    var viewMode = parameters.objectView;
    var htmlID = parameters.htmlID;
    var embedInline = parameters.embedInline;

    if ( customAttributes.length != 0 )
    {
        customAttributeString += customAttributes[0];
        for( var j=1;j<customAttributes.length;j++ )
        {
            customAttributeString += 'attribute_separation' + customAttributes[j];
        }
    }
    try
    {
        objectImage = this.findParentNode( editorID );
        if ( objectImage && !/^img$/i.test(objectImage.tagName))
            objectImage = null;
        if ( objectImage != null )
        {
            objectImage.src = src;
            objectImage.align = align;
            if ( size != "" )
                objectImage.setAttribute( 'alt', size );
            if ( className != -1 )
                objectImage.setAttribute( 'class', className );
            else
                objectImage.removeAttribute( 'class' );
            if ( ( embedInline == true && viewMode != "embed-inline" ) ||
                 ( embedInline == false && viewMode != "embed" ) )
            {
                objectImage.setAttribute( 'view', viewMode );
            }
            else
            {
                objectImage.removeAttribute( 'view' );
            }
            if ( htmlID != "" )
            {
                objectImage.setAttribute( 'html_id', htmlID );
            }
            else
            {
                objectImage.removeAttribute( 'html_id' );
            }

            objectImage.setAttribute( 'inline', embedInline );

            objectImage.setAttribute( 'id', id );
            if ( customAttributeString != "" )
                objectImage.setAttribute( "customattributes", customAttributeString );
            else
                objectImage.removeAttribute( "customattributes" );

            var selection = editorControl.getSelection();
            selection.selectAllChildren(selection.focusNode);
            selection.collapseToStart();
        }
        else
        {
            var objectImage = editorControl.document.createElement("img");
                objectImage.src = src;
                objectImage.align = align;
                if ( size != "" )
                    objectImage.setAttribute( 'alt', size );
                if ( className != -1 )
                objectImage.setAttribute( 'class', className );

                if ( ( embedInline == true && viewMode != "embed-inline" ) ||
                     ( embedInline == false && viewMode != "embed" ) )
                {
                    objectImage.setAttribute( 'view', viewMode );
                }
                if ( htmlID != "" )
                {
                    objectImage.setAttribute( 'html_id', htmlID );
                }

                objectImage.setAttribute( 'inline', embedInline );

            objectImage.setAttribute( 'id', id );
            if ( customAttributeString != "" )
                objectImage.setAttribute( "customattributes", customAttributeString );
            this.insertNode( editorID, objectImage );
        }
    }catch (e)
    {
        alert( textStrings["ProblemToInsertObject"] );
    }
    displayChanged( editorID );
    editorControl.focus();
}

//Called from menu and toolbar

function newCustomTag( editorID, indexDir )
{
    insertCustomTag( editorID, indexDir, 1 );
}

function customTagProperties( editorID, indexDir )
{
    insertCustomTag( editorID, indexDir, 0 );
}

function insertCustomTag( editorID, indexDir, isNew )
{
/*    var isNew = 1;
    var parent = this.findParentByName( editorID, 'IMG' );
    if ( parent != null && parent.id == 'custom' )
        isNew = 0;
    else
    {
        parent = this.findParentByName( editorID, 'SPAN' );
        if ( parent != null )
            isNew = 0;
        else
        {
            parent = this.findParentByName( editorID, 'TABLE' );
            if ( parent != null && parent.id == 'custom' )
                isNew = 0;
        }
    }
*/
    var url = indexDir + "/layout/set/dialog/ezdhtml/insertcustomtag/" + isNew;
    var windowParameters = "toolbar=no,menubar=no,personalbar=no,top=250,left=300,width=330,height=440,scrollbars=no,resizable=yes";
    document.getElementById('iframeID').value = editorID;
    var customTagWindow = window.open( url, "customtagdialog", windowParameters );
    customTagWindow.focus();
}

// Called from module

function customTagParameters( editorID, isNew )
{
    var argArray = new Array();
    argArray["customTagName"] = "";
    argArray["customTagType"] = "";
    argArray["customTagText"] = "";
    argArray["customAttributes"] = -1;

    if ( isNew )
        return argArray;

    var editorControl = document.getElementById(editorID).contentWindow;

    var customTable = this.findParentByName( editorID, 'TABLE' );
    var customImg = this.findParentByName( editorID, 'IMG' );
    var customSpan = this.findParentByName( editorID, 'SPAN' );

    var customNode = customImg ? customImg : ( customSpan ? customSpan : customTable );

    if ( customNode )
    {
        if ( customImg )
        {
            if ( customImg.getAttribute( 'type' ) != "custom" )
            {
                alert( textStrings["SelectedImageTypeIsNotCustomTag"] );
                return null;
            }
            argArray["customTagType"] = "inline";
            argArray["customTagText"] = customImg.getAttribute( 'value' );
            argArray["customTagName"] = customImg.getAttribute( 'name' );
        }
        else if ( customSpan )
        {
            if ( customSpan.getAttribute( 'type' ) != "custom" )
            {
                return null;
            }
            argArray["customTagType"] = "inline";
            argArray["customTagText"] = customSpan.innerHTML;
            argArray["customTagName"] = customSpan.getAttribute( 'name' );
        }
        else if ( customTable )
        {
            var tableID = customTable.id;
            if( tableID != "custom" )
            {
                //alert( textStrings["SelectedTableTypeIsNotCustomTag"] );
                return argArray;
            }
            argArray["customTagType"] = "block";
            argArray["customTagText"] = "";
            argArray["customTagName"] = customTable.getAttribute( 'title' );
        }
        argArray["customAttributes"] = customNode.getAttribute( 'customAttributes' );
        if ( argArray["customAttributes"] == null )
            argArray["customAttributes"] = -1;
    }
    return argArray;
}

// Called from module

function addCustomTag( editorID, parameters, isNew )
{
    var editorControl = document.getElementById(editorID).contentWindow;

    // Get the custom tag name
    var name = parameters.customTagName;
    name = name.replace( "inline_", "" );

    var type = parameters.customTagType;
    var src =  parameters.imgSrc;
    var tagText =  parameters.customTagText;

    var customAttributes = parameters.customAttributes;
    var customAttributeString = "";

    if ( customAttributes.length != 0 )
    {
        customAttributeString += customAttributes[0];
        for( var j=1;j<customAttributes.length;j++ )
        {
            customAttributeString += 'attribute_separation' + customAttributes[j];
        }
    }

    if ( type == "block" )
    {
        if ( !isNew )
        {
            var customTd = this.findParentByName( editorID, 'TD' );
            var customTable = this.findParentByName( editorID, 'TABLE' );

            if ( customTable != null && customTable.getAttribute( "id" ) == "custom" )
            {
                customTable.setAttribute( 'title', name );
                customTd.setAttribute( 'class', name );
                if ( customAttributeString != "" )
                    customTable.setAttribute( "customAttributes", customAttributeString );
                else
                    customTable.removeAttribute( "customAttributes" );
            }
        }
        else
        {
            var table = editorControl.document.createElement("table");
            table.border = 1;
            table.cellspacing = 2;
            table.cellpadding = 2;
            table.style.width = "100%";
            table.setAttribute( 'id', "custom" );
            table.setAttribute( 'class', "custom" );
            table.setAttribute( 'title', name );
            if ( customAttributeString != "" )
            {
                table.setAttribute( "customAttributes", customAttributeString );
            }
            var tbody = editorControl.document.createElement("tbody");
            table.appendChild(tbody);
            var tr = editorControl.document.createElement("tr");
            tbody.appendChild(tr);
            var td = editorControl.document.createElement("td");
            td.setAttribute( 'class', name );
                //td.style.backgroundColor = "#ccffff";
            td.appendChild( editorControl.document.createElement("br") );
            tr.appendChild(td);

            this.insertNode( editorID, table );
            this.appendNewParagraph( editorID, table );
        }
    }
    else
    {
        //try
        //{
        if ( !isNew )
        {
            customImage = this.findParentByName( editorID, 'IMG' );
            customSpan = this.findParentByName( editorID, 'SPAN' );

            if ( customImage != null && customImage.getAttribute( "type" ) == "custom" )
            {
                customImage.name = name;
                customImage.setAttribute( "value", tagText );
                if ( customAttributeString != "" )
                    customImage.setAttribute( "customAttributes", customAttributeString );
                else
                    customImage.removeAttribute( "customAttributes" );
            }
            else if ( customSpan != null && customSpan.getAttribute( "type" ) == "custom" )
            {
                customSpan.setAttribute( 'name', name );
                customSpan.setAttribute( 'class', name );
                customSpan.innerHTML = tagText;
                if ( customAttributeString != "" )
                    customSpan.setAttribute( "customAttributes", customAttributeString );
                else
                    customSpan.removeAttribute( "customAttributes" );
            }
        }
        else
        {
           if ( tagText == '' )
           {
                var customImage = editorControl.document.createElement("img");
                customImage.name = name;
                customImage.src = src;
                customImage.setAttribute( "type", "custom" );
                customImage.setAttribute( "value", tagText );
                if ( customAttributeString != "" )
                   customImage.setAttribute( "customAttributes", customAttributeString );

                this.insertNode( editorID, customImage );
           }
           else
           {
                var customSpan = editorControl.document.createElement("span");
                customSpan.setAttribute( 'type', 'custom' );
                customSpan.setAttribute( 'name', name );
                customSpan.setAttribute( 'class', name );
                if ( customAttributeString != "" )
                   customSpan.setAttribute( "customAttributes", customAttributeString );

                customSpan.innerHTML = tagText;

                var spaceNode = editorControl.document.createTextNode( ' ' );
                this.insertNode( editorID, spaceNode );
                spaceNode.parentNode.insertBefore( customSpan, spaceNode );

                var sel = editorControl.getSelection();
                var newRange = document.createRange();
                newRange.setStartAfter( spaceNode );
                newRange.collapse(true);
                sel.removeAllRanges();
                sel.addRange( newRange );
           }
        }
        //}catch (e)
        //{
        //    alert( textStrings["ProblemToInsertInlineCustomTag"] );
        //}
    }
    displayChanged( editorID );
    editorControl.focus();
}

function insertLiteralText( editorID, indexDir )
{
    var isNew = 1;
    var parent = this.findParentByName( editorID, 'TABLE' );
    if ( parent != null && parent.id == 'literal' )
        isNew = 0;

    var url = indexDir + "/layout/set/dialog/ezdhtml/insertliteral/" + isNew;
    var windowParameters = "toolbar=no,menubar=no,personalbar=no,top=300,left=300,width=330,height=330,scrollbars=no,resizable=no";
    document.getElementById('iframeID').value = editorID;
    var literalWindow = window.open( url, "literaldialog", windowParameters );
    literalWindow.focus();
}

function literalParameters( editorID )
{
    var argArray = new Array();

    parentTable = this.findParentByName( editorID, 'TABLE' );
    if ( parentTable != null && parentTable.id == 'literal' )
    {
        argArray["class"] = parentTable.getAttribute( "title" );

        argArray["customAttributes"] = parentTable.getAttribute( "customattributes" );
        if ( argArray["customAttributes"] == null )
            argArray["customAttributes"] = -1;
    }
    else
    {
        argArray["class"] = "";
        argArray["customAttributes"] = -1;
    }
    return argArray;
}

function addLiteral( editorID, parameters )
{
    var editorControl = document.getElementById(editorID).contentWindow;
    var className = parameters['class'];
    var customAttributeString = createCustomAttrString( parameters.customAttributes );

    var tableType = "";
    try
    {
    literalTd = findParentByName( editorID, 'TD' );
    literalTable = getElement( literalTd, 'TABLE' );

    if ( literalTable != null )
    {
        tableType = literalTable.getAttribute( "id" );
    }
    if ( literalTable != null && tableType == "literal" )
    {
        if ( className != '-1' )
        {
            literalTd.setAttribute("class", className );
            literalTable.setAttribute("title", className );
        }
        else
        {
            literalTd.removeAttribute("class");
            literalTable.removeAttribute("title", className );
        }
        if ( customAttributeString != "" )
            literalTable.setAttribute( "customattributes", customAttributeString );
        else
            literalTable.removeAttribute( "customattributes" );

    }
    else
    {
        var table = editorControl.document.createElement("table");
        table.border = 1;
        table.cellspacing = 2;
        table.cellpadding = 2;
        table.style.width = "100%";
        table.setAttribute( 'id', "literal" );
        table.setAttribute( 'class', "literal" );
        if ( className != '-1' )
            table.setAttribute( 'title', className );
        if ( customAttributeString != "" )
            table.setAttribute( "customattributes", customAttributeString );

        var tbody = editorControl.document.createElement("tbody");
        table.appendChild(tbody);
        var tr = editorControl.document.createElement("tr");
        tbody.appendChild(tr);
        var td = editorControl.document.createElement("td");
        if ( className != '-1' )
            td.setAttribute( 'class', className );
        //td.style.backgroundColor = "#ccccff";
        td.appendChild( editorControl.document.createElement("br") );
        tr.appendChild(td);
        this.insertNode( editorID, table );
        this.appendNewParagraph( editorID, table );
    }
    }catch (e)
    {
        alert( textStrings["ProblemToInsertLiteral"] );
    }
    displayChanged( editorID );
}

function newTable( editorID, indexDir )
{
    tableDialog( editorID, indexDir, 1 );
}

function tableProperties( editorID, indexDir )
{
    tableDialog( editorID, indexDir, 0 );
}

/*!
    Shows "tablePage" and uses the chosen values to insert a table into the table object
*/
function tableDialog( editorID, indexDir, isNew )
{
    var url = indexDir + "/layout/set/dialog/ezdhtml/inserttable/" + isNew;
    var windowParameters = "toolbar=no,menubar=no,personalbar=no,top=300,left=300,width=330,height=350,scrollbars=no,resizable=no";
    document.getElementById('iframeID').value = editorID;
    var tableWindow = window.open( url, "tabledialog", windowParameters );
    tableWindow.focus();
}

function tableParameters( editorID, isNew )
{
    var argArray = new Array();

    if ( isNew )
    {
        argArray["tableCols"] = 2;
        argArray["tableRows"] = 2;
        argArray["tableBorder"] = 1;
        argArray["tableClass"] = -1;
        argArray["tableWidth"] = "100%";
        argArray["enableRowEdit"] = true;
        argArray["customAttributes"] = -1;
        return argArray;
    }

    var editorControl = document.getElementById(editorID).contentWindow;
    var rows = 2;
    var cols = 2;

    var currentTable = this.findParentByName( editorID, "TD" );
    if ( !currentTable )
        currentTable = this.findParentByName( editorID, "TH" );

    if ( currentTable != null )
    {
        currentTable = currentTable.parentNode;

        if ( currentTable.tagName == "TR" )
        {
            cols = 0;
            for( var i = 0; i < currentTable.childNodes.length; i++ )
                if ( currentTable.childNodes[i].nodeType == 1 ) cols ++;

        }
        currentTable = currentTable.parentNode;

        if ( currentTable.tagName == "TBODY" )
        {
            rows = 0;
            for( var i = 0; i < currentTable.childNodes.length; i++ )
                if ( currentTable.childNodes[i].nodeType == 1 ) rows ++;
        }
        currentTable = currentTable.parentNode;

        if ( currentTable.tagName != 'TABLE' )
        {
           currentTable = null;
        }
    }
    else
    {
        currentTable = null;
    }

    if ( currentTable != null )
    {
        argArray["tableClass"] = currentTable.getAttribute( "class" );
        argArray["tableCols"] = cols;
        argArray["tableRows"] = rows;
        argArray["tableBorder"] = currentTable.border;
        if ( currentTable.getAttribute( "bordercolor" ) == "red" )
                argArray["tableBorder"] = 0;
            argArray["tableWidth"] = currentTable.style.width;
        argArray["enableRowEdit"] = false;

        argArray["customAttributes"] = currentTable.getAttribute( "customattributes" );

        if ( argArray["customAttributes"] == null )
            argArray["customAttributes"] = -1;
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
    }
    return argArray;
}

function addTable( editorID, parameters, isEmpty )
{
    var editorControl = document.getElementById(editorID).contentWindow;
    var tableClass = parameters.tableClass;
    var tableRows = parameters.tableRows;
    var tableCols = parameters.tableCols;
    var tableBorder = parameters.tableBorder;
    var tableWidth = parameters.tableWidth;
    var eZBorder = tableBorder;

    var customAttributeString = createCustomAttrString( parameters.customAttributes );

    if ( isEmpty == 1 )
    {
        var table = editorControl.document.createElement("table");
        table.setAttribute( 'ezborder', eZBorder );
        if ( tableBorder == 0 )
        {
           table.border = 1;
               table.setAttribute( 'bordercolor', 'red' );
        }
        else
            table.border = tableBorder;

        if ( customAttributeString != "" )
            table.setAttribute( "customattributes", customAttributeString );

        table.style.width = tableWidth;
        if ( tableClass != '-1' )
            table.setAttribute( 'class', tableClass );
        var tbody = editorControl.document.createElement("tbody");
        table.appendChild(tbody);

        for ( var i = 0; i < tableRows; i++ )
        {
            var tr = editorControl.document.createElement("tr");
            tbody.appendChild(tr);
            for ( var j = 0; j < tableCols; j++ )
            {
                var td = editorControl.document.createElement("td");
                td.appendChild( editorControl.document.createElement("br") );
                tr.appendChild(td);
            }
        }
        this.insertNode( editorID, table );
        this.appendNewParagraph( editorID, table );
    }
    else
    {
       // try
       // {
            currentTable = this.getCurrentNode( editorID );
            if ( !currentTable || currentTable.nodeName != 'TABLE' )
            {
                currentTable = this.findParentByName( editorID, 'TABLE' );
            }

            if (  currentTable != null )
            {
                if ( tableClass != '-1' )
                    currentTable.setAttribute( "class", tableClass );
                else
                    currentTable.removeAttribute("class");

                currentTable.setAttribute( 'ezborder', eZBorder );

                if ( eZBorder == 0 )
                    currentTable.setAttribute( "border", 1 );
                else
                    currentTable.setAttribute( "border", eZBorder );

                if ( eZBorder == 0 )
                    currentTable.setAttribute( 'bordercolor', 'red' );
                else
                    currentTable.removeAttribute( 'bordercolor' );

                currentTable.style.width = tableWidth;

                if ( customAttributeString != "" )
                    currentTable.setAttribute( "customattributes", customAttributeString );
                else
                    currentTable.removeAttribute( "customattributes" );

                var selection = editorControl.getSelection();
                selection.selectAllChildren(selection.focusNode);
                selection.collapseToStart();
            }
        //}catch (e)
        //{
        //    alert( textStrings["ProblemToInsertTable"] );
        //}
    }
    displayChanged( editorID );
}

function insertRow( editorID )
{
    var editorControl = document.getElementById(editorID).contentWindow;
    currentNode = this.findParentNode( editorID );
    if ( currentNode.tagName.toLowerCase() != "td" )
    {
        currentNode = currentNode.parentNode;
    }

    if ( currentNode.tagName.toLowerCase() == "td" )
    {
        var pNode = currentNode.parentNode;
        if (  pNode.tagName.toLowerCase() == "tr" )
        {
            var trNode = pNode.cloneNode(true);
            var tdNodes = trNode.getElementsByTagName("td");
            for ( var i = 0; i < tdNodes.length; i++ )
            {
                var tdNode = tdNodes[i];
                tdNode.rowSpan = 1;
                tdNode.innerHTML = "<br />";
            }
            pNode.parentNode.insertBefore( trNode, pNode );
        }
    }
    else
    {
        alert( textStrings["InsertRowIsNotPossible"] );
    }
}

function insertCol( editorID )
{
    var editorControl = document.getElementById(editorID).contentWindow;
    currentNode = this.findParentNode( editorID );
    if ( currentNode.tagName.toLowerCase() != "td" )
    {
        currentNode = currentNode.parentNode;
    }

    if ( currentNode.tagName.toLowerCase() == "td" )
    {
        var trNodes = currentNode.parentNode.parentNode.rows;
        var cellIndex = currentNode.cellIndex;
        for ( var i = 0; i < trNodes.length; i++ )
        {
            var trNode = trNodes[i];
            var tdNode = trNode.cells[cellIndex];
            var insertedTdNode = editorControl.document.createElement("td");
            insertedTdNode.innerHTML = "<br />";
            trNode.insertBefore( insertedTdNode, tdNode );
        }
    }
    else
    {
            alert( textStrings["InsertRowIsNotPossible"] );
    }

    var selection = editorControl.getSelection();
    selection.selectAllChildren(selection.focusNode);
    selection.collapseToStart();
}

function deleteRow( editorID )
{
    var editorControl = document.getElementById(editorID).contentWindow;
    currentNode = this.findParentNode( editorID );
    if ( currentNode.tagName.toLowerCase() != "td" )
    {
        currentNode = currentNode.parentNode;
    }

    if ( currentNode.tagName.toLowerCase() == "td" )
    {
        var trNode = currentNode.parentNode;
        if (  trNode.tagName.toLowerCase() == "tr" )
        {
            var tbodyNode = trNode.parentNode;
            tbodyNode.removeChild(trNode);
        }
    }
    else
    {
            alert( textStrings["DeleteRowIsNotPossible"] );
    }
}

function deleteCol( editorID )
{
    var editorControl = document.getElementById(editorID).contentWindow;
    currentNode = this.findParentNode( editorID );
    if ( currentNode.tagName.toLowerCase() != "td" )
    {
        currentNode = currentNode.parentNode;
    }

    if ( currentNode.tagName.toLowerCase() == "td" )
    {
        var trNodes = currentNode.parentNode.parentNode.rows;
        var cellIndex = currentNode.cellIndex;

        for ( var i = 0; i < trNodes.length; i++ )
        {
            var trNode = trNodes[i];
            var tdNode = trNode.cells[cellIndex];
            trNode.removeChild(trNode.cells[cellIndex]);
        }
    }
    else
    {
            alert( textStrings["DeleteColumnIsNotPossible"] );
    }
    var selection = editorControl.getSelection();
    selection.selectAllChildren(selection.focusNode.parentNode.parentNode);
}

function splitCell( editorID )
{
    var editorControl = document.getElementById(editorID).contentWindow;
    tdNode = this.findParentNode( editorID );
    if ( tdNode.tagName.toLowerCase() != "td" )
    {
        tdNode = tdNode.parentNode;
    }

    if ( tdNode.tagName.toLowerCase() == "td" )
    {
        var cSpan = tdNode.colSpan;
        var rSpan = tdNode.rowSpan;
        var tdParentNode = tdNode.parentNode;
        var trNodes = tdNode.parentNode.parentNode.rows;
        var cellIndex = tdNode.cellIndex;
        var realCellIndex = cellIndex;
        var cells = tdParentNode.cells;
        for ( var i = 0; i < cells.length; i++ )
        {
            var cellNode = cells[i];
            if ( cellNode.colSpan != 1 && i < cellIndex )
            {
                realCellIndex = realCellIndex + cellNode.colSpan - 1;
            }
        }
        var rowIndex = tdParentNode.rowIndex;
        var nextNode = tdNode.nextSibling;
        var insertedTdNode = editorControl.document.createElement("td");
        insertedTdNode.innerHTML = "<br />";
        if ( cSpan > 1 )
        {
           currentNode.colSpan = cSpan--;
        }
        insertedTdNode.rowSpan = rSpan;
        tdParentNode.insertBefore( insertedTdNode, nextNode );
        for ( var i = 0; i < trNodes.length; i++ )
        {
            var trNode = trNodes[i];
            if ( trNode.rowIndex != rowIndex )
            {
                var currentCells = trNode.cells;
                var realIndex = realCellIndex;
                for ( var j = 0; j < currentCells.length; j++ )
                {
                    var cellNode = currentCells[j];
                    if ( j == realIndex )
                    {
                        cellNode.colSpan = cellNode.colSpan + 1;
                    }
                    if ( cellNode.colSpan != 1 )
                    {
                        realIndex = realIndex - cellNode.colSpan + 1;
                    }
                }
            }
        }
    }
    else
    {
            alert( textStrings["SplitCellIsNotPossible"] );
    }
    var selection = editorControl.getSelection();
    selection.selectAllChildren(selection.focusNode);
    selection.collapseToStart();
}

function mergeCell( editorID )
{
    var editorControl = document.getElementById(editorID).contentWindow;
    var selection = editorControl.getSelection();
    var index = 0;
    var selectedRows = new Array();
    var currentRow = null;
    var selectedCells = null;
    var rangeCount = selection.rangeCount;
    var tdContent = "";
    var rowSpan = 0;
    var colSpan = 0;
    try {
        while ( index < rangeCount )
        {
            range = selection.getRangeAt( index );
            var currentTdNode = range.startContainer.childNodes[range.startOffset];
            if ( currentTdNode.parentNode != currentRow )
            {
                currentRow = currentTdNode.parentNode;
                if ( selectedCells != null )
                {
                   selectedRows.push( selectedCells );
                }
                selectedCells = new Array();
            }
            selectedCells.push(currentTdNode);
            index++;
        }
        selectedRows.push( selectedCells );
    }
    catch(e)
    {
        alert( textStrings["MergeCellsIsNotPossible"] );
    }

    for ( var i = 0; i < selectedRows.length; i++ )
    {
        var tdCells = selectedRows[i];
        for ( var j = 0; j < tdCells.length; j++ )
        {
            var tdCell = tdCells[j];
            tdContent += tdCell.innerHTML;
            if ( i != 0 || j != 0 )
            {
                 tdCell.parentNode.removeChild( tdCell );
            }
            if ( i == 0 )
            {
                colSpan += tdCell.colSpan;
            }
            if ( j == 0 )
            {
                rowSpan += tdCell.rowSpan;
            }
        }
    }
    var remainNode = selectedRows[0][0];
    remainNode.innerHTML = tdContent;
    remainNode.rowSpan = rowSpan;
    remainNode.colSpan = colSpan;

    var selection = editorControl.getSelection();
    selection.selectAllChildren(selection.focusNode);
    selection.collapseToEnd();
}


function showTableCellProperty ( editorID, indexDir )
{
    currentNode = this.findParentNode( editorID );
    while ( !/^td$/i.test(currentNode.tagName) && !/^th$/i.test(currentNode.tagName) )
    {
        currentNode = currentNode.parentNode;
    }

    var tagName = currentNode.nodeName.toLowerCase();

    var url = indexDir +  "/layout/set/dialog/ezdhtml/tablecelledit/" + tagName + "/";
    var windowParameters = "toolbar=no,menubar=no,personalbar=no,top=300,left=300,width=410,height=290,scrollbars=no,resizable=no";
    document.getElementById('iframeID').value = editorID;
    var tableCellWindow = window.open( url, "tablecelldialog", windowParameters );
    tableCellWindow.focus();
}

function tableCellPropertyParameters( editorID )
{
    var argArray = new Array();
    //var editorControl = document.getElementById(editorID).contentWindow;

    currentNode = this.findParentNode( editorID );
    while ( !/^td$/i.test(currentNode.tagName) && !/^th$/i.test(currentNode.tagName) )
    {
        currentNode = currentNode.parentNode;
    }

    argArray["cellClass"] = currentNode.getAttribute( "class" );
    if (  argArray["cellClass"] == null )
        argArray["cellClass"] = "";
    argArray["cellWidth"] = currentNode.getAttribute( "width" );
    return argArray;
}

function addTableCellProperty( editorID, parameters )
{
    var editorControl = document.getElementById(editorID).contentWindow;
    var className = parameters.cellClass;
    var cellWidth = parameters.cellWidth;
    var widthTarget = parameters.widthTarget;
    var classTarget = parameters.classTarget;

    var currentNode = this.findParentNode( editorID );
    while ( !/^td$/i.test(currentNode.tagName) && !/^th$/i.test(currentNode.tagName))
    {
        currentNode = currentNode.parentNode;
    }

    var trElement = currentNode.parentNode;

    var tableElement = trElement.parentNode;

    while ( !/^table$/i.test(tableElement.tagName))
    {
        tableElement = tableElement.parentNode;
    }
    var rowE = tableElement.rows;

    var cellIndex = currentNode.cellIndex;

    var rowIndex = trElement.rowIndex;

    if ( classTarget == "row" )
    {
        var cells = rowE[rowIndex].cells;
        for ( var j=0; j<cells.length; j++ )
            if ( className != -1 )
                cells[j].setAttribute( "class", className );
            else
                cells[j].removeAttribute( "class" );
    }
    else if ( classTarget == "column" )
    {
        for ( var i=0; i<rowE.length; i++ )
        {
            var cells = rowE[i].cells;
            for ( var j=0; j<cells.length; j++ )
            {
                if ( j == cellIndex )
                {
                    if ( className != -1 )
                        cells[j].setAttribute( "class", className );
                    else
                        cells[j].removeAttribute( "class" );
                }
            }
        }
    }
    else
    {
        if ( className != -1 )
            currentNode.setAttribute( "class", className );
        else
            currentNode.removeAttribute( "class" );
    }

    if ( cellWidth == null )
    {
        cellWidth = -1;
    }

    if ( cellWidth != -1 )
    {
        if ( widthTarget == "row" )
        {
            var cells = rowE[rowIndex].cells;
            for ( var j=0; j<cells.length; j++ )
            {
                cells[j].setAttribute( "width", cellWidth );
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
                    cells[j].setAttribute( "width", cellWidth );
                }
             }
        }
        else
        {
            currentNode.setAttribute( "width",  cellWidth );
        }
    }

    var selection = editorControl.getSelection();
    selection.selectAllChildren(selection.focusNode);
    selection.collapseToStart();
}

function changeCellFormat ( editorID )
{
    var isTableHead = isTH( editorID );
    if ( isTableHead )
        setAsTD( editorID );
    else
        setAsTH( editorID );
}

function setAsTH ( editorID )
{
    var editorControl = document.getElementById(editorID).contentWindow;
    var tdObject = this.findParentNode( editorID );

    while ( !/^td$/i.test(tdObject.tagName))
    {
        tdObject = tdObject.parentNode;
    }

    if ( tdObject != null )
    {
        var trNode = tdObject.parentNode;
        var tdNodes = trNode.cells;
        for ( var i=0; i<tdNodes.length; i++ )
        {
            var tdNode = tdNodes[i];
            var tdContent = tdNode.innerHTML;
            var width = tdNode.getAttribute( 'width' );
            var colSpan = tdNode.getAttribute( 'colSpan' );
            var rowSpan = tdNode.getAttribute( 'rowSpan' );
            var className = tdNode.getAttribute( 'class' );
            var thNode = editorControl.document.createElement("th");
            trNode.replaceChild( thNode, tdNode );
            thNode.innerHTML = tdContent;
            thNode.setAttribute( 'width', width );
            thNode.setAttribute( 'colSpan', colSpan );
            thNode.setAttribute( 'rowSpan', rowSpan );
        thNode.setAttribute( 'class', className );
        }
    }
}

function setAsTD ( editorID )
{
    var editorControl = document.getElementById(editorID).contentWindow;
    var thObject = this.findParentNode( editorID );

    while ( !/^th$/i.test(thObject.tagName))
    {
        thObject = thObject.parentNode;
    }

    if ( thObject != null )
    {
        var trNode = thObject.parentNode;
        var thNodes = trNode.cells;
        for ( var i=0; i<thNodes.length; i++ )
        {
            var thNode = thNodes[i];
            var thContent = thNode.innerHTML;
            var width = thNode.getAttribute( 'width' );
            var colSpan = thNode.getAttribute( 'colSpan' );
            var rowSpan = thNode.getAttribute( 'rowSpan' );
            var className = thNode.getAttribute( 'class' );
            var tdNode = editorControl.document.createElement("td");
            trNode.replaceChild( tdNode, thNode );
            tdNode.innerHTML = thContent;
            tdNode.setAttribute( 'width', width );
            tdNode.setAttribute( 'colSpan', colSpan );
            tdNode.setAttribute( 'rowSpan', rowSpan );
        tdNode.setAttribute( 'class', className );
        }
    }
}

function isTH ( editorID )
{
    var isTH = false;
    var editorControl = document.getElementById(editorID).contentWindow;
    var currentNode = this.findParentNode( editorID );
    while ( !/^th$/i.test(currentNode.tagName) && currentNode.tagName.toLowerCase() != "table" && currentNode.tagName.toLowerCase() != "body" )
    {
        currentNode = currentNode.parentNode;
    }
    if ( currentNode.tagName.toLowerCase() == "th" )
    {
        isTH = true;
    }
    return isTH;
}

function getTableID ( editorID )
{
    var tableID = -1;
    var currentNode = this.findParentNode( editorID );
    if ( !currentNode )
        return null;

    while ( currentNode.tagName != "BODY" && currentNode != null )
    {
        if ( currentNode.tagName == "TABLE" )
        {
            tableID = currentNode.getAttribute( "id" );
            if ( tableID == null || tableID == "" )
            {
                tableID = "table";
            }
            return tableID;
        }
        currentNode = currentNode.parentNode;
    }
    return tableID;
}

function findParentByName( editorID, parentName )
{
    var currentNode = this.findParentNode( editorID );
    if ( !currentNode )
        return null;

    while ( currentNode.tagName != "BODY" && currentNode != null )
    {
        if ( currentNode.tagName == parentName )
            return currentNode;
        currentNode = currentNode.parentNode;
    }
    return null;
}

function showClassDialog ( editorID, indexDir )
{
    var editorControl = document.getElementById(editorID).contentWindow;
    currentNode = this.findParentNode( editorID );
    var tagName = "";
    if ( currentNode.tagName.toLowerCase() == "li" )
    {
        currentNode = currentNode.parentNode;
    }
    tagName = currentNode.tagName.toLowerCase();

    if ( tagName == "span" )
    {
        var style = currentNode.getAttribute( "style" );
        if ( style.match(/italic/g) )
        {
            tagName = "em";
        }
        else if ( style.match(/bold/g) )
        {
            tagName = "bold";
        }
    }
    var url = indexDir +  "/layout/set/dialog/ezdhtml/insertclassattribute/" + tagName + "/";;
    var windowParameters = "toolbar=no,menubar=no,personalbar=no,top=300,left=300,width=330,height=330,scrollbars=no,resizable=no";
    document.getElementById('iframeID').value = editorID;
    var classWindow = window.open( url, "classdialog", windowParameters );
    classWindow.focus();
}

function customClassParameters( editorID )
{
    var argArray = new Array();
    var editorControl = document.getElementById(editorID).contentWindow;

    currentNode = this.findParentNode( editorID );
    if ( currentNode.tagName.toLowerCase() == "li" )
    {
        currentNode = currentNode.parentNode;
    }

    argArray["class"] = currentNode.getAttribute( "class" );

    if ( argArray["class"] == null )
        argArray["class"] = "";

    argArray["customAttributes"] = currentNode.getAttribute( "customattributes" );
    if ( argArray["customAttributes"] == null )
        argArray["customAttributes"] = -1;

    return argArray;
}

function addCustomClass( editorID, parameters )
{
    var editorControl = document.getElementById(editorID).contentWindow;
    var className = parameters['class'];

    var customAttributeString = createCustomAttrString( parameters.customAttributes );

    var tableType = "";
    try
    {
        currentNode = this.findParentNode( editorID );
        if ( currentNode.tagName.toLowerCase() == "li" )
        {
            currentNode = currentNode.parentNode;
        }
        if ( currentNode != null )
        {
            if ( className != '-1' )
            {
                currentNode.setAttribute( "class", className );
            }
            else
            {
                currentNode.removeAttribute( "class" );
            }

            if ( customAttributeString != "" )
                currentNode.setAttribute( "customattributes", customAttributeString );
            else
                currentNode.removeAttribute( "customattributes" );
        }
    }catch (e)
    {
        alert( textStrings["ProblemToInsertClassAttribute"] );
    }
    editorControl.focus();
}

function showHelpWindow( editorID, indexDir )
{
    var url = indexDir +  "/layout/set/dialog/ezdhtml/help/";
    var windowParameters = "toolbar=no,menubar=no,personalbar=no,top=100,left=300,width=580,height=700,scrollbars=yes,resizable=yes";
    document.getElementById('iframeID').value = editorID;
    var helpWindow = window.open( url, "helpdialog", windowParameters );
    helpWindow.focus();
}

function insertCharacter( editorID, indexDir )
{
    var url = indexDir +  "/layout/set/dialog/ezdhtml/insertcharacter/";
    var windowParameters = "toolbar=no,menubar=no,personalbar=no,top=100,left=300,width=410,height=340,scrollbars=no,resizable=no";
    document.getElementById('iframeID').value = editorID;
    var characterWindow = window.open( url, "insertcharacterdialog", windowParameters );
    characterWindow.focus();
}

function addCharacter( editorID, charValue )
{
    var editorControl = document.getElementById(editorID).contentWindow;
    try {
        var textNode = editorControl.document.createTextNode( charValue );
        this.insertNode( editorID, textNode );
        editorControl.focus();
    }catch (e) {
        alert( textStrings["ProblemToInsertSpecialCharacter"] );
    }
    displayChanged( editorID );
}
