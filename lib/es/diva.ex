defmodule Es.Diva do
  # need to agent.
  use Es

  es :model, Exblur.Diva

  def search_data(model) do
    [
      # id: model.id,
      name: model.name,
      kana: model.kana,
      romaji: String.replace(model.romaji, "_", ""),
    ]
  end

  def search(word) do
    queries = Tirexs.Search.search [index: getindex, from: 0, size: 5] do
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

    ppquery(queries)
    |> Tirexs.Query.create_resource
  end

  def create_index(index \\ getindex) do
    Tirexs.DSL.define [index: index, number_of_shards: "5", number_of_replicas: "1"], fn(index, es_settings) ->
      settings do
        analysis do
          tokenizer "ngram_tokenizer", type: "nGram",  min_gram: "2", max_gram: "3", token_chars: ["letter", "digit"]
          analyzer  "ngram_analyzer",  tokenizer: "ngram_tokenizer"
        end
      end

      {index, es_settings}
    end

    Tirexs.DSL.define [index: index], fn(index, es_settings) ->
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

    :ok
  end

end
