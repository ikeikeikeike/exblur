defmodule Exblur.Repo.Migrations.CreateThumb do
  use Ecto.Migration

  def change do
    create table(:thumbs) do
      add :entry_id, references(:entries, on_delete: :nothing)

      add :image, :string

      add :created_at, :datetime, null: false
    end

    create index(:thumbs, [:image])
    create index(:thumbs, [:entry_id])
  end
end
