defmodule Exblur.VideoEntry do
  use Exblur.Web, :model
  alias Exblur.VideoEntry

  require Logger

  schema "video_entries" do
    field :url, :string
    field :title, :string
    field :content, :string
    field :embed_code, :string
    field :time, :integer
    field :published_at, Ecto.DateTime
    field :review, :boolean, default: false
    field :publish, :boolean, default: false
    field :removal, :boolean, default: false

    field :created_at, Ecto.DateTime, default: Ecto.DateTime.local
    field :updated_at, Ecto.DateTime, default: Ecto.DateTime.local

    belongs_to :site, Exblur.Site
    belongs_to :server, Exblur.Server
  end

  @required_fields ~w(url title content embed_code time published_at review publish removal)
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

  def changeset_by_entry(model, entry) do
    params = 
      entry 
      |> Map.from_struct
      |> Map.put(:published_at, Ecto.DateTime.local)

    changeset(model, params) 
  end

  def find_or_create_by_entry(entry) do
    query = from v in VideoEntry, 
          where: v.url == ^entry.url

    model = Repo.one(query)

    case model do
      nil ->
        changeset = 
          %VideoEntry{}
          |> changeset_by_entry(entry)

        case Repo.insert(changeset) do  
          {:ok, model} -> 
            {:new, model}
          {:error, changeset} -> 
            {:error, changeset}
        end
      _ ->
        {:ok, model}
    end
  end

  def video_creater(entry) do
    case find_or_create_by_entry(entry) do
      {:error, changeset} -> 
        {:error, changeset}
      {:ok, model} -> 
        {:ok, model}
      {:new, model} ->
        # model.site = Site.video_creator_by_name! entry.name
        {:new, model}
    end
  end

end
