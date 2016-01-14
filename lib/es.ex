defmodule Es do

  defmacro put_document(models) when is_list(models) do
    quote do
      store [index: @index_name, refresh: true], Tirexs.ElasticSearch.config() do
        Enum.each unquote(models), &create(search_data(&1))
      end
    end
  end

  defmacro put_document(model) do
    quote do
      store [index: @index_name, refresh: true], Tirexs.ElasticSearch.config() do
        create search_data(unquote(model))
      end
    end
  end

end
