defmodule Exblur.Repo.Migrations.AddLikeAndBrokenIntoEntries do
  use Ecto.Migration

  def change do
    alter table(:entries) do
      add :likes, :integer, default: 0
      add :broken, :integer, default: 0
    end
  end
end
