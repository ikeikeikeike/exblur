defmodule Exblur.Repo.Migrations.CreateEntryTag do
  use Ecto.Migration

  def change do
    create table(:entry_tags) do
      add :entry_id, references(:entries, on_delete: :delete_all)
      add :tag_id,   references(:tags, on_delete: :delete_all)

      add :created_at,     :datetime, null: false
      add :updated_at,     :datetime, null: false
    end

    create index(:entry_tags,  [:entry_id])
    create index(:entry_tags,  [:tag_id])
    create index(:entry_tags,  [:entry_id, :tag_id], unique: true)
  end
end
