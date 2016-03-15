defmodule Exblur.EntryTag do
  use Exblur.Web, :model
  alias Exblur.EntryTag, as: Model
  alias Imitation.Q

  schema "entry_tags" do
    belongs_to :entry, Exblur.Entry
    belongs_to :tag,   Exblur.Tag

    field :created_at, Ecto.DateTime, default: Ecto.DateTime.utc
    field :updated_at, Ecto.DateTime, default: Ecto.DateTime.utc
  end

  @required_fields ~w(entry_id tag_id)
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def changeset(model, entry, tag) do
    params =
      %{entry_id: entry.id, tag_id: tag.id}

    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def find_or_create(entry, tag) do
    query =
      from v in Model,
      where: v.tag_id == ^tag.id
         and v.entry_id == ^entry.id

    Q.find_or_create(query, changeset(%Model{}, entry, tag))
  end


end
