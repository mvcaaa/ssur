


















CREATE TABLE ezurlalias_ml_migrate (
    "action" text NOT NULL,
    action_type character varying(32) DEFAULT ''::character varying NOT NULL,
    alias_redirects integer DEFAULT 1 NOT NULL,
    extra_data text,
    id integer DEFAULT 0 NOT NULL,
    is_alias integer DEFAULT 0 NOT NULL,
    is_original integer DEFAULT 0 NOT NULL,
    is_restored integer DEFAULT 0 NOT NULL,
    lang_mask_adjusted integer DEFAULT 0 NOT NULL,
    lang_mask integer DEFAULT 0 NOT NULL,
    link integer DEFAULT 0 NOT NULL,
    parent integer DEFAULT 0 NOT NULL,
    text text NOT NULL,
    text_md5 character varying(32) DEFAULT ''::character varying NOT NULL
);







CREATE INDEX ezurlalias_ml_migrate_act_org ON ezurlalias_ml_migrate USING btree ("action", is_original);







CREATE INDEX ezurlalias_ml_migrate_action ON ezurlalias_ml_migrate USING btree ("action", id, link);







CREATE INDEX ezurlalias_ml_migrate_actt ON ezurlalias_ml_migrate USING btree (action_type);







CREATE INDEX ezurlalias_ml_migrate_actt_org_al ON ezurlalias_ml_migrate USING btree (action_type, is_original, is_alias);







CREATE INDEX ezurlalias_ml_migrate_id ON ezurlalias_ml_migrate USING btree (id);







CREATE INDEX ezurlalias_ml_migrate_par_act_id_lnk ON ezurlalias_ml_migrate USING btree (parent, "action", id, link);







CREATE INDEX ezurlalias_ml_migrate_par_lnk_txt ON ezurlalias_ml_migrate USING btree (parent, link, text);







CREATE INDEX ezurlalias_ml_migrate_par_txt ON ezurlalias_ml_migrate USING btree (parent, text);







CREATE INDEX ezurlalias_ml_migrate_text ON ezurlalias_ml_migrate USING btree (text, id, link);







CREATE INDEX ezurlalias_ml_migrate_text_lang ON ezurlalias_ml_migrate USING btree (text, lang_mask, parent);








ALTER TABLE ONLY ezurlalias_ml_migrate
    ADD CONSTRAINT ezurlalias_ml_migrate_pkey PRIMARY KEY (parent, text_md5);








