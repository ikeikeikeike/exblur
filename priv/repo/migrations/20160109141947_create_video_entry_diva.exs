defmodule Exblur.Repo.Migrations.CreateVideoEntryDiva do
  use Ecto.Migration

  def change do
    create table(:video_entry_divas) do
      add :video_entry_id, references(:video_entries, on_delete: :nothing)
      add :diva_id,        references(:divas, on_delete: :nothing)

      add :created_at,     :datetime, null: false
      add :updated_at,     :datetime, null: false
    end

    create index(:video_entry_divas, [:video_entry_id])
    create index(:video_entry_divas, [:diva_id])
    create index(:video_entry_divas, [:video_entry_id, :diva_id], unique: true)
  end
end
