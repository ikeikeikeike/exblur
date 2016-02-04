defmodule Es.Diva do
  # need to agent.

  use Es

  @type_name  "diva"
  @index_name "exblur_divas"

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

    ppquery(queries)
    |> Tirexs.Query.create_resource
  end

  def reindex do
    settings = Tirexs.ElasticSearch.config()

    # create new index if es doesn't have that.
    #
    if !get_aliases(@index_name) do
        create_index("#{@index_name}_#{timestamp}")

        (aliases do
          add index: "#{@index_name}_#{timestamp}", alias: @index_name
        end)
        |> ppquery
        |> Tirexs.Manage.aliases(settings)
    end

    old_index = get_aliases(@index_name)
    new_index = "#{@index_name}_#{timestamp}"

    # create new index
    #
    create_index(new_index)

    #
    # Send data to es
    #
    Exblur.Diva
    |> Exblur.Repo.all
    |> put_document(new_index)

    # change alias
    #
    (aliases do
      remove index: old_index, alias: @index_name
      add    index: new_index, alias: @index_name
    end)
    |> ppquery
    |> Tirexs.Manage.aliases(settings)

    Tirexs.ElasticSearch.delete("#{old_index}", settings)

    :ok
  end

  def create_index(index_name \\ @index_name) do
    Tirexs.DSL.define [type: @type_name, index: index_name, number_of_shards: "5", number_of_replicas: "1"], fn(index, es_settings) ->
      settings do
        analysis do
          tokenizer "ngram_tokenizer", type: "nGram",  min_gram: "2", max_gram: "3", token_chars: ["letter", "digit"]
          analyzer  "ngram_analyzer",  tokenizer: "ngram_tokenizer"
        end
      end

      {index, es_settings}
    end

    Tirexs.DSL.define [type: @type_name, index: index_name], fn(index, es_settings) ->
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

  defp timestamp do
    Timex.Date.now
    |> Timex.DateFormat.format!("%Y%m%d%H%M%S%f", :strftime)
  end

  defp get_aliases(index_name) do
    {:ok, 200, map} = Tirexs.ElasticSearch.get("#{index_name <> "*"}/_aliases/", Tirexs.ElasticSearch.config())

    alias =
      map
      |> Dict.keys
      |> List.first
      |> to_string

    if alias != "", do: alias, else: nil
  end

end
