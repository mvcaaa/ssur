{* DO NOT EDIT THIS FILE! Use an override template instead. *}
<form enctype="multipart/form-data"  action={"/user/register/"|ezurl} method="post" name="Register">

<div class="maincontentheader">
<h1>{"Register user"|i18n("design/standard/user")}</h1>
</div>

{section show=and( and( is_set( $checkErrNodeId ), $checkErrNodeId ), eq( $checkErrNodeId, true ) )}
    <div class="message-error">
        <h2><span class="time">[{currentdate()|l10n( shortdatetime )}]</span> {$errMsg}</h2>
    </div>
{/section}

{section show=$validation.processed}

    {section name=UnvalidatedAttributes loop=$validation.attributes show=$validation.attributes}
        <div class="warning">
        <h2>{"Input did not validate"|i18n("design/standard/user")}</h2>
        <ul>
        <li>{$UnvalidatedAttributes:item.name}: {$UnvalidatedAttributes:item.description}</li>
        </ul>
        </div>
    {section-else}
        <div class="feedback">
        <h2>{"Input was stored successfully"|i18n("design/standard/user")}</h2>
        </div>
    {/section}

{/section}

{section show=count($content_attributes)|gt(0)}
    {section name=ContentObjectAttribute loop=$content_attributes sequence=array(bglight,bgdark)}
    <input type="hidden" name="ContentObjectAttribute_id[]" value="{$ContentObjectAttribute:item.id}" />
    <div class="block">
        <label>{$ContentObjectAttribute:item.contentclass_attribute.name}</label><div class="labelbreak"></div>
        {attribute_edit_gui attribute=$ContentObjectAttribute:item}
    </div>
    {/section}

    <div class="block">
        <p>{"Please note that your browser must use and support cookies to register a new user."|i18n("design/standard/user")}</p>
    </div>

    <div class="buttonblock">
    {section show=and( is_set( $checkErrNodeId ), $checkErrNodeId )|not()}
        <input class="button" type="submit" name="PublishButton" value="{'Register'|i18n('design/standard/user')}" />
    {section-else}
        <input class="button" type="submit" name="PublishButton" disabled="disabled" value="{'Register'|i18n('design/standard/user')}" />
    {/section}
        <input class="button" type="submit" name="CancelButton" value="{'Discard'|i18n('design/standard/user')}" />
    </div>
{section-else}
    <div class="warning">
        <h2>{"Unable to register new user"|i18n("design/standard/user")}</h2>
    </div>
    <div class="buttonblock">
        <input class="button" type="submit" name="CancelButton" value="{'Back'|i18n('design/standard/user')}" />
    </div>
{/section}
</form>
