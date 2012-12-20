{def $class_content=$class_attribute.content}

<label>Password strength</label>
<table>
<tr><td colspan="2">Password length: <input type="text" name="ContentClass_sckantispam_length_{$class_attribute.id}" value="{$class_content.length}" size="2" /></td></tr>
<tr><td><input type="checkbox" name="ContentClass_sckantispam_uppercase_{$class_attribute.id}" {if $class_content.uppercase}checked="checked"{/if} /></td><td>Uppercase (A-Z)</td></tr>
<tr><td><input type="checkbox" name="ContentClass_sckantispam_lowercase_{$class_attribute.id}" {if $class_content.lowercase}checked="checked"{/if} /></td><td>Lowercase (a-z)</tr>
<tr><td><input type="checkbox" name="ContentClass_sckantispam_numeric_{$class_attribute.id}" {if $class_content.numeric}checked="checked"{/if} /></td><td>Numeric (0-9)</td></tr>
<tr><td><input type="checkbox" name="ContentClass_sckantispam_custom_{$class_attribute.id}" {if $class_content.custom}checked="checked"{/if} /></td><td>Custom: <input type="text" name="ContentClass_sckantispam_customchars_{$class_attribute.id}" value="{$class_content.customchars}" size="50"/></td></tr>
</table>

<label>Ignore</label>
Characters: <input type="text" name="ContentClass_sckantispam_ignore_{$class_attribute.id}" value="{$class_content.ignore}" size="50"/>

<label>Image options</label>
INI block: <input type="text" name="ContentClass_sckantispam_ini_{$class_attribute.id}" value="{$class_content.ini_block}"/>

{undef $class_content}
