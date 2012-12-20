{* Video FLV - Line view *}

<div class="content-view-line">
    <div class="class-video-flv">

<h1><a href={$node.url_alias|ezurl}>{$node.name}</a></h1>

{attribute_view_gui attribute=$node.object.data_map.file size=half correct_size=1}

{attribute_view_gui attribute=$node.object.data_map.description}

{*
<div class="float-break">
<h2 style="float: left; line-height: 1em; margin: 0em 0.5em 0em 0em;">Теги:</h2>
<div style="float: left; vertical-align: middle; ">{attribute_view_gui attribute=$node.object.data_map.tags}</div>
</div>
*}

    </div>
</div>
