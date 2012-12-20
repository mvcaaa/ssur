{* Video FLV - Full view *}

<div class="content-view-full">
    <div class="class-video-flv">

<h1>{$node.name}</h1>

        {if $node.data_map.person.has_content}
        <div class="attribute-byline">
        <p class="author">
             {attribute_view_gui attribute=$node.data_map.person}
        </p>
        </div>
        {/if}


{attribute_view_gui attribute=$node.object.data_map.file show_original=0 correct_size=1}

{attribute_view_gui attribute=$node.object.data_map.description}

{*
<h2>Теги</h2>
{attribute_view_gui attribute=$node.object.data_map.tags}
*}

    </div>
</div>