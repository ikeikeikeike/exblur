defmodule Exblur.EntryDiva do
  use Exblur.Web, :model
  alias Exblur.EntryDiva, as: Model
  alias Exblur.Imitation.Q

  schema "entry_divas" do
    belongs_to :entry, Exblur.Entry
    belongs_to :diva,  Exblur.Diva

    timestamps([{:inserted_at, :created_at}])
  end

  @required_fields ~w(entry_id diva_id)a
  @optional_fields ~w(created_at updated_at)a

  def changeset(model, params \\  %{}) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def changeset(model, entry, diva) do
    params =
      %{entry_id: entry.id, diva_id: diva.id}

    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def find_or_create(entry, diva) do
    query =
      from v in Model,
      where: v.diva_id == ^diva.id
         and v.entry_id == ^entry.id

    Q.find_or_create(query, changeset(%Model{}, entry, diva))
  end

end
