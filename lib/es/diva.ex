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

  def search(word) do
    queries = Tirexs.Search.search [index: @index_name, from: 0, size: 5] do
      query do
        dis_max do
          queries do
            multi_match word, ["name"]
            prefix "name", word
            multi_match word, ["kana"]
            prefix "kana", word
            multi_match word, ["romaji"]
            prefix "romaji", word
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
          tokenizer "ngram_tokenizer", type: "nGram",  min_gram: "2", max_gram: "3", token_chars: ["letter", "digit"]
          analyzer  "ngram_analyzer",  tokenizer: "ngram_tokenizer"
        end
      end

      {index, es_settings}
    end

    Tirexs.DSL.define [type: @type_name, index: @index_name], fn(index, es_settings) ->
      mappings do
        indexes "name",   [type: "string", fields: [raw:      [type: "string", index: "not_analyzed"],
                                                    tokenzed: [type: "string", index: "analyzed",     analyzer: "ngram_analyzer"]]]
        indexes "kana",   [type: "string", fields: [raw:      [type: "string", index: "not_analyzed"],
                                                    tokenzed: [type: "string", index: "analyzed",     analyzer: "ngram_analyzer"]]]
        indexes "romaji", [type: "string", fields: [raw:      [type: "string", index: "not_analyzed"],
                                                    tokenzed: [type: "string", index: "analyzed",     analyzer: "ngram_analyzer"]]]
      end

      {index, es_settings}
    end

  end
end
