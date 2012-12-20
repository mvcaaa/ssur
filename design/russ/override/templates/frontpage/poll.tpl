{*?template charset="koi8-r"?*}
{* Poll - Frontpage view *}

<div class="content-view-frontpage">
    <div class="class-poll">

        <div class="attribute-header">
            <h3>{$node.name|wash()}</h3>
        </div>

        <div class="attribute-short">
        {attribute_view_gui attribute=$node.data_map.description}
        </div>

        <form method="post" action={"content/action"|ezurl}>
        <input type="hidden" name="ContentNodeID" value="{$node.node_id}" />
        <input type="hidden" name="ContentObjectID" value="{$node.object.id}" />
        <input type="hidden" name="ViewMode" value="full" />

        <div class="content-question">
        {attribute_view_gui attribute=$node.data_map.question}
        </div>

        {if is_unset( $versionview_mode )}
        <input class="button" type="submit" name="ActionCollectInformation" value="Ответить" />
        {/if}
{* "Vote"|i18n("design/ezwebin/full/poll") *}
        </form>

        <div class="content-results">
            <div class="attribute-link">
                <p><a href={concat( "/content/collectedinfo/", $node.node_id, "/" )|ezurl}>{"Result"|i18n("design/base")}{* Результат *}</a></p>
            </div>
        </div>

    </div>
</div>
