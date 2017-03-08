defmodule Exblur.Entry do
  use Exblur.Web, :model

  use ESx.Schema

  alias Exblur.ESx
  alias Exblur.{Entry, EntryTag, EntryDiva, Diva, Site, Tag, Thumb}

  require Logger

  schema "entries" do
    field :url, :string

    field :title, :string
    field :content, :string
    field :embed_code, :string

    field :time, :integer
    field :published_at, Ecto.DateTime

    field :sort, :integer

    field :review, :boolean, default: false
    field :publish, :boolean, default: false
    field :removal, :boolean, default: false

    timestamps([{:inserted_at, :created_at}])

    belongs_to :site, Site

    has_many :thumbs, Thumb, on_delete: :delete_all

    has_many :entry_divas, EntryDiva
    has_many :divas, through: [:entry_divas, :diva]

    has_many :entry_tags, EntryTag
    has_many :tags, through: [:entry_tags, :tag]
  end

  @required_fields ~w(url title embed_code time review publish removal)
  @optional_fields ~w(content published_at site_id sort)
  @relational_fields ~w(site divas tags thumbs)a

  index_name "es_entry"
  document_type "entry"

  settings do
    analysis do
      filter    "ja_posfilter",
        type: "kuromoji_neologd_part_of_speech",
        stoptags: ["助詞-格助詞-一般", "助詞-終助詞"]
      filter    "edge_ngram",
        type: "edgeNGram",
        min_gram: 1, max_gram: 15

      tokenizer "ja_tokenizer",
        type: "kuromoji_neologd_tokenizer"
      tokenizer "ngram_tokenizer",
        type: "nGram",
        min_gram: "2", max_gram: "3",
        token_chars: ["letter", "digit"]

      # analyzer  "default",
      #   type: "custom",
      #   tokenizer: "ja_tokenizer",
      #   filter: ["kuromoji_neologd_baseform", "ja_posfilter", "cjk_width"]
      analyzer  "ja_analyzer",
        type: "custom",
        tokenizer: "ja_tokenizer",
        filter: ["kuromoji_neologd_baseform", "ja_posfilter", "cjk_width"]
      analyzer  "ngram_analyzer",
        tokenizer: "ngram_tokenizer"
    end
  end

  mapping _all: [enabled: false] do
    # indexes "id",             type: "long",   analyzer: "not_analyzed", include_in_all: false
    indexes "url",          type: "string", index: "not_analyzed"

    indexes "site_name",    type: "string", index: "not_analyzed"

    indexes "tags",         type: "string", index: "not_analyzed"
    indexes "divas",        type: "string", index: "not_analyzed"

    indexes "title",        type: "string", analyzer: "ja_analyzer"

    indexes "sort",         type: "long"
    indexes "time",         type: "long"
    indexes "published_at", type: "date",   format: "dateOptionalTime"

    indexes "review",       type: "boolean"
    indexes "publish",      type: "boolean"
    indexes "removal",      type: "boolean"
  end

  def as_indexed_json(model, _opts) do
    %{
      url: model.url,
      title: model.title,

      sort: model.sort,

      tags: Enum.map(model.tags, &(&1.name)),
      divas: Enum.map(model.divas, &(&1.name)),

      review: model.review,
      publish: model.publish,
      removal: model.removal,

      time: model.time,
      published_at: (case Timex.Ecto.DateTime.cast(model.published_at) do
        {:ok, at} -> Timex.format!(at, "{ISO:Extended}")
        _         -> model.published_at
      end),

      site_name: (if model.site_id, do: model.site.name, else: ""),
    }
  end

  def esreindex do
    from(e in __MODULE__, preload: [:site, :divas, :tags])
    |> published
    |> ESx.reindex
  end

  def search(params \\ %{}) do
    %{
      fields: [],
      query: %{
        filtered: %{
          query: (
            if q = params["search"] do
              %{multi_match: %{ query: q, fields: ~w(title tags divas)}}
            else
              %{match_all: %{}}
            end
          ),
          filter: %{
            bool: %{
              must: (
                [
                  %{term: %{review:  true}},
                  %{term: %{publish: true}},
                  %{term: %{removal: false}},
                  if(params["fs"], do: %{term: %{site_name: params["fs"]}}),
                  if(params["ft"], do: %{range: %{time: %{gte: params["ft"]}}}),
                ]
                |> Enum.filter(& !!&1)
              )
            }
          }
        }
      },
      aggs: %{
        tags: %{
          terms: %{field: "tags", size: 20},
        },
        divas: %{
          terms: %{field: "divas", size: 35},
        },
      },
      sort: (
        case params["st"] || params[:st] do
          "match" ->
            :_score
          "hot" ->
            %{sort: %{order: "asc"}}
          "asc" ->
            %{published_at: %{order: "asc"}}
          _ ->
            %{published_at: %{order: "desc"}}
        end
      ),
    }
  end

  def tag_facets(size \\ 2000) do
    %{
      size: 0,
      from: 0,
      fields: [],
      query: %{
        filtered: %{
          filter: %{
            bool: %{
              _cache: true,
              must: [
                %{term: %{"review":  true}},
                %{term: %{"publish": true}},
                %{term: %{"removal": false}},
              ]
            }
          },
        }
      },
      aggs: %{
        tags: %{
          terms: %{field: "tags", size: size},
        }
      }
    }
  end

  def diva_facets(size \\ 2000) do
    %{
      size: 0,
      from: 0,
      fields: [],
      query: %{
        filtered: %{
          filter: %{
            bool: %{
              _cache: true,
              must: [
                %{term: %{"review":  true}},
                %{term: %{"publish": true}},
                %{term: %{"removal": false}},
              ]
            }
          },
        }
      },
      aggs: %{
        divas: %{
          terms: %{field: "divas", size: size},
        }
      }
    }
  end

  def put_es_document(model) do
    model
    |> Repo.preload(@relational_fields)
    |> ESx.index_document
  end

  def delete_es_document(model) do
    model
    |> Repo.preload(@relational_fields)
    |> ESx.delete_document
  end

  def changeset(model, params \\  %{}) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def changeset_by_entry(model, entry) do
    params =
      entry
      |> Map.from_struct

    changeset(model, params)
  end

  def query do
    from e in __MODULE__,
     select: e,
    preload: ^@relational_fields
  end

  def relates(query) do
    from e in query,
    preload: ^@relational_fields
  end

  def latest(query, limit \\ 20) do
    from e in query,
    order_by: [desc: e.published_at],
       limit: ^limit
  end

  def released(query),             do: from p in query, where: p.publish == true
  def unreleased(query),           do: from p in query, where: p.publish == false
  def reviewed(query),             do: from p in query, where: p.review  == true
  def unreviewed(query),           do: from p in query, where: p.review  == false
  def removed(query),              do: from p in query, where: p.removal == true
  def unremoved(query),            do: from p in query, where: p.removal == false
  def more_than_10_minutes(query), do: from p in query, where: p.time    >= 600

  # return on publish record.
  #
  def published(query) do
    query
    |> released
    |> reviewed
    |> unremoved
  end

  # before release contents.
  #
  def reserved(query) do
    query
    |> unreleased
    |> reviewed
    |> unremoved
  end

  # default contents.
  #
  def initialized(query) do
    query
    |> unreleased
    |> unreviewed
    |> unremoved
  end

  def publish_entry(model) do
    params = %{
      review: true,
      publish: true,
      published_at: Ecto.DateTime.utc,
    }

    model
    |> changeset(params)
    |> Repo.update!
    |> put_es_document
  end

  def delete_entry(id, :physically) when is_integer(id) do
    model = Repo.get query(), id
    delete_entry model, :physically
  end
  def delete_entry(%__MODULE__{} = model, :physically) do
    Repo.delete model
    delete_es_document model
  end
  def delete_entry(id) when is_integer(id) do
    model = Repo.get query(), id
    delete_entry model
  end
  def delete_entry(%__MODULE__{} = model) do
    model
    |> changeset(%{removal: true})
    |> Repo.update!
    |> put_es_document
  end

  defp find_or_create_by_entry(entry) do
    query = from v in Entry,
          where: v.url == ^entry.url

    case model = Repo.one(query) do
      nil ->
        cset =
          %Entry{}
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
                  model
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

                {:new, diva} ->
                  Diva.put_es_document diva
                  EntryDiva.find_or_create(model, diva)

                {_, diva} ->
                  EntryDiva.find_or_create(model, diva)
              end
            end

            # TODO: name to kana
            Enum.each entry.tags, fn(name) ->
              case Tag.find_or_create_by_name(name) do
                {:error, reason} ->
                  Logger.error("#{inspect reason}")

                {:new, tag} ->
                  Tag.put_es_document tag
                  EntryTag.find_or_create(model, tag)

                {_, tag} ->
                  EntryTag.find_or_create(model, tag)
              end
            end

            # XXX: fixed taking limit now.
            Enum.each Enum.take(entry.images, 2), fn(scrapy) ->
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
