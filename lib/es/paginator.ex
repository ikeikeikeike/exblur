defmodule Es.Paginator do
  use Es
  import Ecto.Query
  require Tirexs.Query

  defmodule Es.Paginator.Page do
    defstruct [:entries, :page_number, :page_size, :total_entries, :total_pages, :tirexs]
  end

  def paginate(response, options \\ []) do
    tirexs = Tirexs.Query.result(response)

    %Es.Paginator.Page{
      page_size: options[:page_size],
      page_number: options[:page],
      entries: entries(tirexs, options[:query]),
      total_entries: tirexs[:count],
      total_pages: total_pages(tirexs[:count], options[:page_size]),
      tirexs: tirexs,
    }
  end

  defp entries(tirexs, query) do
    Enum.map tirexs[:hits], fn(hit) ->
      query
      |> where([q], q.id == ^hit[:_id])
      |> Exblur.Repo.one
    end
  end

  defp total_pages(total_entries, page_size) do
    ceiling(total_entries / page_size)
  end

  defp ceiling(float) do
    t = trunc(float)

    case float - t do
      neg when neg < 0 ->
        t
      pos when pos > 0 ->
        t + 1
      _ -> t
    end
  end

end
