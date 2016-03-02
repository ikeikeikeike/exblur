defmodule Exblur.Repo.Migrations.CreateEntryDiva do
  use Ecto.Migration

  def change do
    create table(:entry_divas) do
      add :entry_id, references(:entries, on_delete: :nothing)
      add :diva_id,        references(:divas, on_delete: :nothing)

      add :created_at,     :datetime, null: false
      add :updated_at,     :datetime, null: false
    end

    create index(:entry_divas, [:entry_id])
    create index(:entry_divas, [:diva_id])
    create index(:entry_divas, [:entry_id, :diva_id], unique: true)
  end
end
