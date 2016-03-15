defmodule Es.Document do
  defmacro __using__(_opts) do
    quote do
      def put_document(model, index \\ get_index)
      def put_document(model, index) when is_list(model) do
        Tirexs.Bulk.store [index: index, refresh: true], Tirexs.ElasticSearch.config() do
          Enum.map model, &index(search_data(&1))
        end
      end
      def put_document(model, index) do
        Tirexs.Bulk.store [index: index, refresh: true], Tirexs.ElasticSearch.config() do
          index search_data(model)
        end
      end

    end
  end
end
