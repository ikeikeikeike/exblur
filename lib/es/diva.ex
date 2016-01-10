defmodule Es.Diva do
  # need to agent.
 
  import Tirexs.Bulk
  import Tirexs.Query
  import Tirexs.Search
  import Tirexs.Mapping
  import Tirexs.Index.Settings

  import Imitation.Converter, only: [to_i: 1]

  require Tirexs.ElasticSearch

  require Logger

  @index_name "exblur_divas"

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
      name: model.name,
      kana: model.kana,
      romaji: model.romaji,
    ]
  end

  def do_search(word \\ nil, options \\ []) do

    # Logger.debug "#{inspect queries}"
    # Logger.debug "#{JSX.prettify! JSX.encode!(queries)}"
    # Tirexs.Query.create_resource(queries)
  end

  def reindex do
    alias_name = @index_name
    {:ok, suffix} = Timex.Date.now |> Timex.DateFormat.format("%Y%m%d%H%M%S%f", :strftime)

    # old_index = list(c.indices.get_alias(alias_name).keys())[0]
    new_index = alias_name <> "_" <> suffix
  end

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
