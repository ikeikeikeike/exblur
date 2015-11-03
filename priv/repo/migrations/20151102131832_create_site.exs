defmodule Exblur.Repo.Migrations.CreateSite do
  use Ecto.Migration

  def change do
    create table(:sites) do
      add :name, :string
      add :url, :string
      add :rss, :string
      add :icon, :string
      add :last_modified, :datetime

      add :created_at, :datetime, null: false
      add :updated_at, :datetime, null: false
    end

    create index(:sites, [:last_modified])
    create index(:sites, [:rss], unique: true)

  end
end
