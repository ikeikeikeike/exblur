defmodule Exblur.EntryTag do
  use Exblur.Web, :model

  alias Exblur.EntryTag
  alias Imitation.Q

  schema "entry_tags" do
    belongs_to :entry, Exblur.Entry
    belongs_to :tag,   Exblur.Tag

    timestamps([{:inserted_at, :created_at}])
  end

  @required_fields ~w(entry_id tag_id)
  @optional_fields ~w()

  def changeset(model, params \\  %{}) do
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
      from v in EntryTag,
      where: v.tag_id == ^tag.id
         and v.entry_id == ^entry.id

    Q.find_or_create(query, changeset(%EntryTag{}, entry, tag))
  end


end
