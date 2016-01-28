defmodule Es.Diva do
  # need to agent.
  #
  import Tirexs.Bulk, only: [create: 1, bulk: 3, store: 3]
  import Tirexs.Mapping, only: [mappings: 1, indexes: 1]
  import Tirexs.Index.Settings, only: [settings: 1, analysis: 1, filter: 2, tokenizer: 2, analyzer: 2]
  import Tirexs.Manage.Aliases, only: [aliases: 1, add: 1, remove: 1]


  # import Imitation.Converter, only: [to_i: 1]

  require Tirexs.Manage
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

    Es.ppquery(queries)
    Tirexs.Query.create_resource(queries)
  end

  def reindex do
    settings = Tirexs.ElasticSearch.config()

    case Tirexs.ElasticSearch.get("#{@index_name}/_aliases/", settings) do
      {:ok, 200, %{}} ->
        queries = aliases do
          add index: @index_name, alias: "#{@index_name}_#{timestamp}"
        end

        Es.ppquery(queries)
        Tirexs.ElasticSearch.post("_aliases", JSX.encode!(queries), settings)
    end

    {:ok, 200, m} = Tirexs.ElasticSearch.get("#{@index_name}/_aliases/", settings)
    old_index = List.first(Map.keys(m[String.to_atom(@index_name)]))
    new_index = "#{@index_name}_#{timestamp}"

    #
    # create new index
    #

    #
    # dosomething
    #

    # queries = aliases do
      # add index: @index_name, alias: new_index
    # end
    # Es.ppquery(queries)
    # Tirexs.ElasticSearch.post("_aliases", JSX.encode!(queries), settings)

    queries = aliases do
      remove index: old_index, alias: @index_name
      add    index: new_index, alias: @index_name
    end
    Es.ppquery(queries)
    Tirexs.Manage.aliases(queries, settings)
    # Tirexs.ElasticSearch.post("_aliases", JSX.encode!(queries), Tirexs.ElasticSearch.config())
  end

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

  defp timestamp do
    Timex.Date.now
    |> Timex.DateFormat.format!("%Y%m%d%H%M%S%f", :strftime)
  end

end
