defmodule Es do

  require Logger

  defmacro __using__(_opts) do
    quote do
      import Tirexs.Bulk, only: [create: 1, bulk: 3, store: 3]
      import Tirexs.Mapping, only: [mappings: 1, indexes: 1]
      import Tirexs.Index.Settings, only: [settings: 1, analysis: 1, filter: 2, tokenizer: 2, analyzer: 2]
      import Tirexs.Manage.Aliases, only: [aliases: 1, add: 1, remove: 1]
      import Es

      require Tirexs.Manage
      require Tirexs.Query
      require Tirexs.Search
      require Logger
    end
  end

  defmacro put_doc(model) do
    quote do
      Tirexs.Bulk.store [index: @index_name, refresh: true], Tirexs.ElasticSearch.config() do
        create search_data(unquote(model))
      end
    end
  end

  defmacro put_docs(models) do
    quote do
      Tirexs.Bulk.store [index: @index_name, refresh: true], Tirexs.ElasticSearch.config() do
        Enum.map unquote(models), &create(search_data(&1))
      end
    end
  end

  def ppquery(queries) do
    Logger.debug "#{inspect queries}"
    Logger.debug "#{JSX.prettify! JSX.encode!(queries)}"
    queries
  end

end
