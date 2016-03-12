defmodule Exblur.EntryView do
  use Exblur.Web, :view
  import Exblur.WebView
  import Scrivener.HTML

  def title_with_link(conn, entry) do
    title = entry.title

    names = Enum.map entry.divas, fn(diva) ->
      if String.starts_with?(entry.title, diva.name) do
        title = String.replace(title, diva.name, "")
      end

      link diva.name, to: "#"
      # link diva.name, to: entry_path(conn, :search_diva, diva.name)
      # h.link_to(diva.name, h.search_diva_path(diva.name), 'data-no-turbolink' => 1)
    end

    Enum.join(names, "") <> title
  end

  def search_url_normalization(conn) do
    conn.params["search"] || ""
    |> String.replace("　", " ")
  end

  def search_words(conn) do
    conn
    |> search_url_normalization
    |> String.split
  end

  def tags_exists(conn, name) do
    cond do
      conn.params["search"] ->
        name in search_words(conn)

      conn.params["tag"] ->
        conn.params["tag"] == name

      true -> false
    end
  end

end
