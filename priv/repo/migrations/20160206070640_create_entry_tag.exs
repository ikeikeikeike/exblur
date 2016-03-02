defmodule Exblur.Repo.Migrations.CreateEntryTag do
  use Ecto.Migration

  def change do
    create table(:entry_tags) do
      add :entry_id, references(:entries, on_delete: :nothing)
      add :tag_id,         references(:tags, on_delete: :nothing)

      add :created_at,     :datetime, null: false
      add :updated_at,     :datetime, null: false
    end

    create index(:entry_tags,  [:entry_id])
    create index(:entry_tags,  [:tag_id])
    create index(:entry_tags,  [:entry_id, :tag_id], unique: true)
  end
end
