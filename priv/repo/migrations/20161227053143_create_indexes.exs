defmodule Exblur.Repo.Migrations.CreateIndexes do
  use Ecto.Migration

  def up do
    """
    ALTER TABLE ONLY divas ALTER COLUMN id SET DEFAULT nextval('divas_id_seq'::regclass);
    ALTER TABLE ONLY entries ALTER COLUMN id SET DEFAULT nextval('entries_id_seq'::regclass);
    ALTER TABLE ONLY entry_divas ALTER COLUMN id SET DEFAULT nextval('entry_divas_id_seq'::regclass);
    ALTER TABLE ONLY entry_tags ALTER COLUMN id SET DEFAULT nextval('entry_tags_id_seq'::regclass);
    ALTER TABLE ONLY sites ALTER COLUMN id SET DEFAULT nextval('sites_id_seq'::regclass);
    ALTER TABLE ONLY tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq'::regclass);
    ALTER TABLE ONLY thumbs ALTER COLUMN id SET DEFAULT nextval('thumbs_id_seq'::regclass);
    ALTER TABLE ONLY divas ADD CONSTRAINT divas_pkey PRIMARY KEY (id);
    ALTER TABLE ONLY entries ADD CONSTRAINT entries_pkey PRIMARY KEY (id);
    ALTER TABLE ONLY entry_divas ADD CONSTRAINT entry_divas_pkey PRIMARY KEY (id);
    ALTER TABLE ONLY entry_tags ADD CONSTRAINT entry_tags_pkey PRIMARY KEY (id);
    ALTER TABLE ONLY sites ADD CONSTRAINT sites_pkey PRIMARY KEY (id);
    ALTER TABLE ONLY tags ADD CONSTRAINT tags_pkey PRIMARY KEY (id);
    ALTER TABLE ONLY thumbs ADD CONSTRAINT thumbs_pkey PRIMARY KEY (id);
    CREATE INDEX divas_appeared_index ON divas USING btree (appeared);
    CREATE INDEX divas_birthday_index ON divas USING btree (birthday);
    CREATE INDEX divas_blood_index ON divas USING btree (blood);
    CREATE INDEX divas_bracup_index ON divas USING btree (bracup);
    CREATE INDEX divas_bust_index ON divas USING btree (bust);
    CREATE INDEX divas_gyou_index ON divas USING btree (gyou);
    CREATE INDEX divas_height_index ON divas USING btree (height);
    CREATE INDEX divas_hip_index ON divas USING btree (hip);
    CREATE INDEX divas_kana_index ON divas USING btree (kana);
    CREATE INDEX divas_name_index ON divas USING btree (name);
    CREATE INDEX divas_weight_index ON divas USING btree (weight);
    CREATE INDEX entries_publish_index ON entries USING btree (publish);
    CREATE INDEX entries_published_at_index ON entries USING btree (published_at);
    CREATE INDEX entries_removal_index ON entries USING btree (removal);
    CREATE INDEX entries_review_index ON entries USING btree (review);
    CREATE INDEX entries_site_id_index ON entries USING btree (site_id);
    CREATE INDEX entries_time_index ON entries USING btree ("time");
    CREATE INDEX entries_title_index ON entries USING btree (title);
    CREATE INDEX entries_sort_index ON entries USING btree (sort);
    CREATE UNIQUE INDEX entries_url_index ON entries USING btree (url);
    CREATE INDEX entry_divas_diva_id_index ON entry_divas USING btree (diva_id);
    CREATE UNIQUE INDEX entry_divas_entry_id_diva_id_index ON entry_divas USING btree (entry_id, diva_id);
    CREATE INDEX entry_divas_entry_id_index ON entry_divas USING btree (entry_id);
    CREATE INDEX entry_tags_entry_id_index ON entry_tags USING btree (entry_id);
    CREATE UNIQUE INDEX entry_tags_entry_id_tag_id_index ON entry_tags USING btree (entry_id, tag_id);
    CREATE INDEX entry_tags_tag_id_index ON entry_tags USING btree (tag_id);
    CREATE INDEX sites_last_modified_index ON sites USING btree (last_modified);
    CREATE INDEX sites_name_index ON sites USING btree (name);
    CREATE UNIQUE INDEX sites_rss_index ON sites USING btree (rss);
    CREATE INDEX tags_gyou_index ON tags USING btree (gyou);
    CREATE INDEX tags_name_index ON tags USING btree (name);
    CREATE INDEX thumbs_entry_id_index ON thumbs USING btree (entry_id);
    CREATE INDEX thumbs_image_index ON thumbs USING btree (image);
    ALTER TABLE ONLY entries ADD CONSTRAINT entries_site_id_fkey FOREIGN KEY (site_id) REFERENCES sites(id);
    ALTER TABLE ONLY entry_divas ADD CONSTRAINT entry_divas_diva_id_fkey FOREIGN KEY (diva_id) REFERENCES divas(id) ON DELETE CASCADE;
    ALTER TABLE ONLY entry_divas ADD CONSTRAINT entry_divas_entry_id_fkey FOREIGN KEY (entry_id) REFERENCES entries(id) ON DELETE CASCADE;
    ALTER TABLE ONLY entry_tags ADD CONSTRAINT entry_tags_entry_id_fkey FOREIGN KEY (entry_id) REFERENCES entries(id) ON DELETE CASCADE;
    ALTER TABLE ONLY entry_tags ADD CONSTRAINT entry_tags_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE;
    ALTER TABLE ONLY thumbs ADD CONSTRAINT thumbs_entry_id_fkey FOREIGN KEY (entry_id) REFERENCES entries(id);
    """
    |> Exblur.SQL.split
    |> Enum.each(&execute/1)

  end

  def down do
  end
end
