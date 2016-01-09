defmodule Exblur.Repo.Migrations.CreateDiva do
  use Ecto.Migration

  def change do
    create table(:divas) do
      add :name,       :string
      add :kana,       :string
      add :romaji,     :string
      add :gyou,       :string

      add :height,     :integer
      add :weight,     :integer

      add :bust,       :integer
      add :bracup,     :string
      add :waste,      :integer
      add :hip,        :integer

      add :blood,      :string
      add :birthday,   :date

      add :image,      :string

      add :created_at, :datetime, null: false
      add :updated_at, :datetime, null: false
    end

    create index(:divas, [:name])
    create index(:divas, [:gyou])
    create index(:divas, [:bust])
    create index(:divas, [:bracup])
    create index(:divas, [:blood])
    create index(:divas, [:weight])
    create index(:divas, [:birthday])
  end
end
