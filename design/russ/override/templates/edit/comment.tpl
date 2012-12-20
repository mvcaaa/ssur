{*?template charset="koi8-r"?*}
<form enctype="multipart/form-data" method="post" action={concat( "/content/edit/", $object.id, "/", $edit_version, "/", $edit_language|not|choose( concat( $edit_language, "/" ), '' ) )|ezurl}>

{* $object.data_map |attribute(show, 2) *}
{def $main_node = fetch( content, node, hash( node_id, $main_node_id ))}
{* $main_node |attribute(show, 1) *}
<div class="edit">
    <div class="class-article-comment">

<div class="doc">
<div class="text">
<!--     <h1>{"Edit %1 - %2"|i18n("design/standard/content/edit",,array($class.name|wash,$object.name|wash))}</h1> -->
    <h1 class=hdr>{$main_node.name|wash}</h1>
	
	<h3 class=hdr>Оставьте Ваш комментарий:</h3>

    {include uri="design:content/edit_validation.tpl"}

    <br/>

       <div class="block">
       {let attribute=$object.data_map.subject}
       <input type="hidden" name="ContentObjectAttribute_id[]" value="{$attribute.id}" />
{* <!-- 
       <label>{$attribute.contentclass_attribute.name}</label><div class="labelbreak"></div>
       <input class="box" type="text" size="70" name="ContentObjectAttribute_ezstring_data_text_{$attribute.id}" value="{$attribute.data_text}" />
 --> *}
       {/let}
    </div>
 
    {let user=fetch( user, current_user )
         attribute=$object.data_map.author}
    <div class="block">
        {section show=$user.is_logged_in}

        <input type="hidden" name="ContentObjectAttribute_ezstring_data_text_{$attribute.id}" value="{$user.contentobject.name}" />
        {section-else}
            <label>{$attribute.contentclass_attribute.name}</label><div class="labelbreak"></div>
	    <input type="hidden" name="ContentObjectAttribute_id[]" value="{$attribute.id}" />
	    <input class="box" type="text" size="70" name="ContentObjectAttribute_ezstring_data_text_{$attribute.id}" value="{$attribute.data_text}" />
        {/section}
    </div>
    {/let}

    <div class="block">
       {let attribute=$object.data_map.message}
       <label>{$attribute.contentclass_attribute.name}</label><div class="labelbreak"></div>
       <input type="hidden" name="ContentObjectAttribute_id[]" value="{$attribute.id}" />
       <textarea class="box" cols="70" rows="10" name="ContentObjectAttribute_data_text_{$attribute.id}">{$attribute.data_text}</textarea>
       {/let}
    </div>


<div class="attribute-captcha">
<p>Чтобы избежать спама в комментариях, пожалуйста введите <b>цифры</b> на картинке в поле ввода под картинкой.
{* 'To prevent commentspamming, please enter the string you see in the image below in the input box beneath the image.'|i18n('design/standard/content/edit') *}</p>
{* <!-- <p><strong>Строчные буквы и цифры:</strong></p> --> *}
{* 'Capital letters and numbers:'|i18n('design/standard/content/edit') *}
{def $attribute=$object.data_map.captcha}
<img src={antispam(challenge($attribute),$attribute.class_content.ini_block)|ezroot} alt="Antispam" border=0>
<br />
<input type="text" name="ContentObjectAttribute_sckantispam_answer_{$attribute.id}" value="" />
<input type="hidden" name="ContentObjectAttribute_id[]" value="{$attribute.id}" />
</div>



    <div class="buttonblock">
        <input class="defaultbutton" type="submit" name="PublishButton" value="{'Send for publishing'|i18n('design/standard/content/edit')}" />
	    <input class="button" type="submit" name="DiscardButton" value="{'Discard'|i18n('design/standard/content/edit')}" />
        <input type="hidden" name="MainNodeID" value="{$main_node_id }" />
        <input type="hidden" name="DiscardConfirm" value="0" />
    </div>

</div><!-- /text -->
</div><!-- /doc -->
	
    </div>
</div>
</form>
