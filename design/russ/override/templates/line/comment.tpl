{* Comment - Line view *}

<div class="content-view-line">
    <div class="class-comment">
<div class="bl">
	<div class="date">{$node.object.published|l10n(date)} | {$node.object.published|l10n(shorttime)}</div>

{*    <h3 class=hdr>{$node.name}</h3> *}

    <div class="attribute-byline">
        <p class="author">{$node.object.data_map.author.content|wash}</p>
        <div class="break"></div>
    </div>

    <div class="attribute-message">
        {$node.object.data_map.message.content|wash(xhtml)|break}
    </div>
</div><!-- /block -->
    </div>
</div>