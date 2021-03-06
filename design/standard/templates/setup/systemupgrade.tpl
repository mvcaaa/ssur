{* DO NOT EDIT THIS FILE! Use an override template instead. *}
<form method="post" action={"/setup/systemupgrade/"|ezurl}>

<h1>{"System upgrade"|i18n("design/standard/setup")}</h1>

{section show=$md5_result}
  {section show=$md5_result|eq('ok')}
    <div class="feedback">
    {"File consistency check OK"|i18n("design/standard/setup")}
    </div>
  {section-else}
    <div class="feedback">
    {section show=$failure_reason}
    {$failure_reason}
    {section-else}
    {"Warning: it is not safe to upgrade without checking the modifications done to the following files "|i18n("design/standard/setup")}:<br />
    <p>
      {section loop=$md5_result}
        {$:item|wash}
        {delimiter}<br />{/delimiter}
      {/section}
    </p>
    {/section}
    </div>
  {/section}
{/section}

{section show=$upgrade_sql}
  {section show=$upgrade_sql|eq('ok')}
    <div class="feedback">
    {"Database check OK"|i18n("design/standard/setup")}
    </div>
  {section-else}
    <div class="feedback">
    {"Warning, your database is not consistent with the distribution database."|i18n("design/standard/setup")}<br />
    {"To revert your database to distribution setup, run the following SQL queries"|i18n("design/standard/setup")}:<br />
    <p>
      {$upgrade_sql|wash|break}
    </p>
    </div>
  {/section}
{/section}

<div class="buttonblock">
<p>{"Click a button to check file consistency."|i18n("design/standard/setup")}
  <input type="submit" name="MD5CheckButton" value="{"Check files"|i18n("design/standard/setup")}" />
  ( {"warning, this might take a while"|i18n("design/standard/setup")} )
</p>
</div>

<div class="buttonblock">
<p>{"Click a button to check database consistency."|i18n("design/standard/setup")}
  <input type="submit" name="DBCheckButton" value="{"Check database"|i18n("design/standard/setup")}" />
  ( {"warning, this might take a while"|i18n("design/standard/setup")} )
</p>
</div>

</form>
