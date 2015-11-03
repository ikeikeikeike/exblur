defmodule Exblur.Repo.Migrations.CreateServer do
  use Ecto.Migration

  def change do
    create table(:servers) do
      add :title, :string
      add :icon, :string
      add :domain, :string
      add :twitter_url, :string
      add :keywords, :string
      add :description, :text
      add :primary, :boolean, default: false

      add :created_at, :datetime, null: false
      add :updated_at, :datetime, null: false
    end

    create index(:servers, [:domain], unique: true)
    create index(:servers, [:primary])
    create index(:servers, [:title])

  end
end
