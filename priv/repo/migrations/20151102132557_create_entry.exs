defmodule Exblur.Repo.Migrations.CreateEntry do
  use Ecto.Migration

  def change do
    create table(:entries) do
      add :url,          :text

      add :title,        :string
      add :content,      :text
      add :embed_code,   :text

      add :time,         :integer
      add :published_at, :datetime

      add :review,       :boolean, default: false
      add :publish,      :boolean, default: false
      add :removal,      :boolean, default: false

      add :site_id,      references(:sites)

      add :created_at,   :datetime, null: false
      add :updated_at,   :datetime, null: false
    end

    create index(:entries, [:site_id])
    create index(:entries, [:published_at])
    create index(:entries, [:publish])
    create index(:entries, [:removal])
    create index(:entries, [:review])
    create index(:entries, [:title])
    create index(:entries, [:time])
    create index(:entries, [:url], unique: true)
  end
end
