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

end
