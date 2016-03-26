defmodule Exblur.EntryView do
  use Exblur.Web, :view
  import Exblur.WebView
  import Scrivener.HTML

  def page_title(:index, assigns) do
    params = assigns.conn.params
    title =
      cond do
        params["tag"]      -> gettext "%{word} showing", word: params["tag"]
        params["search"]   -> gettext "%{word} search results", word: params["search"]
        true               -> ""
      end

    title <> " - " <> gettext("Default Page Title")
  end
  def page_title(:show, assigns), do: truncate(assigns[:entry].title, length: 100) <> " - " <> gettext("Default Page Title")
  def page_title(_, _),           do: gettext "Default Page Title"

  def page_keywords(:index, assigns) do
    params = assigns.conn.params
    keywords =
      cond do
        params["tag"]    -> gettext ",%{word}", word: params["tag"]
        params["search"] -> gettext ",%{word}", word: params["search"]
        true             -> ""
      end

    gettext("Default,Page,Keywords") <> keywords
  end
  def page_keywords(:show, assigns), do: gettext("Default,Page,Keywords") <> "," <> Enum.join(Enum.map(assigns[:entry].tags, fn(tag) -> tag.name end), ",")
  def page_keywords(_, _),           do: gettext "Default,Page,Keywords"

  def page_description(:index, assigns) do
    params = assigns.conn.params
    cond do
      params["tag"]    -> gettext "You would search '%{word}' in XXX. Let's see the video in XXX !!", word: params["tag"]
      params["search"] -> gettext "You would search '%{word}' in XXX. Let's see the video in XXX !!", word: params["search"]
      true             -> gettext "Default Page Description"
    end
  end
  def page_description(:show, assigns), do: truncate(assigns[:entry].content, length: 700)
  def page_description(_, _),           do: gettext "Default Page Description"

  def title_with_link(conn, entry) do
    title = entry.title

    names = Enum.map entry.divas, fn(diva) ->
      # if String.starts_with?(entry.title, diva.name) do
        # title = String.replace(title, diva.name, "")
      # end
      link diva.name, to: entrydiva_path(conn, :index, diva.name)
    end

    names ++ [" " <> title]
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
