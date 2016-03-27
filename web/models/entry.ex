defmodule Exblur.Entry do
  use Exblur.Web, :model

  use Es
  use Es.Index
  use Es.Document

  alias Exblur.Entry, as: Model

  alias Exblur.EntryTag
  alias Exblur.EntryDiva
  alias Exblur.Diva
  alias Exblur.Site
  alias Exblur.Tag
  alias Exblur.Thumb

  require Logger

  es :model, Model

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

  @required_fields ~w(url title embed_code time review publish removal)
  @optional_fields ~w(content published_at site_id)
  @relational_fields ~w(site divas tags thumbs)a

  # before_insert :set_published_at_to_now
  # def set_published_at_to_now(changeset) do
    # changeset
    # |> Ecto.Changeset.put_change(:published_at, Ecto.DateTime.utc)
  # end

  after_insert :put_es_document
  after_update :put_es_document
  def put_es_document(changeset) do
    changeset.model
    |> Repo.preload(@relational_fields)
    |> put_document

    changeset
  end

  after_delete :delete_es_document
  def delete_es_document(changeset) do
    changeset.model
    |> Repo.preload(@relational_fields)
    |> delete_document

    changeset
  end

  def changeset(model, params \\ :empty) do
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

  def released(query),             do: from p in query, where: p.publish == true
  def unreleased(query),           do: from p in query, where: p.publish == false
  def reviewed(query),             do: from p in query, where: p.review  == true
  def unreviewed(query),           do: from p in query, where: p.review  == false
  def removed(query),              do: from p in query, where: p.removal == true
  def unremoved(query),            do: from p in query, where: p.removal == false
  def more_than_10_minutes(query), do: from p in query, where: p.time    >= 600

  # return on publish record.
  #
  def published_entries do
    __MODULE__
    |> released
    |> reviewed
    |> unremoved
  end

  # before release contents.
  #
  def reserved_entries do
    __MODULE__
    |> unreleased
    |> reviewed
    |> unremoved
  end

  # default contents.
  #
  def initialized_entries do
    __MODULE__
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
    |> Repo.update
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

  def search_data(model) do
    published_at =
      case Timex.Ecto.DateTime.cast(model.published_at) do
        {:ok, at} ->
          Timex.DateFormat.format!(at, "{ISO}")
        _ -> model.published_at
      end

    [
      _id: model.id,
      url: model.url,
      time: model.time,
      title: model.title,
      # content: model.content,

      tags: Enum.map(model.tags, &(&1.name)),
      divas: Enum.map(model.divas, &(&1.name)),

      review: model.review,
      publish: model.publish,
      removal: model.removal,

      published_at: published_at,

      site_name: (if model.site_id, do: model.site.name, else: ""),
    ]
  end

  def search,               do: search(nil, [])
  def search(word),         do: search(word, [])
  def search(word, options) do
    opt = prepare_options(options)

    # pagination
    # page = opt[:page]
    offset = opt[:offset]
    per_page = opt[:per_page]

    # queries = search [index: @index_name, from: 0, size: 10, fields: [:tag, :article], explain: 5, version: true, min_score: 0.5] do
    queries = Tirexs.Search.search [index: get_index, fields: [], from: offset, size: per_page] do

      query do
        match_all
      end

      filter do
        _and [_cache: true] do
          filters do
            terms "review",  [true]
            terms "publish", [true]
            terms "removal", [false]
            range "time", [gte: 180]  # XXX: over the 3 minutes.
            # terms "site_name"
            # terms "divas"
          end
        end
      end

      facets do
        # tags [global: true] do
          # terms field: "tags"
        # end

        tags do
          terms field: "tags", size: 20
          facet_filter do
            _and [_cache: true] do
              filters do
                terms "review",  [true]
                terms "publish", [true]
                terms "removal", [false]
                # terms "server_domain" Server.shown_domain(request.host)
                # terms "site_name"
                # terms "divas"
              end
            end
          end
        end

        divas do
          terms field: "divas", size: 20
          facet_filter do
            _and [_cache: true] do
              filters do
                terms "review",  [true]
                terms "publish", [true]
                terms "removal", [false]
                # terms "server_domain" Server.shown_domain(request.host)
                # terms "site_name"
                # terms "divas"
              end
            end
          end
        end

      end

      sort do
        [
          [published_at: [order: "desc"]]
        ]
      end

      # TODO: highlight: word highlight
      # TODO: phrase suggester API: I'm not sure that you want like this right ?
      # TODO: completion suggester API: autocomplete
      # XXX: more like this: relational contents
    end

    if word do
      fields = [:title, :tags, :divas]  # , :content

      s = Keyword.delete(queries[:search], :query) ++ Tirexs.Query.query do
        multi_match word, fields # , cutoff_frequency: 0.001, boost: 10, use_dis_max: false, operator: "and"
      end

      queries = Keyword.put queries, :search, s
    end

    if opt[:filter][:ft] do
      f = Keyword.delete(queries[:search], :filter) ++ Tirexs.Query.Filter.filter do
        _and [_cache: true] do
          filters do
            terms "review",  [true]
            terms "publish", [true]
            terms "removal", [false]
            range "time", [gte: opt[:filter][:ft]]
          end
        end
      end

      queries = Keyword.put queries, :search, f
    end

    queries
    |> ppquery
    |> Tirexs.Query.create_resource
  end

  # settings = Tirexs.ElasticSearch.config()
  # Tirexs.ElasticSearch.delete("exblur_video_entreis", settings)

  def create_index(index \\ get_index) do
    Tirexs.DSL.define [type: "entry", index: index], fn(index, es_settings) ->
      settings do
        analysis do
          filter    "ja_posfilter",     type: "kuromoji_neologd_part_of_speech", stoptags: ["助詞-格助詞-一般", "助詞-終助詞"]

          tokenizer "ja_tokenizer",     type: "kuromoji_neologd_tokenizer"
          tokenizer "ngram_tokenizer",  type: "nGram",  min_gram: "2", max_gram: "3", token_chars: ["letter", "digit"]

          analyzer  "default",          type: "custom", tokenizer: "ja_tokenizer"
          analyzer  "ja_analyzer",      type: "custom", tokenizer: "ja_tokenizer", filter: ["kuromoji_neologd_baseform", "ja_posfilter", "cjk_width"]
          analyzer  "ngram_analyzer",                   tokenizer: "ngram_tokenizer"
        end
      end
      |> ppquery

      {index, es_settings}
    end

    Tirexs.DSL.define [type: "entry", index: index], fn(index, es_settings) ->
      mappings do
        # indexes "id",             type: "long",   index: "not_analyzed", include_in_all: false
        indexes "url",            type: "string", index: "not_analyzed"

        indexes "site_name",      type: "string", index: "not_analyzed"
        indexes "server_title",   type: "string", index: "not_analyzed"
        indexes "server_domain",  type: "string", index: "not_analyzed"

        indexes "tags",           type: "string", index: "not_analyzed"
        indexes "divas",          type: "string", index: "not_analyzed"

        indexes "title",          type: "string", analyzer: "ja_analyzer"
        # indexes "content",        type: "string", analyzer: "ja_analyzer"

        indexes "time",           type: "long"
        indexes "published_at",   type: "date",  format: "date_optional_time"

        indexes "review",         type: "boolean"
        indexes "publish",        type: "boolean"
        indexes "removal",        type: "boolean"
      end
      |> ppquery

      {index, es_settings}
    end
  end

end
