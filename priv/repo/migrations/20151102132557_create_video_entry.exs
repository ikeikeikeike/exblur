defmodule Exblur.Repo.Migrations.CreateVideoEntry do
  use Ecto.Migration

  def change do
    create table(:video_entries) do
      add :url, :text
      add :title, :string
      add :content, :text
      add :embed_code, :text
      add :time, :integer
      add :published_at, :datetime
      add :review, :boolean, default: false
      add :publish, :boolean, default: false
      add :removal, :boolean, default: false
      add :site_id, references(:sites)
      add :server_id, references(:servers)

      add :created_at, :datetime, null: false
      add :updated_at, :datetime, null: false
    end
    create index(:video_entries, [:site_id])
    create index(:video_entries, [:server_id])
    create index(:video_entries, [:publish])
    create index(:video_entries, [:published_at])
    create index(:video_entries, [:removal])
    create index(:video_entries, [:review])
    create index(:video_entries, [:url], unique: true)
  end
end
