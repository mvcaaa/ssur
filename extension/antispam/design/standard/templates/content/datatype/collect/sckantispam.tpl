{set-block scope=global variable=cache_ttl}0{/set-block}

{default attribute_base='ContentObjectAttribute' html_class='full'}
<img src={antispam(challenge($attribute), $attribute.class_content.ini_block)|ezroot} alt="Antispam" />
<br /><input type="text" size="10" name="{$attribute_base}_sckantispam_answer_{$attribute.id}" value="" />
{/default}
