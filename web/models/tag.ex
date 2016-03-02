defmodule Exblur.Tag do
  use Exblur.Web, :model

  alias Exblur.Tag, as: Model
  alias Imitation.Q

  schema "tags" do
    field :name,   :string
    field :kana,   :string
    field :romaji, :string
    field :gyou,   :string
    field :orig,   :string

    field :created_at, Ecto.DateTime, default: Ecto.DateTime.utc
    field :updated_at, Ecto.DateTime, default: Ecto.DateTime.utc

    has_many :entry_tags, Exblur.EntryTag
    has_many :entries, through: [:entry_tags, :entry]
  end

  @required_fields ~w(name)
  @optional_fields ~w(kana romaji gyou orig)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def find_or_create_by_name(name) do
    query = from v in Model, where: v.name == ^name
    Q.find_or_create(query, changeset(%Model{}, %{name: name}))
  end

end
