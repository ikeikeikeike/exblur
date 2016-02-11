defmodule Exblur.Repo.Migrations.CreateThumb do
  use Ecto.Migration

  def change do
    create table(:thumbs) do
      add :video_entry_id, references(:video_entries, on_delete: :nothing)

      add :image, :string

      add :created_at, :datetime, null: false
    end

    create index(:thumbs, [:video_entry_id])
  end
end
