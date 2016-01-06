defmodule Es.Exblur.VideoEntry do
  # need to agent.
 
  import Tirexs.Bulk
  import Tirexs.Query
  import Tirexs.Search
  import Tirexs.Mapping
  import Tirexs.Index.Settings

  require Tirexs.ElasticSearch

  require Logger

  @index_name "exblur_video_entreis"

  def put_document(models) when is_list(models) do
    Tirexs.Bulk.store [index: @index_name, refresh: true], Tirexs.ElasticSearch.config() do
      Enum.each models, &create(search_data(&1))
    end
  end

  def put_document(model) do
    Tirexs.Bulk.store [index: @index_name, refresh: true], Tirexs.ElasticSearch.config() do
      create search_data(model)
    end
  end

  #### for develop #####
  def put_document(model, tags, divas) do
    Tirexs.Bulk.store [index: @index_name, refresh: true], Tirexs.ElasticSearch.config() do
      create search_data(model, tags, divas)
    end
  end

  def search_data(model, tags, divas) do
    search_data(model) ++ [
      tags: tags,
      divas: divas
    ]
  end
  #########

  def search_data(model) do
    [
      # id: model.id,
      url: model.url,
      time: model.time,
      title: model.title,
      content: model.content,

      # tags: model.tag_list,
      # divas: Enum.map(model.divas, &(&1.name)),

      review: model.review,
      publish: model.publish,
      removal: model.removal,

      published_at: model.published_at,

      site_name: (if model.site_id, do: model.site.name, else: ""),
      server_title: (if model.server_id, do: model.server.title, else: ""),
      server_domain: (if model.server_id, do: model.server.domain, else: "")
    ]
  end

  def do_search(word \\ nil, options \\ []) do

    fields = [:title, :content, :tags, :divas]

    # pagination
    page = max(options[:page] |> to_i, 1)
    per_page = (options[:limit] || options[:per_page] || 10000)
    offset = options[:offset] || (page - 1) * per_page

    # queries = search [index: @index_name, from: 0, size: 10, fields: [:tag, :article], explain: 5, version: true, min_score: 0.5] do
    queries = search [index: @index_name, fields: fields, from: offset, size: per_page] do

      query do
        match_all
      end

      # query do
        # term "title", ""
      # end

      filter do
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

      facets do
        # tags [global: true] do
          # terms field: "tags"
        # end

        tags do
          terms field: "tags", size: 180
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
          [published_at: "desc"]
        ]
      end
    end

    search = queries[:search]

    if word do
      search = Keyword.delete(search, :query)
      search = search ++ query do
        multi_match word, fields, cutoff_frequency: 0.001, boost: 10, use_dis_max: false, operator: "and"
      end

      queries = Keyword.put queries, :search, search
    end

    Logger.debug "#{inspect queries}"
    Logger.debug "#{JSX.prettify! JSX.encode!(queries)}"
    Tirexs.Query.create_resource(queries)
  end

  # settings = Tirexs.ElasticSearch.config()
  # Tirexs.ElasticSearch.delete("exblur_video_entreis", settings)

  def create_index do

    Tirexs.DSL.define [type: "dsl", index: @index_name], fn(index, es_settings) ->
      settings do
        analysis do
          filter    "ja_posfilter",     type: "kuromoji_part_of_speech", stoptags: ["助詞-格助詞-一般", "助詞-終助詞"]

          tokenizer "ja_tokenizer",     type: "kuromoji_tokenizer"
          tokenizer "ngram_tokenizer",  type: "nGram",  min_gram: "2", max_gram: "3", token_chars: ["letter", "digit"]

          analyzer  "default",          type: "custom", tokenizer: "ja_tokenizer"
          analyzer  "ja_analyzer",      type: "custom", tokenizer: "ja_tokenizer", filter: ["kuromoji_baseform", "ja_posfilter", "cjk_width"]
          analyzer  "ngram_analyzer",                   tokenizer: "ngram_tokenizer"
        end
      end

      {index, es_settings}
    end

    Tirexs.DSL.define [type: "dsl", index: @index_name], fn(index, es_settings) ->
      mappings do
        # indexes "id",             type: "long",   index: "not_analyzed", include_in_all: false
        indexes "url",            type: "string", index: "not_analyzed"

        indexes "site_name",      type: "string", index: "not_analyzed"
        indexes "server_title",   type: "string", index: "not_analyzed"
        indexes "server_domain",  type: "string", index: "not_analyzed"

        indexes "tags",           type: "string", index: "not_analyzed"
        indexes "divas",          type: "string", index: "not_analyzed"

        indexes "title",          type: "string", analyzer: "ja_analyzer"
        indexes "content",        type: "string", analyzer: "ja_analyzer"

        indexes "time",           type: "long"
        indexes "published_at",   type: "date",   format: "dateOptionalTime"

        indexes "review",         type: "boolean"
        indexes "publish",        type: "boolean"
        indexes "removal",        type: "boolean"
      end

      {index, es_settings}
    end

  end

  defp to_i(num) when is_integer(num),  do: num
  defp to_i(num) when is_float(num),    do: round(num)
  defp to_i(num) when is_nil(num),      do: 0
  defp to_i(num) do
    case Integer.parse(num) do
      :error -> 0
      {n, _} -> n
    end
  end

end
