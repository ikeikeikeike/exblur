defmodule Es.Params do
  import Imitation.Converter, only: [to_i: 1]

  def prepare_params(params, page \\ 1, per_page \\ 10) do
    params = Enum.reduce(params, %{}, fn {k, v}, map ->
      Map.put(map, String.to_atom(k), v)
    end)

    params =
      cond do
        params[:page] -> %{params | page: params[:page] |> to_i}
        true -> Map.put(params, :page, page)
      end

    params =
      cond do
        params[:page_size] -> params
        true -> Map.put(params, :page_size, per_page)
      end

    params
  end

  def prepare_options(options) do
    # pagination
    page = max(options[:page] |> to_i, 1)
    per_page = (options[:limit] || options[:per_page] || options[:page_size] || 10000)
    offset = options[:offset] || (page - 1) * per_page

    # filters
    filter = []
    if options[:ft], do: filter = Keyword.put(filter, :ft, options[:ft])

    [page: page, per_page: per_page, offset: offset, filter: filter]
  end
end
