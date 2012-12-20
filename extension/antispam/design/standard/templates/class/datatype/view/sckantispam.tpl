{def $class_content=$class_attribute.content}

<label>Password strength</label>
<table>
<tr><td>Password length:</td><td>{$class_content.length}</td></tr>
<tr><td>Uppercase (A-Z)</td><td>{if $class_content.uppercase}Yes{else}No{/if}</td></tr>
<tr><td>Lowercase (a-z)</td><td>{if $class_content.lowercase}Yes{else}No{/if}</td></tr>
<tr><td>Numeric (0-9)</td><td>{if $class_content.numeric}Yes{else}No{/if}</tr>
<tr><td>Custom</td><td>{if $class_content.custom}Yes: {$class_content.customchars}{else}No{/if}</td></tr>
</table>
<br />
<label>Ignore</label>
Characters: {$class_content.ignore}
<br /><br />
<label>Image options</label>
INI block: {$class_content.ini_block}

{undef $class_content}
