defmodule Es.Diva do
  # need to agent.
 
  import Tirexs.Bulk
  # import Tirexs.Query
  # import Tirexs.Search
  import Tirexs.Mapping
  import Tirexs.Index.Settings

  # import Imitation.Converter, only: [to_i: 1]

  require Tirexs.ElasticSearch

  require Logger

  @type_name "diva"
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

  # def do_search(word \\ nil, options \\ []) do

    # # Logger.debug "#{inspect queries}"
    # # Logger.debug "#{JSX.prettify! JSX.encode!(queries)}"
    # # Tirexs.Query.create_resource(queries)
  # end

  # def reindex do
    # alias_name = @index_name
    # {:ok, suffix} = Timex.Date.now |> Timex.DateFormat.format("%Y%m%d%H%M%S%f", :strftime)

    # # old_index = list(c.indices.get_alias(alias_name).keys())[0]
    # new_index = alias_name <> "_" <> suffix
  # end

  def create_index do
    Tirexs.DSL.define [type: @type_name, index: @index_name, number_of_shards: "5", number_of_replicas: "1"], fn(index, es_settings) ->
      settings do
        analysis do
          filter    "exblur_index_shingle",       type: "shingle",   token_separator: ""
          filter    "exblur_edge_ngram",          type: "edgeNGram", min_gram: "1", max_gram: "50"
          filter    "exblur_stemmer",             type: "snowball",  language: "English"

          tokenizer "exblur_autocomplete_ngram",  type: "edgeNGram", min_gram: "1", max_gram: "50"

          analyzer  "exblur_autocomplete_index",  type: "custom",    filter: ["lowercase", "asciifolding"],                      tokenizer: "exblur_autocomplete_ngram"
          analyzer  "exblur_autocomplete_search", type: "custom",    filter: ["lowercase", "asciifolding"],                      tokenizer: "keyword"
          analyzer  "exblur_text_start_index",    type: "custom",    filter: ["lowercase", "asciifolding", "exblur_edge_ngram"], tokenizer: "keyword"
          analyzer  "default_index",              type: "custom",    filter: [
            "standard", "lowercase", "asciifolding", "exblur_index_shingle", "exblur_stemmer"], tokenizer: "standard"                
        end
      end

      {index, es_settings}
    end

    Tirexs.DSL.define [type: @type_name, index: @index_name, index_analyzer: "default_index"], fn(index, es_settings) ->
      mappings do
        indexes "name",   type: "string", analyzer: "exblur_text_start_index"   #  , index: "not_analyzed"
        indexes "kana",   type: "string", analyzer: "exblur_text_start_index"
        indexes "romaji", type: "string", analyzer: "exblur_text_start_index"
      end

      {index, es_settings}
    end

  end
end
