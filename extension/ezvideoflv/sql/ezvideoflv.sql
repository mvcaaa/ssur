CREATE TABLE ezvideoflv (
  contentobject_attribute_id int(11) NOT NULL default '0',
  filename varchar(255) NOT NULL default '',
  flv varchar(255) NOT NULL default '',
  height int(11) default NULL,
  mime_type varchar(50) NOT NULL default '',
  original_filename varchar(255) NOT NULL default '',
  version int(11) NOT NULL default '0',
  width int(11) default NULL,
  PRIMARY KEY  (contentobject_attribute_id,version)
);

