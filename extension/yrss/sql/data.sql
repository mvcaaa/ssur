CREATE TABLE `ezyrss_export` (
`access_url` varchar( 255 ) default NULL ,
`active` int( 11 ) default NULL ,
`created` int( 11 ) default NULL ,
`creator_id` int( 11 ) default NULL ,
`description` longtext,
`id` int( 11 ) NOT NULL AUTO_INCREMENT ,
`image_id` int( 11 ) default NULL ,
`main_node_only` int( 11 ) NOT NULL default '1',
`modified` int( 11 ) default NULL ,
`modifier_id` int( 11 ) default NULL ,
`number_of_objects` int( 11 ) NOT NULL default '0',
`rss_version` varchar( 255 ) default NULL ,
`site_access` varchar( 255 ) default NULL ,
`status` int( 11 ) NOT NULL default '0',
`title` varchar( 255 ) default NULL ,
`url` varchar( 255 ) default NULL ,
PRIMARY KEY ( `id` , `status` )
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

CREATE TABLE `ezyrss_export_item` (
`class_id` int( 11 ) default NULL ,
`description` varchar( 255 ) default NULL ,
`id` int( 11 ) NOT NULL AUTO_INCREMENT ,
`rssexport_id` int( 11 ) default NULL ,
`source_node_id` int( 11 ) default NULL ,
`status` int( 11 ) NOT NULL default '0',
`subnodes` int( 11 ) NOT NULL default '0',
`title` varchar( 255 ) default NULL ,
PRIMARY KEY ( `id` , `status` ) ,
KEY `ezrss_export_rsseid` ( `rssexport_id` )
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

ALTER TABLE `ezyrss_export_item` ADD `fulltext` VARCHAR( 255 ) NOT NULL ;
ALTER TABLE `ezyrss_export_item` CHANGE `fulltext` `fulltext` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NULL  
ALTER TABLE `ezyrss_export_item` CHANGE `fulltext` `yfulltext` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL  

ALTER TABLE `ezyrss_export_item` ADD `author` VARCHAR( 255 ) NOT NULL ;
ALTER TABLE `ezyrss_export_item` CHANGE `author` `author` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NULL  
