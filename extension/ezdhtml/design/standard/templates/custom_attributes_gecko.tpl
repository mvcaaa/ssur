{literal}
<script type="text/javascript">

var customAttrDefaults = new Array();

function displayAttributes( tagName, customAttributes )
{
    var defaultAttrCount = 0;
    for( var key in this.customAttrDefaults[tagName] )
    {
        defaultAttrCount++;
    }

    // display other attributes
    if ( customAttributes != -1 )
    {
        var attributeArray = customAttributes.split("attribute_separation");
        var attributes = new Array();
        for ( var i=0;i<attributeArray.length;i++ )
        {
            var attributePair = attributeArray[i].split("|");
            attributes[attributePair[0]] = attributePair[1];
    
            // attributePair[0] is attribute name
            // attributePair[1] is value
            found = false;
            for( var key in this.customAttrDefaults[tagName] )
            {
                if ( key == attributePair[0] )
                {
                    this.customAttrDefaults[tagName][key] = attributePair[1];
                    found = true;
                }
            }
            if ( !found )
            {
                this.customAttrDefaults[tagName][attributePair[0]] = attributePair[1];
            }
        }
    }

    // Default attributes should have disabled checkboxes.
    var attrCount = 0;
    var isDisabled = true;
    var attrsPresent = false;
    for( var key in this.customAttrDefaults[tagName] )
    {
        if ( attrCount >= defaultAttrCount )
            isDisabled = false;
        else
            isDisabled = true;

        attrCount++;

        addAttribute( key, this.customAttrDefaults[tagName][key], isDisabled );
        attrsPresent = true;
    }

    var lastPropertyRow = document.getElementById("lastPropertyRow");
    if ( attrsPresent )
        lastPropertyRow.style.display="none";
    else
        lastPropertyRow.style.display="table-row";
}

function addNew()
{
    var tbody = document.getElementById("attributes").getElementsByTagName("tbody")[0];
    var row1 = document.createElement("tr");
    row1.class = 'customAttrRow';
    var td1 = document.createElement("td");
    var checkbox1 = document.createElement("input");
    checkbox1.setAttribute( 'name', 'Selected_attribute' );
    checkbox1.setAttribute( 'type', 'checkbox' );
{/literal}{if ge($ezpublish_version, 3.9)}checkbox1.style.display="none";{/if}{literal}
    td1.appendChild(checkbox1);
    var td2 = document.createElement("td");
    var input1 = document.createElement("input");
    input1.setAttribute( 'name', 'CustomAttributeName' );
    input1.setAttribute( 'type', 'text' );
    input1.setAttribute( 'size', '10' );
    td2.appendChild(input1);
    var td3 = document.createElement("td");
    var input2 = document.createElement("input");
    input2.setAttribute( 'name', 'CustomAttributeValue' );
    input2.setAttribute( 'type', 'text' );
    input2.setAttribute( 'size', '10' );
    td3.appendChild(input2);
    row1.appendChild(td1);
    row1.appendChild(td2);
    row1.appendChild(td3);
    var lastPropertyRow = document.getElementById("lastPropertyRow");
    tbody.insertBefore(row1,lastPropertyRow);
    lastPropertyRow.style.display="none";
}

function addAttribute( attrName, attrValue, isDisabled )
{
    var tbody = document.getElementById("attributes").getElementsByTagName("tbody")[0];
    var row1 = document.createElement("tr");
    row1.class = 'customAttrRow';
    var td1 = document.createElement("td");
    var checkbox1 = document.createElement("input");
    checkbox1.setAttribute( 'name', 'Selected_attribute' );
    checkbox1.setAttribute( 'type', 'checkbox' );
    if ( isDisabled == true )
        checkbox1.disabled = true;
{/literal}{if ge($ezpublish_version, 3.9)}checkbox1.style.display="none";{/if}{literal}
    td1.appendChild(checkbox1);
    var td2 = document.createElement("td");
    var input1 = document.createElement("input");
    input1.setAttribute( 'name', 'CustomAttributeName' );
    input1.setAttribute( 'type', 'text' );
    input1.setAttribute( 'size', '10' );
    input1.value = attrName;
    if ( isDisabled == true )
        input1.setAttribute( 'readonly', true );
    td2.appendChild(input1);
    var td3 = document.createElement("td");
    var input2 = document.createElement("input");
    input2.setAttribute( 'name', 'CustomAttributeValue' );
    input2.setAttribute( 'type', 'text' );
    input2.setAttribute( 'size', '10' );
    input2.value = attrValue;
    td3.appendChild(input2);
    row1.appendChild(td1);
    row1.appendChild(td2);
    row1.appendChild(td3);
    var lastPropertyRow = document.getElementById("lastPropertyRow");
    tbody.insertBefore(row1,lastPropertyRow);
}

function removeAttributes()
{
    var tbody = document.getElementById("attributes").getElementsByTagName("tbody")[0];
    var tr = tbody.firstChild.nextSibling;
    while ( tr.id != "lastPropertyRow" )
    {
        next = tr.nextSibling;

        // remove only custom attributes
        if ( tr.class == 'customAttrRow' )
            tbody.removeChild(tr);

        if ( !next )
            break;
        tr = next;
    }
}

function removeSelected()
{
    var tbody = document.getElementById("attributes").getElementsByTagName("tbody")[0];
    if ( tbody.firstChild.nextSibling == 'TR' )
        tr = tbody.firstChild.nextSibling;
    else
        tr = tbody.firstChild.nextSibling.nextSibling;

    while ( tr.id != "lastPropertyRow" )
    {
        if ( tr.nextSibling.nodeName == 'TR' )
            next = tr.nextSibling;
        else
            next = tr.nextSibling.nextSibling;

        if ( tr.firstChild.nodeName == 'TD' )
        {
            // remove only custom attributes
            if ( tr.firstChild.nextSibling.firstChild.nodeName == 'INPUT' )
            {
                if ( tr.firstChild.firstChild.checked )
                    tbody.removeChild(tr);
            }
        }

        if ( !next )
            break;
        tr = next;
    }
}

function packCustomAttributes( CustomAttributeName, CustomAttributeValue )
{
    var customAttributes = new Array();
    if ( CustomAttributeName.length != null )
    {
        var j = 0;
        for (var i=0;i<CustomAttributeName.length;i++)
        {
            if ( CustomAttributeValue.length != null )
            {
                if ( CustomAttributeValue[i].value != "" )
                    customAttributes[j++]=CustomAttributeName[i].value + "|" + CustomAttributeValue[i].value;
            }
            else
            {
                if ( CustomAttributeValue.value != "" )
                    customAttributes[j++]=CustomAttributeName[i].value + "|" + CustomAttributeValue.value
            }
        }
    }
    else
    {
        if ( CustomAttributeValue.value != "" )
            customAttributes[0]=CustomAttributeName.value + "|" + CustomAttributeValue.value;
    }
    
    return customAttributes;
}

</script>

{/literal}

