<script type="text/javascript">
<!--
function Init()
{literal}{{/literal}
    var editorID = opener.document.getElementById("iframeID").value;
    document.getElementById("editorID").value = editorID;
{literal}}{/literal}

function insert(charValue)
{literal}{{/literal}
    var editorID = document.getElementById("editorID").value;
    opener.addCharacter( editorID, charValue );
    window.close();
{literal}}{/literal}

function onSelect(cell)
{literal}{{/literal}
    var zoomedChararcter = document.getElementById("zoomedChararcter");
    zoomedChararcter.innerHTML = cell.innerHTML ;
    cell.className = 'selectedCharacter';
{literal}}{/literal}

function onOut(cell)
{literal}{{/literal}
    cell.className = 'character';
{literal}}{/literal}
// -->
</script>

<div class="onlineeditor">

<input type="hidden" id="editorID" value="" />
<h1>{"Insert special character"|i18n("design/standard/ezdhtml")}</h1>

<table class="characterTable" width="380" border="1" cellpadding="2" cellspacing=2">
    <script type="text/javascript">
    var specialChars = [{section loop=$chars}{delimiter},{/delimiter}"{$item}"{/section}];
    var cols = 15 ;
    var i = 0;
    while ( i < specialChars.length )
    {literal}{{/literal}
        document.write( '<tr>' );
        for( var j = 0; j<cols; j++ )
        {literal}{{/literal}
            if ( specialChars[i] )
            {literal}{{/literal}
                document.write( '<td class="character" width="20" align="center" onclick=insert("' + specialChars[i] + '") onmouseover="onSelect(this)" onmouseout="onOut(this)">');
                document.write( specialChars[i] );
            {literal}}{/literal}
            else
                document.write( '<td class="character" width="20" align="center">&nbsp;' );
            document.write( '</td>' );
            i++ ;
        {literal}}{/literal}
        document.write( '</tr>' );
    {literal}}{/literal}
    </script>
</table>

<div id="zoomedChararcter" class="displaycharacter">
&nbsp;
</div>

<input type="submit" class="button" onclick="window.close();" value={"Cancel"|i18n("design/standard/ezdhtml")} />

</div>