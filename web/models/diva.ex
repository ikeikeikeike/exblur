defmodule Exblur.Diva do
  use Exblur.Web, :model
  alias Exblur.Diva

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

    has_many :video_entry_divas, Exblur.VideoEntryDiva
    has_many :video_entries, through: [:video_entry_divas, :video_entries]
  end

  @required_fields ~w(name kana romaji gyou image)
  @optional_fields ~w(height weight bust bracup waste hip blood birthday)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
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

  def find_or_create(query, cset) do
    model = Repo.one(query)
    case model do
      nil ->
        case Repo.insert(cset) do
          {:ok, model} ->
            {:new, model}

          {:error, cset} ->
            {:error, cset}
        end
      _ ->
        {:ok, model}
    end
  end

  def diva_creater(actress) do
    query = from v in Diva, where: v.name == ^actress["name"]
    find_or_create(query, changeset_actress(%Diva{}, actress))
  end

end
