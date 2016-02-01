defmodule Es do

  require Logger

  defmacro __using__(_opts) do
    quote do
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

  defmacro __before_compile__(_env) do
    quote do
      def index_name do
        @index_name
      end

      def put_document(model) when is_list(model) do
        Tirexs.Bulk.store [index: @index_name, refresh: true], Tirexs.ElasticSearch.config() do
          Enum.map model, &create(search_data(&1))
        end
      end

      def put_document(model) do
        Tirexs.Bulk.store [index: @index_name, refresh: true], Tirexs.ElasticSearch.config() do
          create search_data(model)
        end
      end

      def ppquery(queries) do
        Logger.debug "#{inspect queries}"
        Logger.debug "#{JSX.prettify! JSX.encode!(queries)}"
        queries
      end
    end
  end

end
