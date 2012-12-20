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

    if ( attrsPresent )
        lastPropertyRow.style.display="none";
    else
        lastPropertyRow.style.display="block";
}

function addNew()
{
    var tbody = document.getElementById("attributes").getElementsByTagName("tbody")[0];
    var row1 = document.createElement("tr");
    var td1 = document.createElement("td");
    var checkbox1 = document.createElement("<input type='checkbox' id='Selected_attribute' />");
{/literal}{if ge($ezpublish_version, 3.9)}checkbox1.style.display="none";{/if}{literal}
    td1.appendChild(checkbox1);
    var td2 = document.createElement("td");
    var input1 = document.createElement("<input id='CustomAttributeName' type='text' size='10' />");
    td2.appendChild(input1);
    var td3 = document.createElement("td");
    var input2 = document.createElement("<input id='CustomAttributeValue' type='text' size='10' />");
    td3.appendChild(input2);
    row1.appendChild(td1);
    row1.appendChild(td2);
    row1.appendChild(td3);
    tbody.insertBefore(row1,lastPropertyRow);
    lastPropertyRow.style.display="none";
}

function addAttribute( attrName, attrValue, isDisabled )
{
    var tbody = document.getElementById("attributes").getElementsByTagName("tbody")[0];
    var row1 = document.createElement("tr");
    var td1 = document.createElement("td");
    var checkbox1 = document.createElement("<input type='checkbox' id='Selected_attribute' />");
    if ( isDisabled == true )
        checkbox1.disabled = true;
{/literal}{if ge($ezpublish_version, 3.9)}checkbox1.style.display="none";{/if}{literal}
    td1.appendChild(checkbox1);
    var td2 = document.createElement("td");
    var input1;
    input1 = document.createElement("<input id='CustomAttributeName' type='text' size='10' />");
    input1.value = attrName;
    if ( isDisabled == true )
        input1.disabled = true;
    td2.appendChild(input1);
    var td3 = document.createElement("td");
    var input2 = document.createElement("<input id='CustomAttributeValue' type='text' size='10' />");
    input2.value = attrValue;
    td3.appendChild(input2);
    row1.appendChild(td1);
    row1.appendChild(td2);
    row1.appendChild(td3);
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
        if ( tr.firstChild.nextSibling.firstChild.nodeName == 'INPUT' )
            tbody.removeChild(tr);

        if ( !next )
            break;
        tr = next;
    }
}

function removeSelected()
{
    var tbody = document.getElementById("attributes").getElementsByTagName("tbody")[0];
    var tr = tbody.firstChild.nextSibling;
    while ( tr.id != "lastPropertyRow" )
    {
        next = tr.nextSibling;

        // remove only custom attributes
        if ( tr.firstChild.nextSibling.firstChild.nodeName == 'INPUT' &&
             tr.firstChild.firstChild.checked )
            tbody.removeChild(tr);

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

