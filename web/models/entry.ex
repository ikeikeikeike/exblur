defmodule Exblur.Entry do
  use Exblur.Web, :model
  alias Exblur.Entry, as: Model

  alias Exblur.EntryTag
  alias Exblur.EntryDiva
  alias Exblur.Diva
  alias Exblur.Site
  alias Exblur.Tag
  alias Exblur.Thumb

  require Logger

  schema "entries" do
    field :url, :string

    field :title, :string
    field :content, :string
    field :embed_code, :string

    field :time, :integer
    field :published_at, Ecto.DateTime

    field :review, :boolean, default: false
    field :publish, :boolean, default: false
    field :removal, :boolean, default: false

    field :created_at, Ecto.DateTime, default: Ecto.DateTime.utc
    field :updated_at, Ecto.DateTime, default: Ecto.DateTime.utc

    belongs_to :site, Site

    has_many :thumbs, Thumb, on_delete: :delete_all

    has_many :entry_divas, EntryDiva
    has_many :divas, through: [:entry_divas, :diva]

    has_many :entry_tags, EntryTag
    has_many :tags, through: [:entry_tags, :tag]
  end

  # def with_diva(query) do
          # from  video      in query,
     # left_join: video_diva in assoc(video, :entry_divas),
          # join: diva       in assoc(video_diva, :diva),
       # preload: [divas: diva]
  # end

  @required_fields ~w(url title embed_code time published_at review publish removal)
  @optional_fields ~w(content site_id)
  @relational_fields ~w(site divas tags thumbs)a

  def query do
    from e in Model,
     select: e,
    preload: ^@relational_fields
  end

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
    query = from v in Model,
          where: v.url == ^entry.url

    case model = Repo.one(query) do
      nil ->
        cset =
          %Model{}
          |> changeset_by_entry(entry)

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

  def video_creater(entry) do
    case find_or_create_by_entry(entry) do
      {:error, cset} ->
        Logger.error("#{inspect cset}")
        {:error, cset}

      {:ok, model} ->
        {:ok, model}

      {:new, model} ->
        result =
          case Site.video_creator_by_name(entry.name) do
            {:error, cset} ->
              Logger.error("#{inspect cset}")
              {:error, cset}

            {_, site} ->
              case Repo.update(changeset(model, %{site_id: site.id})) do
                {:error, reason} ->
                  Logger.error("#{inspect reason}")
                  {:error, reason}

                {_, model} ->
                  {:new, model}
              end
          end

        case result do
          {:new, model} ->

            # TODO: name to kana, romaji and more
            Enum.each entry.divas, fn(name) ->
              case Diva.find_or_create_by_name(name) do
                {:error, reason} ->
                  Logger.error("#{inspect reason}")

                {_, diva} ->
                  EntryDiva.find_or_create(model, diva)
              end
            end

            # TODO: name to kana
            Enum.each entry.tags, fn(name) ->
              case Tag.find_or_create_by_name(name) do
                {:error, reason} ->
                  Logger.error("#{inspect reason}")

                {_, tag} ->
                  EntryTag.find_or_create(model, tag)
              end
            end

            Enum.each entry.images, fn(scrapy) ->
              case Thumb.create_by_scrapy(model, scrapy) do
                {:error, reason} -> Logger.error("#{inspect reason}")
                _ -> :ok
              end
            end

          _ -> nil
        end

        result
    end
  end

end
