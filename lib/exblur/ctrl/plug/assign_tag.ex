defmodule Exblur.Ctrl.Plug.AssignTag do
  import Plug.Conn

  alias Exblur.Entry

  def init(opts), do: opts
  def call(conn, _opts) do
    tags =
      ConCache.get_or_store :tag, "assign_tag:2000", fn ->
        Entry
        |> Exblur.ESx.search(Entry.tag_facets)
        |> Exblur.ESx.results
      end

    conn
    |> assign(:top_tags, tags)
  end
end
