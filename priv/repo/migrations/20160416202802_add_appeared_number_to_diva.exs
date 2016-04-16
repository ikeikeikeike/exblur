defmodule Exblur.Repo.Migrations.AddAppearedNumberToDiva do
  use Ecto.Migration

  def change do
    alter table(:divas) do
      add :appeared, :integer, default: 0
    end

    create index(:divas, [:kana])
    create index(:divas, [:height])
    create index(:divas, [:hip])
    create index(:divas, [:appeared])
  end
end
