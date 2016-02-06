defmodule Es.Index do
  defmacro __using__(_opts) do
    quote do
      def reindex do
        settings = Tirexs.ElasticSearch.config()
        index = get_index

        # create new index if es doesn't have that.
        #
        if !get_aliases(index) do
            newidx = make_index(index)

            create_index(newidx)

            (aliases do
              add index: newidx, alias: index
            end)
            |> ppquery
            |> Tirexs.Manage.aliases(settings)
        end

        old_index = get_aliases(index)
        new_index = make_index(index)

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

      defp make_index(index) do
        suffix =
          Timex.Date.now
          |> Timex.DateFormat.format!("%Y%m%d%H%M%S%f", :strftime)

        "#{index}_#{suffix}"
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
  end
end
