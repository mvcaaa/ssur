#!/usr/bin/env php
<?php

$link = mysql_connect( '195.230.90.50','devel','ljgjkybntkmysq38') or die('Could not connect to mysql server.' );
mysql_set_charset('utf8',$link);
mysql_select_db('russ', $link) or die('Could not select database.');

echo "working\r\n";
$selectSQL = "SELECT id,data_text FROM ezcontentobject_attribute WHERE `data_text` LIKE '%encoding=\"koi8-r%'";
$result = mysql_query($selectSQL);
echo "Will update".mysql_affected_rows()."\r\n";
while ($row = mysql_fetch_array($result, MYSQL_ASSOC)) {
	$updateSQL = "UPDATE ezcontentobject_attribute SET data_text='".str_replace("koi8-r","UTF-8", $row['data_text'])."' WHERE id = '".$row['id']."'";
	mysql_query($updateSQL);
	echo ".";
}

?>
