{default parent_group_id=0
         current_depth=0
         offset=$view_parameters.offset item_limit=10
         summary_indentation=10}

{let group_tree=fetch("collaboration","group_tree",hash("parent_group_id",$parent_group_id))
     latest_item_count=fetch("collaboration","item_count",hash("is_active",true(),"parent_group_id",$parent_group_id))
     latest_item_list=fetch("collaboration","item_list",hash("limit",$item_limit,"offset",$offset,"is_active",true()))}


 <div class="context-block">

{* DESIGN: Header START *}<div class="box-header"><div class="box-tc"><div class="box-ml"><div class="box-mr"><div class="box-tl"><div class="box-tr">

<h1 class="context-title">{'Item list'|i18n( 'design/admin/collaboration/view/summary' )}</h1>

{* DESIGN: Mainline *}<div class="header-mainline"></div>

{* DESIGN: Header END *}</div></div></div></div></div></div>

{* DESIGN: Content START *}<div class="box-bc"><div class="box-ml"><div class="box-mr"><div class="box-bl"><div class="box-br"><div class="box-content">

{section show=$latest_item_count}

{include uri="design:collaboration/item_list.tpl" item_list=$latest_item_list}

{include name=Navigator
         uri='design:navigator/google.tpl'
         page_uri="/collaboration/view/summary"
         item_count=$latest_item_count
         view_parameters=$view_parameters
         item_limit=$item_limit}

{section-else}
<div class="block">
<p>{"No new items to be handled."|i18n('design/admin/collaboration/view/summary')}</p>
</div>
{/section}

{* DESIGN: Content END *}</div></div></div></div></div></div>

</div>

<div class="context-block">

{* DESIGN: Header START *}<div class="box-header"><div class="box-tc"><div class="box-ml"><div class="box-mr"><div class="box-tl"><div class="box-tr">

<h2 class="context-title">{'Group tree'|i18n( 'design/admin/collaboration/view/summary' )}</h2>

{* DESIGN: Mainline *}<div class="header-subline"></div>

{* DESIGN: Header END *}</div></div></div></div></div></div>

{* DESIGN: Content START *}<div class="box-bc"><div class="box-ml"><div class="box-mr"><div class="box-bl"><div class="box-br"><div class="box-content">

  {include uri="design:collaboration/group_tree.tpl" group_tree=$group_tree current_depth=$current_depth
           summary_indentation=$summary_indentation parent_group_id=$parent_group_id}

{* DESIGN: Content END *}</div></div></div></div></div></div>

</div>

{/let}

{/default}


