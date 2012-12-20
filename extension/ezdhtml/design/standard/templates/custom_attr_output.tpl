<fieldset>

<legend>{'Properties'|i18n('design/standard/ezdhtml')}</legend>

<table id="attributes" class="list" cellspacing="0">
    <tr>
        <th class="tight">&nbsp;</th>
        <th width="30%">{'Attribute name'|i18n('design/standard/ezdhtml')}</th>
        <th width="60%">{'Value'|i18n('design/standard/ezdhtml')}</th>
    </tr>
    <tr id="lastPropertyRow" style="display: block">
        <td colspan="3"><h4>{'There are no attributes defined'|i18n('design/standard/ezdhtml')}</h4></td>
    </tr>
</table>

{if lt($ezpublish_version, 3.9)}
<div class="block">
    <input type="submit" class="button" id="remove_attribute" value="{'Remove selected'|i18n('design/standard/ezdhtml')}" onclick='removeSelected()' />
	<input type="submit" class="button" id="new_attribute" value="{'New attribute'|i18n('design/standard/ezdhtml')}" onclick='addNew()' />
</div>
{/if}

</fieldset>
