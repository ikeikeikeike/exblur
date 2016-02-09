defmodule Exblur.Repo.Migrations.CreateVideoEntryTag do
  use Ecto.Migration

  def change do
    create table(:video_entry_tags) do
      add :video_entry_id, references(:video_entries, on_delete: :nothing)
      add :tag_id,         references(:tags, on_delete: :nothing)

      add :created_at,     :datetime, null: false
      add :updated_at,     :datetime, null: false
    end

    create index(:video_entry_tags,  [:video_entry_id])
    create index(:video_entry_tags,  [:tag_id])
    create index(:video_entry_tags,  [:video_entry_id, :tag_id], unique: true)
  end
end
