#?ini charset="iso-8859-1"?
# eZ publish configuration file for cronjobs.
#
#

[CronjobSettings]
Scripts[]
#Scripts[]=ljimport.php
Scripts[]=unpublish.php
Scripts[]=subtreeexpirycleanup.php
Scripts[]=internal_drafts_cleanup.php 
Scripts[]=updateviewcount.php
#Scripts[]=hide.php
#Scripts[]=subtreeexpirycleanup.php
#Scripts[]=linkcheck.php
#Scripts[]=rssimport.php

# Example of a cronjob part
# This one will only run the workflow cronjob script
#
[CronjobPart-basket]
Scripts[]=basket_cleanup.php
Scripts[]=internal_drafts_cleanup.php

[CronjobPart-updatecount]
Scripts[]=updateviewcount.php
