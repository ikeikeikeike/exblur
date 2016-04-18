defmodule Exblur.EntryView do
  use Exblur.Web, :view
  import Exblur.WebView
  import Scrivener.HTML

  def page_title(:index, assigns) do
    params = assigns.conn.params
    title =
      cond do
        ! Blank.blank? params["tag"]    -> gettext "%{word} showing %{num} results", word: params["tag"], num: number_with_delimiter(assigns.entries.total_entries)
        ! Blank.blank? params["diva"]   -> gettext "%{word} showing %{num} results", word: params["diva"], num: number_with_delimiter(assigns.entries.total_entries)
        ! Blank.blank? params["search"] -> gettext "%{word} Found %{num} results", word: params["search"], num: number_with_delimiter(assigns.entries.total_entries)
        true               -> nil
      end

    (if title, do: title <> " - ", else: "") <> gettext("Default Page Title")
  end
  def page_title(:show, assigns), do: truncate(assigns[:entry].title, length: 100) <> " - " <> gettext("Default Page Title")
  def page_title(_, _),           do: gettext "Default Page Title"

  def page_keywords(:index, assigns) do
    params = assigns.conn.params
    keywords =
      cond do
        ! Blank.blank? params["tag"]    -> gettext ",%{word}", word: params["tag"]
        ! Blank.blank? params["diva"]   -> gettext ",%{word}", word: params["diva"]
        ! Blank.blank? params["search"] -> gettext ",%{word}", word: params["search"]
        true             -> ""
      end

    gettext("Default,Page,Keywords") <> keywords
  end
  def page_keywords(:show, assigns), do: gettext("Default,Page,Keywords") <> "," <> Enum.join(Enum.map(assigns[:entry].tags, fn(tag) -> tag.name end), ",")
  def page_keywords(_, _),           do: gettext "Default,Page,Keywords"

  def page_description(:index, assigns) do
    params = assigns.conn.params
    cond do
      ! Blank.blank? params["tag"]    -> gettext "You would search '%{word}' in XXX. Let's see the video in XXX !!", word: params["tag"]
      ! Blank.blank? params["diva"]   -> gettext "You would search '%{word}' in XXX. Let's see the video in XXX !!", word: params["diva"]
      ! Blank.blank? params["search"] -> gettext "You would search '%{word}' in XXX. Let's see the video in XXX !!", word: params["search"]
      true             -> gettext "Default Page Description"
    end
  end
  def page_description(:show, assigns) do
    after_description =
      assigns[:entries].entries
      |> Enum.reverse
      |> Enum.map(fn entry -> entry.title end)
      |> Enum.join(", ")

    Enum.join([
      gettext("Content Explain"),
      truncate(after_description, length: 100)
    ], ": ")
  end
  def page_description(_, _),           do: gettext "Default Page Description"

  def title_with_link(conn, entry) do
    case length entry.divas do
      x when x > 0 ->
        title =
          entry.divas
          |> Enum.flat_map(fn(diva) ->
            Entrybuilder.Filter.separate_name(diva.name)
          end)
          |> Enum.reduce(entry.title, fn(name, title) ->
            atag =
              link(name, to: entrydiva_path(conn, :index, name))
              |> elem(1)
              |> List.to_string

            String.replace(title, name, " " <> atag <> " ")
          end)

        raw title

      _ ->
        entry.title
    end


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

      conn.params["diva"] ->
        conn.params["diva"] == name

      true -> false
    end
  end

end
