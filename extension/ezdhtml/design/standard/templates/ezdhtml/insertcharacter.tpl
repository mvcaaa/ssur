<script type="text/javascript" for="window" event="onload">
<!--
    printCharTable();
// -->
</script>

<script type="text/javascript">
<!--
function insert(charValue)
{literal}{{/literal}
    var arr = new Array();
    arr["charValue"] = charValue;
    window.returnValue = arr;
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

function printCharTable()
{literal}{{/literal}
    var tbody = document.getElementById("charTable").getElementsByTagName("tbody")[0];
    var specialChars = [{section loop=$chars}{delimiter},{/delimiter}"{$item}"{/section}];
    var cols = 15 ;
    var i = 0;
    while ( i < specialChars.length )
    {literal}{{/literal}
        var row = document.createElement( '<tr>' );
        for( var j = 0; j<cols; j++ )
        {literal}{{/literal}
            var td = null;
            if ( specialChars[i] )
            {literal}{{/literal}
                td = document.createElement( '<td class="character" width="20" align="center" onclick="insert(\'' + specialChars[i] + '\')" onmouseover="onSelect(this)" onmouseout="onOut(this)">');
                td.innerHTML = specialChars[i];
            {literal}}{/literal}
            else
            {literal}{{/literal}
                td = document.createElement( '<td class="character" width="20" align="center">' );
                td.innerHTML = "&nbsp;";
            {literal}}{/literal}
            i++ ;
        row.appendChild(td);
        {literal}}{/literal}
        tbody.appendChild(row);
    {literal}}{/literal}
{literal}}{/literal}
// -->
</script>

<div class="onlineeditor">

<h1>{"Insert special character"|i18n("design/standard/ezdhtml")}</h1>

<table id="charTable" class="characterTable" width="380" border="1" cellpadding="2" cellspacing="2">
</table>

<div id="zoomedChararcter" class="displaycharacter">
&nbsp;
</div>

<input type="button" class="button" onclick="window.close();" value={"Cancel"|i18n("design/standard/ezdhtml")} />

</div>
