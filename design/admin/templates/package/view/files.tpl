{* DO NOT EDIT THIS FILE! Use an override template instead. *}
{let package=fetch( package,item,
                    hash( package_name, $package_name,
                          repository_id, $repository_id  ) )}

<div id="package" class="viewfiles">
    <div id="pn-{$package.name|wash}" class="pt-{$package.type|wash}">

    <form method="post" action={concat( 'package/view/files/', $package.name )|ezurl}>



{* DESIGN: Header START *}<div class="box-header"><div class="box-tc"><div class="box-ml"><div class="box-mr"><div class="box-tl"><div class="box-tr">
<h1 class="context-title">
        {$package.name|wash}-{$package.version-number}-{$package.release-number}{section show=$package.release-timestamp}({$package.release-timestamp|l10n( shortdatetime )}){/section}{section show=$package.type|wash} [{$package.type}]{/section}
        - {section show=$package.install_type|eq( 'install' )}
            {section show=$package.is_installed}
                {'Installed'|i18n('design/admin/package')}
            {section-else}
                {'Not installed'|i18n('design/admin/package')}
            {/section}
        {section-else}
            {'Imported'|i18n('design/admin/package')}
        {/section}
</h1>

{* DESIGN: Mainline *}<div class="header-mainline"></div>

{* DESIGN: Header END *}</div></div></div></div></div></div>

{* DESIGN: Content START *}<div class="box-ml"><div class="box-mr"><div class="box-content">

<div class="context-attributes">

    <div class="object">
        <div class="summary">
            <label>{'Summary'|i18n('design/admin/package')}</label>
            <p>{$package.summary|wash}</p>
        </div>
    </div>

    {section var=collection loop=$package.file-list}
    <div class="objectheader">
        <h2>{'Files [%collectionname]'|i18n('design/admin/package',, hash( '%collectionname', $collection.key ))}</h2>
    </div>
    <div class="object">
        <div class="files">
        {section var=file loop=$collection}
        <p>
            <a href={concat( $package|ezpackage( fileitempath, $file ) )|ezroot}> {section show=$file.subdirectory}{$file.subdirectory|wash}/{/section}{$file.name|wash}</a>
            {section show=$file.variable-name}[{$file.variable-name|wash}]{/section}
            {section show=$file.md5}MD5: <em>{$file.md5|wash}</em>{/section}
        </p>
        {/section}
        </div>
    </div>
    {/section}

    <div class="links">
        <p>[ <a href={concat( "package/view/full/", $package.name )|ezurl}>{'Details'|i18n('design/admin/package')}</a> ]</p>
    </div>
    </div>

    {* DESIGN: Content END *}</div></div></div>
    <div class="controlbar">
    {* DESIGN: Control bar START *}<div class="box-bc"><div class="box-ml"><div class="box-mr"><div class="box-tc"><div class="box-bl"><div class="box-br">

    {section show=$package.can_export}
    <div class="block">
        {section show=$package.install_type|eq( 'install' )}
            {section show=$package.is_installed}
                <input class="button" type="submit" name="UninstallButton" value="{'Uninstall'|i18n( 'design/admin/package')}" />
            {section-else}
                <input class="button" type="submit" name="InstallButton" value="{'Install'|i18n( 'design/admin/package')}" />
            {/section}
        {/section}
        <input class="button" type="submit" name="ExportButton" value="{'Export to file'|i18n( 'design/admin/package')}" />
    </div>
    {/section}

    </div>
    {* DESIGN: Control bar END *}</div></div></div></div></div></div>


    </form>

    </div>
</div>

{/let}
