defmodule Es do

  require Logger

  defmacro __using__(_opts) do
    quote do
      Module.register_attribute(__MODULE__, :ess, accumulate: true)

      @before_compile Es

      import Tirexs.Bulk, only: [create: 1, bulk: 3, store: 3]
      import Tirexs.Mapping, only: [mappings: 1, indexes: 1]
      import Tirexs.Index.Settings, only: [settings: 1, analysis: 1, filter: 2, tokenizer: 2, analyzer: 2]
      import Tirexs.Manage.Aliases, only: [aliases: 1, add: 1, remove: 1]
      import Es

      # import Imitation.Converter, only: [to_i: 1]

      require Tirexs.Manage
      require Tirexs.Query
      require Tirexs.Search
      require Logger
    end
  end

  def ppquery(queries) do
    Logger.debug "#{inspect queries}"
    Logger.debug "#{JSX.prettify! JSX.encode!(queries)}"
    queries
  end

  defmacro es(name, options \\ []) do
    quote do
      @ess {unquote(name), unquote(options)}
    end
  end

  defmacro __before_compile__(env) do
    ess = Module.get_attribute(env.module, :ess)

    quote do
      def ess, do: unquote(ess)

      def getindex, do: unquote(index_name(env))

      def put_document(model, index \\ ess[:index])

      def put_document(model, index) when is_list(model) do
        Tirexs.Bulk.store [index: index, refresh: true], Tirexs.ElasticSearch.config() do
          Enum.map model, &create(search_data(&1))
        end
      end

      def put_document(model, index) do
        Tirexs.Bulk.store [index: index, refresh: true], Tirexs.ElasticSearch.config() do
          create search_data(model)
        end
      end

      def reindex do
        settings = Tirexs.ElasticSearch.config()
        index = getindex

        # create new index if es doesn't have that.
        #
        if ! unquote(get_aliases(index_name(env))) do
            create_index("#{index}_#{unquote(suffix)}")

            (aliases do
              add index: "#{index}_#{unquote(suffix)}", alias: index
            end)
            |> ppquery
            |> Tirexs.Manage.aliases(settings)
        end

        old_index = unquote(get_aliases(index_name(env)))
        new_index = "#{index}_#{unquote(suffix)}"

        # create new index
        #
        create_index(new_index)

        #
        # Send data to es
        #
        ess[:model]
        |> Exblur.Repo.all
        |> put_document(new_index)

        # change alias
        #
        (aliases do
          remove index: old_index, alias: index
          add    index: new_index, alias: index
        end)
        |> ppquery
        |> Tirexs.Manage.aliases(settings)

        Tirexs.ElasticSearch.delete("#{old_index}", settings)

        :ok
      end

    end
  end

  defp index_name(env) do
    ess = Module.get_attribute(env.module, :ess)

    index =
      ess[:model]
      |> to_string
      |> String.split(".")
      |> List.last
      |> String.downcase

    "es_#{index}"
  end

  defp suffix do
    Timex.Date.now
    |> Timex.DateFormat.format!("%Y%m%d%H%M%S%f", :strftime)
  end

  defp get_aliases(index) do
    settings = Tirexs.ElasticSearch.config()
    {:ok, 200, map} = Tirexs.ElasticSearch.get("#{index <> "*"}/_aliases/", settings)

    alias =
      map
      |> Dict.keys
      |> List.first
      |> to_string

    if alias != "", do: alias, else: nil
  end

end
