/* 16pt=133% 15pt=125% 14pt=117% 13pt=108% 12pt=100% 11pt=92% 10pt=87% 9pt=75% 8pt=67% 7pt=57%*/

/*** COMMON ***/
.fix { clear: both; float: none; }

/* Article */
div.content-view-full div.class-article div.attribute-long a, 
div.content-view-full div.class-article div.attribute-long a:visited{ color: #851c1c; }

/* GENERAL TABLE */
table th{ background-color: transparent; }

/* Menu */
.size, .size0, .size1 { font-size: 1em; }
.size2 { font-size: 1.25em; }
.size3 { font-size: 1.5em; font-weight: normal;}
.size4 { font-size: 1.7em; font-weight: normal;}
.size5 { font-size: 1.8em; font-weight: normal;}

/*** Frontpage ***/
/* hot block */
.attribute-top-column{ padding: 0px; margin: 0px 5px 0px 5px; }
div#hotblock{ margin: 0em 0px 20px 0px; padding: 0px 0px 0px 0px; border-bottom: 3px double black; }
div#hotblock table{ width: 700px; }
div#hotblock td { border: 0px solid red; }
div#hotblock td#td_hotpic{ width: 390px; color: white; background-color: #8a8a8a; }
div#hotpic{ float: none; clear: both; margin: 0px; padding: 0px; }
div#onguard{ background-color: #cccccc; position: relative; padding: 0px; margin-bottom: 10px; width: 390px; height: 390px; }
div#onguard .attribute-short{ position: absolute; bottom: 0px; left: 0px; background: url(/60percent-bg.png) repeat 0 0 transparent; padding: 5px 0px 5px 0px; width: 390px; }
div#onguard .attribute-short a{ margin: 0px 10px; display: block; }
div#onguard a{ color: #fff !important; }
div#onguard .attribute-topline{ background: url(/60percent-bg.png) repeat 0 0 transparent; padding: 5px 0px 8px 0px; position: absolute; top: 0px; left: 0px; width: 390px }
div#onguard .attribute-topline h2,
div#onguard .attribute-topline .attribute-byline{ margin: 0px 10px; }

div#hotblock td#td_hotcontent{ width: 310px; color: white; background: #8a8a8a url(hot-top-text-bg.png) bottom left repeat-x; vertical-align: top; }
div#hotblock td#td_hotcontent .hot-author{ font-size: 24px; letter-spacing: 1px; color: white; font-weight: bold; text-shadow: #5A5A5A 1px 1px; }
td#td_hotcontent a, td#td_hotcontent a:visited{ color: white; text-decoration: none; }
td#td_hotcontent a:hover{ text-decoration: underline; }

.column-a h2{ margin: 3px 0px 0px 0px; }
.column-a h4{ margin: 3px 0px; }
.column-a h4 a{ color: #851C1C; }
.column-a .attribute-short p{ margin: 10px 0px 5px 0px; }

div#hotcontent
{
	display: block;
	padding: 0px;
	
/* 	background-color: #757575; */
	
/* 	border-right: 2px groove #555;
	border-bottom: 2px groove #555; */
	
}

div#hotcontent div.content-view-line h3 {
	margin: 0px 0 0 0; 
	padding: 0 0 0 0;
	font-weight: normal;
	font-size: 2.2em;	
	font-family: Arial, sans-serif;
	letter-spacing: -0.05em;
}

div#hotcontent div.content-view-line div.attribute-short p {
	font-size: 1.25em;
	margin: 0 2px 1em 0; 
	padding: 0;
}


.hot-author{ background-color: #764f4f; }
div#hottopic
{
/* 	height: 95px; */
	color: white;
	background-color: #424242;
}
#td_week_topic
{
	color: white;
/* 	background-color: #851c1c; */
	background: #2B7793 url(hot-top-bg.png) top left repeat-x;
	height: 55px;
	vertical-align: middle;
	padding: 0px 0px 0px 20px;
}

div#week_topic
{
	float: none;
	font-size: 30px;
	color: white;
	font-weight: normal;
	text-shadow: #5A5A5A 1px 1px;
/* 	background-color: #851c1c; */

}
div#hotblock td#td_topic_name
{
	color: white;
	background: url(hot-top-arr.png) no-repeat 0px -10px #496068;
	vertical-align: middle;
	padding: 0px 0px 0px 30px;
}

div#topic_name
{
	float: none;
/* 	height: 95px; */
	font-size: 25px;
	letter-spacing: 1px;
	color: white;
	font-weight: normal;
	text-shadow: #000000 1px 1px;
}

div#topic_name a, div#topic_name a:visited 
{
	color: white;
	background-color: #496068;
	text-decoration: none;
}

div#topic_name a:hover
{
	text-decoration: underline;
}

p.bio
{
	margin: 0;
	padding: 0;
	text-indent: 20px;
	font-weight: bold;
	color: #2a3350; 
}
.bio a, .bio a:visited
{
	color: #2a3350; 
}

/* GO BUTTON */

#go_topic
{
	vertical-align: middle;
	position: relative;
}
#go_topic img 
{
 	margin-left: 0.5em;
}


/* hotdoc1 */
div#hotdoc1 
{
	padding: 0 1em;
}

div#hotdoc1 h3
{
	color: #953a3a;
	background: none;
	font: bold 20pt Arial, sans-serif;
	letter-spacing: -0.05em;
	margin: 1em 0 0 0;
	padding: 0;
}

div#hotdoc1 h3 a, div#hotdoc1 h3 a:visited, div#hotdoc1 h3 a:hover
{
	color: #953a3a;
	background: none;
	text-decoration: none;
}

div#hotdoc1 .attribute-short {
	margin: 0;
	padding: 0 0 0em 0;
	
	color: #444444;
	background: none;
	font: normal 16pt/14pt Arial, sans-serif;
}

div#hotdoc1 .attribute-short p
{
	line-height: 14pt;
	margin: 0em 0em;
	padding: 0em 0em 0.2em 0em;
}

div#hotdoc1 .attribute-short a, div#hotdoc1 .attribute-short a:visited
{
	color: #444444;
	background: none;
	text-decoration: none;
}
/* BEST */

div#best {
	margin: 0 0 1em 0;
	padding: 0 0 0em 0;
	border-bottom: 3px double black;
}

div#best div.content-view-listitem
{
	margin: 0.5em 0 0.5em 0;
	padding: 0 0 0.5em 0;
	text-align: center;
	border-bottom: 1px solid black;
}
div#best div.last
{
	border-bottom: none;
	padding-bottom: 0em;
}

div#best div.content-view-listitem h3
{
	font: normal 1.5em Times, serif;
}

/* ACADEM */

#academ div.content-view-line
{
	text-align: center;
	padding: 0 0 5px 20px;
	margin: 0 0 10px 0;
}

#academ h2
{
	font-family: Arial, sans-serif;
}	

#academ h2 a, #academ h2 a:visited
{
	color: #8a8a8a;
}

#academ div.attribute-image
{
	float: none;
	clear: both;
}
#academ div.attribute-short
{
	border-bottom: 3px double black;
}

#academ div.content-view-line
{
	margin: 10px 0 10px 0;
	padding: 5px 0 5px 0px;
	border: 1px solid black;
	border-width: 1px 0 1px 0;	
}

#academ div.content-view-line .attribute-short a:visited
{
	color: black;
}



/* BOOK */

#workbook div.content-view-line,
#pushkin div.content-view-line,
#book div.content-view-line
{
	text-align: left;
	padding: 0 0 10px 0px;
	margin: 0 0 10px 0;
	border-bottom: 3px double black;
}

#workbook h2,
#pushkin h2,
#book h2
{
	font-family: Arial, sans-serif;
}	

#workbook h2 a, #workbook h2 a:visited,
#pushkin h2 a, #pushkin h2 a:visited,
#book h2 a, #book h2 a:visited
{
	color: #8a8a8a;
}

#workbook div.attribute-image,
#pushkin div.attribute-image
{
	float: none;
	clear: both;
}
#book .attribute-image{ border: 0px; float: left; clear: none; margin: 3px 7px 0px 0px; }
#workbook div.attribute-short,
#book div.attribute-short
{
	padding: 0px 0px 0px 0px;
}
#book div.attribute-short p{ margin: 0px; }
#pushkin div.content-view-line
{
	margin: 10px 0 10px 0;
	padding: 5px 0 5px 0px;
	border: 1px solid black;
	border-width: 1px 0 1px 0;	
}

div#newscol #pushkin div.content-view-line .attribute-short,
#pushkin div.content-view-line .attribute-short a,
#pushkin div.content-view-line .attribute-short a:visited
{
	color: black;
}

/* COMMENTS */

.sect#commentaries {
/*	background-color: #FCF7F1; */
	padding: 0em 1em 1em 0em; 
	max-height: 50em;
	overflow: auto;
}
.sect#commentaries h3 {
	margin: 1em 0em 0em 0em; 
}

.sect#commentaries .bl {
	border-top: 1px dashed #7A7A7A; 
	margin: 1em 0em 0em 1em; 
}
.sect#commentaries .hdr { padding: 0em 0em 0em 0em; margin: 0em; }

.sect#commentaries form { 
	border-top: 1px dashed #7A7A7A; 
	margin: 1em 0em 0em 1em; 
	padding: 1em 0em 0em 0em;
}

.content-view-line .class-comment .attribute-byline {  }
.content-view-line .class-comment .attribute-byline p.date { text-align: right; }

.sect#commentaries div.date { clear: none; float: right; }
.sect#commentaries .author { font-style: italic; }
	
/* FOOTER */
div#footer table{ width: 100%; }
div#footer table td{ text-align: left; vertical-align: middle; }
div#footer td#counters table td{ text-align: right; }
div.adblock{ margin: 1em 1em; font-size: 90%; color: black; width: 185px; }
div.adblock .PartnHead { display: none; }
div.adblock .OzonRev_itemList { align: center; }
.adblock a, .adblock a:visited { color: #851c1c; text-decoration: none; }
#rightcol div.adblock{ border-top: 3px double black; padding-top: 0.5em; margin: 1em 0em; font-size: 90%; color: #851C1C; }