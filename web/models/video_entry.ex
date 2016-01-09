defmodule Exblur.VideoEntry do
  use Exblur.Web, :model
  alias Exblur.VideoEntry

  require Logger

  schema "video_entries" do
    field :url,             :string
    field :title,           :string
    field :content,         :string
    field :embed_code,      :string
    field :time,            :integer
    field :published_at,    Ecto.DateTime
    field :review,          :boolean, default: false
    field :publish,         :boolean, default: false
    field :removal,         :boolean, default: false

    field :created_at,      Ecto.DateTime, default: Ecto.DateTime.utc
    field :updated_at,      Ecto.DateTime, default: Ecto.DateTime.utc

    has_many :video_entry_divas, Exblur.VideoEntryDiva
    has_many :divas, through: [:video_entry_divas, :divas]

    belongs_to :site, Exblur.Site
    belongs_to :server, Exblur.Server
  end

  def with_diva(query) do
          from  video      in query,
     left_join: video_diva in assoc(video, :video_entry_divas),
          join: diva       in assoc(video_diva, :diva),
       preload: [divas: diva]
  end

  @required_fields ~w(url title embed_code time published_at review publish removal)
  @optional_fields ~w(content site_id server_id)

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
      |> Map.put(:published_at, Ecto.DateTime.utc)

    changeset(model, params) 
  end

  def find_or_create_by_entry(entry) do
    query = from v in VideoEntry, 
          where: v.url == ^entry.url

    model = Repo.one(query)
    case model do
      nil ->
        cset = 
          %VideoEntry{} 
          |> changeset_by_entry(entry)

        case Repo.insert(cset) do  
          {:ok, model} -> {:new, model}
          {:error, cset} -> {:error, cset}
        end
      _ ->
        {:ok, model}
    end
  end

  def video_creater(entry) do
    case find_or_create_by_entry(entry) do
      {:error, cset} ->
        {:error, cset}
      {:ok, video_entry} ->
        {:ok, video_entry}
      {:new, video_entry} ->

        case Exblur.Site.video_creator_by_name(entry.name) do
          {:error, cset} ->
            {:error, cset}
          {_, site} ->

            case Repo.update(changeset(video_entry, %{site_id: site.id})) do
              {:error, reason} ->
                {:error, reason}
              {_, video_entry} ->
                {:new, video_entry}
            end
        end
    end
  end

end
