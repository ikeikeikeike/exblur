defmodule Es.Diva do
  # need to agent. 
  #
  import Tirexs.Bulk, only: [create: 1, bulk: 3, store: 3]
  import Tirexs.Mapping, only: [mappings: 1, indexes: 1]
  import Tirexs.Index.Settings, only: [settings: 1, analysis: 1, filter: 2, tokenizer: 2, analyzer: 2]

  # import Imitation.Converter, only: [to_i: 1]

  require Tirexs.Query
  require Tirexs.Search
  require Logger
  require Es

  @type_name  "diva"
  @index_name "exblur_divas"

  def put_document(models) when is_list(models), do: Es.put_docs(models)
  def put_document(model), do: Es.put_doc(model)

  def search_data(model) do
    [
      # id: model.id,
      name: model.name,
      kana: model.kana,
      romaji: String.replace(model.romaji, "_", ""),
    ]
  end

  def search(word, options \\ []) do
    _ = options
    queries = Tirexs.Search.search [index: @index_name, from: 0, size: 5] do
      query do
        dis_max do
          queries do
            multi_match word, ["name"],   analyzer: "exblur_autocomplete_search"
            multi_match word, ["kana"],   analyzer: "exblur_autocomplete_search"
            multi_match word, ["romaji"], analyzer: "exblur_autocomplete_search"
          end
        end
      end
    end

    Logger.debug "#{inspect queries}"
    Logger.debug "#{JSX.prettify! JSX.encode!(queries)}"
    Tirexs.Query.create_resource(queries)
  end

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
        indexes "name",   type: "string", analyzer: "exblur_text_start_index", index: "not_analyzed"
        indexes "kana",   type: "string", analyzer: "exblur_text_start_index", index: "not_analyzed"
        indexes "romaji", type: "string", analyzer: "exblur_text_start_index", index: "not_analyzed"
      end

      {index, es_settings}
    end

  end
end
