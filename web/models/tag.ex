defmodule Exblur.Tag do
  use Exblur.Web, :model
  alias Exblur.Tag

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

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
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

  def find_or_create_by_name(name) do
    query = from v in Tag, where: v.name == ^name
    find_or_create(query, changeset(%Tag{}, %{name: name}))
  end

end
