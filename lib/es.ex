defmodule Es do

  require Logger

  def ppquery(queries) do
    Logger.debug "#{inspect queries}"
    Logger.debug "#{JSX.prettify! JSX.encode!(queries)}"
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

end
