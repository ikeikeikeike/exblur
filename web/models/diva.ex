defmodule Exblur.Diva do
  use Exblur.Web, :model

  alias Exblur.Diva, as: Model
  alias Imitation.Q

  schema "divas" do
    field :name,       :string
    field :kana,       :string
    field :romaji,     :string
    field :gyou,       :string

    field :height,     :integer
    field :weight,     :integer

    field :bust,       :integer
    field :bracup,     :string
    field :waste,      :integer
    field :hip,        :integer

    field :blood,      :string
    field :birthday,   Ecto.Date

    field :image,      :string

    field :created_at, Ecto.DateTime, default: Ecto.DateTime.utc
    field :updated_at, Ecto.DateTime, default: Ecto.DateTime.utc

    has_many :entry_divas, Exblur.EntryDiva
    has_many :entries, through: [:entry_divas, :entry]
  end

  @required_fields ~w(name kana romaji gyou image)
  @optional_fields ~w(height weight bust bracup waste hip blood birthday)

  def query do
    from e in Model, select: e
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def changeset_actress(model, actress) do
    params =
      actress
      |> Map.put("romaji", actress["oto"])
      |> Map.put("kana",   actress["yomi"])
      |> Map.put("image",  actress["thumb"])
      |> Enum.filter(&(elem(&1, 0) in @required_fields))
      |> Enum.into(%{})
      # for {key, val} <- actress, into: %{}, do: {String.to_atom(key), val}

    changeset(model, params)
  end

  def find_or_create_by_name(name) do
    query = from v in Model, where: v.name == ^name
    Q.find_or_create(query, changeset(%Model{}, %{name: name}))
  end

  def diva_creater(actress) do
    query = from v in Model, where: v.name == ^actress["name"]
    Q.find_or_create(query, changeset_actress(%Model{}, actress))
  end

end
