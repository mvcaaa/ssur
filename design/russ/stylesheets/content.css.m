
/* override that in /base/classes.css */
div.object-center
{ 
/*    float: center;*/
    margin-left: 0em;
    margin-right: 0em;
    text-align: left;
}

div.content-view-embed 
{
margin: 0em;
width: auto;
border: none;
}


/* AUTHOR AND DATE FOR ALL FULL OBJECTS */

div.content-view-full div.attribute-byline p.author
{
/*
    margin-right: 0.2em;
    display: inline;
    font-size: 0.9em;
*/
}

div.content-view-full div.attribute-byline p.date
{
    margin: 0 0em 0 0em;
    display: inline;
/*    color: #CCCCCC; */
/*    font-size: 0.9em; */
}

/* AUTHOR AND DATE FOR ALL CHILD OBJECTS */

div.content-view-full div.content-view-line div.attribute-byline p
{
    display: inline;
}

/* FRONTPAGE */

div.content-view-full div.class-frontpage
{
/*    background-color: #FFFFFF; */
/*    padding: 0 0.5em 0 0.25em; */
}

/* 
div.content-view-full div.class-frontpage table {
	border: 1px solid red;
}

div.content-view-full div.class-frontpage table td {
	border: 1px solid green;
} 
*/

div.content-view-full div.class-frontpage div.attribute-billboard
{
}

div.content-view-full div.class-frontpage div.attribute-billboard img
{
}

div.content-view-full div.class-frontpage div.columns-frontpage
{
/*     padding: 0 246px 0 246px; */
	padding: 0 220px 0 315px; 

}

div.content-view-full div.noleftcolumn div.columns-frontpage
{
    padding-left: 0px;
}

div.content-view-full div.norightcolumn div.columns-frontpage
{
    padding-right: 0px;
}

div.content-view-full div.class-frontpage div.columns-frontpage div.left-column-position
{
    width: 315px;
    margin-left: -315px;
    float: left;
    display: inline; 
}



div.content-view-full div.noleftcolumn div.columns-frontpage div.left-column-position
{
    display: none;
}

div.content-view-full div.leftcolumn div.columns-frontpage div.left-column-position div.left-column
{
    margin-right: 0px;
}

div.content-view-full div.class-frontpage div.columns-frontpage div.right-column-position
{
    width: 220px;
    margin-right: -220px;
    float: left;
}

div.content-view-full div.norightcolumn div.columns-frontpage div.right-column-position
{
    display: none;
}

div.content-view-full div.rightcolumn div.columns-frontpage div.right-column-position div.right-column
{
    margin-left: 15px;
}


div.content-view-full div.class-frontpage div.columns-frontpage div.center-column-position
{
    width: 400px;
    min-width: 400px;
/* 	_width: 100%; */
     float: left;
     clear: right;
}


div.content-view-full div.noleftcolumn div.columns-frontpage div.center-column-position div.center-column
{
    margin-left: 0;
    padding-right: 0;
}


div.content-view-full div.norightcolumn div.columns-frontpage div.center-column-position div.center-column
{
    margin-right: 0;
    padding-left: 0px;
}

div.content-view-full div.class-frontpage div.columns-frontpage div.center-column-position div.center-column
{
    margin: 0; /* Space between main and other columns */
}

/*
*/

div.content-view-full div.class-frontpage div.attribute-top-column
{
    clear: both
}

div.content-view-full div.class-frontpage div.attribute-bottom-column
{
    clear: both
}

/* SEPARATOR */

div.separator
{
/*
    background-image: url(../images/separator.jpg);
    background-repeat: no-repeat;
    height: 20px;
*/
    clear: both;
}

/* IMAGE */

div.attribute-image
{
    margin: 0.25em 0 0.5em 0;
}

div.content-view-full div.attribute-image
{
/* 
    float: right;
    margin-left: 0.5em;
    margin-right: 0;
 */
}

div.content-view-full div.class-image div.attribute-image
{
    margin-left: 0;
    float: none;
}

div.content-view-full div.attribute-image div.caption
{
/*
    background-color: #EAE9E1;
    font-size: 0.8em;
    text-align: center;
    margin: 2px 0 0 0;
*/
}

div.content-view-full div.attribute-image div.caption p
{
    padding: 3px;
    margin: 0;
}

div.content-view-line div.attribute-image
{
    float: left;
    margin-right: 0.5em;
    margin-left: 0;
}

div.content-view-listitem div.attribute-image
{
    float: left;
    margin-right: 0.5em;
    margin-left: 0;
}

div.content-view-embed div.attribute-image
{
    float: left;
    margin-right: 0.5em;
    margin-left: 0;
}

div.object-left div.content-view-embed div.class-image div.attribute-image
{
    margin: 0;
    float: none;
}

div.object-right div.content-view-embed div.class-image div.attribute-image
{
    margin: 0;
    float: none;
}

div.object-center div.class-image
{
    margin-left: auto;
    margin-right: auto;
    text-align: center;
}

div.object-center div.content-view-embed div.class-image div.attribute-image
{
    margin: 0;
    float: none;
}

div.content-view-embed div.class-image div.attribute-caption
{
    background-color: #EAE9E1;
    font-size: 0.8em;
    text-align: center;
    margin: 2px 0 0 0;
}

div.object-center div.content-view-embed div.class-image div.attribute-caption
{
    margin: 2px auto 0 auto;
}

div.content-view-embed div.class-image div.attribute-caption p
{
    padding: 3px;
    margin: 0;
}

/* ARTICLE */

div.content-view-full div.class-article div.attribute-header h1
{
    background: none;
    padding-bottom: 0;
    margin-bottom: 0.25em;
}

div.content-view-full div.class-article h1
{
    font-size: 1.8em;
    font-weight: bold;
    margin-bottom: 0.25em;
}

div.content-view-full div.class-article div.attribute-byline
{
/*
    background-image: url(../images/attribute_header_bg_medium.png);
    background-position: bottom center;
    background-repeat: no-repeat;
    padding-bottom: 30px;
    margin-bottom: -0.25em;
*/
    display: block;
/*
    margin: 0em;
    padding: 0em;
*/
}

div.content-view-full div.class-article div.attribute-short
{
    font-weight: normal;
}

div.content-view-full div.class-article div.attribute-topic
{
    font-style: italic;
}

div.content-view-full div.class-article div.attribute-long
{
/*     background-image: url(../images/attribute_header_bg_medium.png);
    background-position: bottom center;
    background-repeat: no-repeat;
    padding-bottom: 56px;
 */
 font-size: 120%;
}

div.content-view-line div.class-article div.attribute-short
{
    font-weight: normal;
}


div.class-article div.attribute-short .linkmore, p.linkmore
{
    font-weight: normal;
    text-align: right;
    margin-top: 0.5em;
    margin-bottom: 0.5em;
}

div.class-article div.attribute-short p.comments
{
    margin-top: 1em;
    margin-bottom: 0em;
}

div.content-view-embed div.class-article div.attribute-short
{
    font-weight: normal;
}


div.content-view-full div.class-article div.attribute-short p
{ 
    font-weight: normal;
}


div.attribute-tipafriend
{
    background-image: url(../images/attribute_header_bg_medium.png);
    background-position: top center;
    background-repeat: no-repeat;
    margin-top: 2em;
}

div.attribute-tipafriend p
{
    padding-top: 2em;
}

div.attribute-tipafriend a
{
    padding-left: 26px;
    background-position: left center;
}

/* FOLDER */
div.content-view-full div.class-folder div.attribute-long
{
    margin: 0 0 1.5em 0;
    padding: 0 0 1em 0;
    border-bottom: 1px solid #656565;
}

div.content-view-full div.class-folder div.content-view-children div.content-view-line
{
    margin: 1em 0 1em 0;
}


/* BOX GENERAL DESIGN */

div.border-box
{
    margin-bottom: 1em;
}

/* Default box style */

div.border-box div.border-tl
{
    background: url(../images/box-1/border-tl.gif) no-repeat top left;
}

div.border-box div.border-tr
{
    background: url(../images/box-1/border-tr.gif) no-repeat top right;
    padding: 0 4px 0 4px;
}

div.border-box div.border-tc
{
    font-size: 0;
    height: 4px;
    background: url(../images/box-1/border-tc.gif) repeat-x top left;
}

div.border-box div.border-ml
{
    background: url(../images/box-1/border-ml.gif) repeat-y center left;
}

div.border-box div.border-mr
{
    background: url(../images/box-1/border-mr.gif) repeat-y center right;
    padding: 0 1px 0 1px;
}

div.border-box div.border-mc
{
    height: 1%; /* Preventing margins on content from breaking the box (for IE) */
    background-color: #ffffff;
    padding: 0.5em 0.75em 0.5em 0.75em;
}

div.border-box div.border-mc:before, div.border-box div.border-mc:after /* Preventing margins on content from breaking the box */
{
    content: "-";
    height: 0;
    visibility: hidden;
    display: block;
    clear: both;
}

div.border-box div.border-bl
{
    background: url(../images/box-1/border-bl.gif) no-repeat bottom left;
}

div.border-box div.border-br
{
    background: url(../images/box-1/border-br.gif) no-repeat bottom right;
    padding: 0 4px 0 4px;
}

div.border-box div.border-bc
{
    font-size: 0;
    height: 4px;
    background: url(../images/box-1/border-bc.gif) repeat-x bottom left;
}

/* Box 2 (light grey with border #f7f7f7 ) */

div.box-2 div.border-tl
{
    background-image: url(../images/box-2/border-tl.gif);
/* 	background-repeat: repeat-y;
	background-color: none; */
}

div.box-2 div.border-tr
{
    background-image: url(../images/box-2/border-tr.gif);
    padding: 0 7px 0 7px;
}

div.box-2 div.border-tc
{
    background-image: url(../images/box-2/border-tc.gif);
    height: 7px;
	background-color: #f7f7f7;
}

div.box-2 div.border-tc h2
{
	margin: 0em; padding: 0em;
}

div.box-2 div.border-ml
{
    background-image: url(../images/box-2/border-ml.gif);
}

div.box-2 div.border-mr
{
    background-image: url(../images/box-2/border-mr.gif);
    padding: 0 2px 0 2px;
}

div.box-2 div.border-mc
{
    background: #f7f7f7 url(../images/box-2/border-mc.gif) repeat-x top left;
/*     padding: 0.5em 0.75em 0.5em 0.75em; */
	padding: 2px 3px 2px 3px;
}

div.box-2 div.border-bl
{
    background-image: url(../images/box-2/border-bl.gif);
}

div.box-2 div.border-br
{
    background-image: url(../images/box-2/border-br.gif);
    padding: 0 7px 0 7px;
}

div.box-2 div.border-bc
{
    height: 7px;
	background-image: url(../images/box-2/border-bc.gif);
}


/* Box 3 */

div.box-3 div.border-tl
{
    background-image: url(../images/box-3/border-tl.gif);
/* 	background-repeat: repeat-y;
	background-color: none; */
}

div.box-3 div.border-tr
{
    background-image: url(../images/box-3/border-tr.gif);
}

div.box-3 div.border-tc
{
    background-image: url(../images/box-3/border-tc.gif);
	background-color: #fafafa; 
}

div.box-3 div.border-tc h2
{
	margin: 0em; padding: 0em;
}

div.box-3 div.border-ml
{
    background-image: url(../images/box-3/border-ml.gif);
}

div.box-3 div.border-mr
{
    background-image: url(../images/box-3/border-mr.gif);
}

div.box-3 div.border-mc
{
    background: #f4f4f4 url(../images/box-3/border-mc.gif) repeat-x top left;
}

div.box-3 div.border-bl
{
    background-image: url(../images/box-3/border-bl.gif);
}

div.box-3 div.border-br
{
    background-image: url(../images/box-3/border-br.gif);
}

div.box-3 div.border-bc
{
    background-image: url(../images/box-3/border-bc.gif);
}


/* BOX CUSTOM */

.custom_block_hdr
{
	margin: 0em;
	padding: 0em;
}
div.box-header, div.box-footer 
{
	font-weight: normal;
	font-family: Tahoma, sans-serif;
	font-size: 0.9em;
	margin: 0;
}
div.box-header {
	clear: both;
	float: none;
/* 	_height: 1%; */
	height: 2em;
	line-height: 2.2em;
	overflow: hidden;
/* 	background: linen; */
	margin: 0em 0em 0em 0em;
}
div.box-footer { 
	margin-top: 0.5em; 
	line-height: 1em;
}

div.box-header a, div.box-footer a { color: black; }
div.box-header a:hover, , div.box-footer a:hover { color: black; }

div.box-header a.topics
{
	font-weight: bold;
/* 	font-family: Arial, sans-serif; */
	float: left;
	display: block;
}
div.box-header a.alltopics
{
	float: right; clear: none;
	display: block;
}
div.box-footer a.add_comment
{
	float: right;
	display: block;
}

div.box-footer a:hover
{
	text-decoration: strike;
/*	cursor: help; */
}


/* FRONTPAGE COLUMNS  */

div.columns-frontpage div.content-view-line {
	padding: 0.5em 0em 1em 0;
}

div.columns-frontpage div.content-view-line h2 {
	margin: 0;
	padding: 0 0px 0 0em;
	
	font: bold 1.5em Times, serif;
}

div.columns-frontpage div.center-column div.content-view-line {
	padding-left: 1em;
}

div.columns-frontpage div.center-column div.content-view-line h2 {
	font-size: 1.7em;
}


div.columns-frontpage div.left-column-position div.left-column div.content-view-line .attribute-short {
	padding: 0 10px 0 0em;
}

div.columns-frontpage div.left-column-position div.left-column div.content-view-line .attribute-topic {
	font-style: italic;
	margin-right: 0.5em;
}

div.columns-frontpage div.left-column-position div.left-column .attribute-image {
	margin-top: 5px;
}

/* BLOGS  */
#blogs div.content-view-children
{
	padding: 0px 5px;
	margin: 0px 5px;
}

#blogs table td { width: 50%; vertical-align: top; }
div.dotted { height: 1px; font-size: 1px; border-bottom: 1px dotted black; width: 90%; margin: 0 auto 5px auto; _margin-left: 5%;}

#blogs div.attribute-short { font-size: 0.9em; }
#blogs h2, #blogs h3  { font-size: 0.9em; font-family: Arial, sans-serif; }

#blogs h2 a, #blogs h2 a:visited,
#blogs h3 a, #blogs h3 a:visited
{
 color: #0072bc;
}

#blogs div.attribute-image
{
	margin-bottom: 1px; padding-bottom: 0em;
}

#local_view_hdr { text-align: center; padding: 0px 0 20px 0; position: static; margin-top: -5px; }

/* RIGHTCOL CUSTOM */

#newscol div.content-view-line h2 
{
	font: bold 1.3em/1.1em Times, serif;
	margin: 0.5em 0 0 0;
	padding: 0;
}

#newscol div.content-view-line p
{
	margin: 0 0 0.5em 0;
	padding: 0;
}


div#newscol h2 a, div#newscoll h2 a:visited
{
	color: #851c1c; /* #4095cd; */
}

div#newscol .attribute-short
{
	color: #851c1c;
}

div#newscol .attribute-short a, div#newscol .attribute-short a:visited
{
	color: #851c1c;
	text-decoration: none;
}

div#newscol .attribute-short b, 
div#newscol .attribute-short strong
{
	font-weight: bold;
	font-size: 1.2em;
	font-family: Times, serif;
}

 
/* div#newscol .attribute-short p:first-line 
{
	font-weight: bold;
	font-size: 1.2em;
	font-family: Times, serif;
}
*/
 
/* FRONTPAGE VIDEO */

div.content-view-frontpage#frontpage-video
{
	text-align: center;
	border: 1px solid black;
	border-width: 1px 0 1px 0;	
	margin: 2px 20px 5px 0px;
	padding: 10px 0;
}

#frontpage-video h2 
{
	font: bold 1.3em/1.1em Arial, sans-serif;
	margin: 0.5em 0 0.5em 0;
	padding: 0;
}

#frontpage-video h2 a, div#newscoll #frontpage-video h2 a:visited
{
	color: black;
}

#frontpage-video .attribute-short
{
	padding-top: 0.5em;
	color: black;
}

#frontpage-video .attribute-short a, #frontpage-video .attribute-short a:visited
{
	color: black;
	text-decoration: none;
}


#frontpage-video div.content-view-frontpage p
{
	margin: 0 0 0.5em 0;
	padding: 0;
}
div.content-view-frontpage#frontpage-video div.attribute-short p
{
	display: inline; 
}

#frontpage-video .attribute-short p:first-line 
{
	font-weight: normal;
	font-size: 1em;
	font-family: Arial, sans-serif;
}


/* LISTITEM */

div.content-view-listitem div.class-article h3 
{
/* 	font-size: 1em; */
}

/*  PERSON */

div.content-view-listitem div.class-article .person
{
	color: #000000 /* blue */
}

div.content-view-listitem div.class-article .person a, 
div.content-view-listitem div.class-article .person a:hover
{
	color: #000000 /* blue */
}

div.content-view-listitem div.class-article .person-position
{
	font-weight: normal;
	color: black;
	text-decoration: none;
}

/* INDICATORS */

table.indicators {
	background: #5C5C5C;
	color: white;
	line-height: 11px;
	font-size: 10px;
	margin: 0;
	padding: 0em;
}

table.indicators tr {
	margin: 0em;
	padding: 0em;
}

table.indicators td {
	margin: 0em;
	padding: 0px 2px;
/* 	text-align: left; */
}

table.indicators td p {
	margin: 1px 0em; 
	padding: 0em;
	white-space: nowrap;
}


/* GROUPS  */

div.content-view-full div.class-frontpage div.attribute-related-objects
{
	margin-bottom: 0.2em;
}

div.content-view-full div.class-frontpage div.attribute-related-objects p.linkmore
{
	margin: 0em;
}

div.content-view-full div.class-frontpage div.attribute-group-list
{
	margin-top: 0.2em;
}

/* POLLS  */

div.content-view-frontpage div.class-poll div.border-box div.border-mc a 
{
	color: white;
	background: #7C7C7C;
	text-decoration: underline; 
}

div.content-view-frontpage div.class-poll form input.button
{
	margin: 0px; 
	padding: 0px;
	text-indent: 0;
	_width: auto;
	border: none;
	color: white;
	background: #7C7C7C;
	_text-decoration: underline; 
 	cursor: pointer; 
	font-size: 11px;
}

div.content-view-frontpage div.class-poll form input[type=submit] {
/* 	text-decoration: underline; */
	border: 1px solid transparent; 
	border-bottom: 1px solid white; 
}

div.content-view-frontpage div.class-poll form input[type=submit]:hover {
/* 	text-decoration: underline; */
	border: 1px outset white; 
	cursor: hand;
}

div.content-view-frontpage div.class-poll form input[type=submit]:hover {
 	cursor: pointer; 
}


div.content-view-frontpage div.class-poll div.content-results div.attribute-link
{
	display: none; 
}

