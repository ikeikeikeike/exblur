defmodule Exblur.Repo.Migrations.CreateTag do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :name,   :string
      add :kana,   :string
      add :romaji, :string
      add :orig,   :string
      add :gyou,   :string

      add :created_at, :datetime, null: false
      add :updated_at, :datetime, null: false
    end

    create index(:tags, [:name])
    create index(:tags, [:gyou])
  end
end
