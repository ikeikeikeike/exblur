defmodule Es.Exblur.VideoEntry do
  import Tirexs.Bulk
  import Tirexs.Search
  import Tirexs.Mapping
  import Tirexs.Index.Settings

  require Tirexs.Query
  require Tirexs.ElasticSearch

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

  def search_data(model) do
    [
      # id: model.id,
      url: model.url,
      time: model.time,
      title: model.title,
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

  def search(params \\ []) do
    queries = search [index: @index_name] do
      query do
        string "title:" <> (if params[:title], do: params[:title], else: "*")
      end

      # filter do
        # terms "tags", ["elixir", "ruby"]
      # end

      # facets do
        # global_tags [global: true] do
          # terms field: "tags"
        # end

        # current_tags do
          # terms field: "tags"
        # end
      # end

      sort do
        [
          [title: "desc"]
        ]
      end
    end

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
end
