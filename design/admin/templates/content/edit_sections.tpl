{* DO NOT EDIT THIS FILE! Use an override template instead. *}

{* DESIGN: Header START *}
<div class="box-header"><div class="box-tc"><div class="box-ml"><div class="box-mr"><div class="box-tl"><div class="box-tr">

{* get the sections list which consist of: sections allowed to assign to the object by the
   current loged in user, plus the section which is currently assigned to the object *}
{*{def $sections=fetch( 'content', 'section_list' )*}
{def $sections=$object.allowed_assign_section_list
     $currentSectionName='unknown'}

{* get the name of the object's current section *}
{foreach $sections as $sectionItem }
    {if eq( $sectionItem.id, $object.section_id )}
        {set $currentSectionName=$sectionItem.name}
    {/if}
{/foreach}

<h2 class="context-title">Section: {$currentSectionName} [{count($sections)}]</h2>
{undef $currentSectionName}

{* DESIGN: Header END *}
</div></div></div></div></div></div>

{* DESIGN: Content START *}
<div class="box-bc"><div class="box-ml"><div class="box-mr"><div class="box-bl"><div class="box-br"><div class="box-content">

{* show the section selector *}
<div class="block">
    <label>{'Choose section'|i18n( 'design/admin/node/view/full' )}:</label>
    <select name="SelectedSectionId">
    {foreach $sections as $section}
        {if eq( $section.id, $object.section_id )}
        <option value="{$section.id}" selected="selected">{$section.name}</option>
        {else}
        <option value="{$section.id}">{$section.name}</option>
        {/if}
    {/foreach}
    </select>
</div>

<div class="block">
<input type="submit" value="{'Set'|i18n( 'design/admin/node/view/full' )}" name="SectionEditButton" class="button" />
</div>
</div></div></div></div></div></div>
{* DESIGN: Content END *}


