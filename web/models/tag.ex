defmodule Exblur.Tag do
  use Exblur.Web, :model

  alias Exblur.Tag, as: Model
  alias Imitation.Query

  schema "tags" do
    field :name, :string
    field :kana, :string

    field :created_at, Ecto.DateTime, default: Ecto.DateTime.utc
    field :updated_at, Ecto.DateTime, default: Ecto.DateTime.utc

    has_many :video_entry_tags, Exblur.VideoEntryTag
    has_many :video_entries, through: [:video_entry_tags, :video_entry]
  end

  @required_fields ~w(name kana)
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def find_or_create_by_name(name) do
    query = from v in Model, where: v.name == ^name
    Query.find_or_create(query, changeset(%Model{}, %{name: name}))
  end

end
