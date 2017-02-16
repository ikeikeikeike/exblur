defmodule Exblur.LayoutView do
  use Exblur.Web, :view
  import Exblur.WebView
  import Exblur.Checks, only: [blank?: 1]

  def page_title(conn, assigns) do
    try do
      apply(view_module(conn), :page_title, [action_name(conn), assigns])
    rescue
      UndefinedFunctionError -> default_page_title(conn, assigns)
    end
  end

  def page_description(conn, assigns) do
    try do
      apply(view_module(conn), :page_description, [action_name(conn), assigns])
    rescue
      UndefinedFunctionError -> default_page_description(conn, assigns)
    end
  end

  def page_keywords(conn, assigns) do
    try do
      apply(view_module(conn), :page_keywords, [action_name(conn), assigns])
    rescue
      UndefinedFunctionError -> default_page_title(conn, assigns)
    end
  end

  def page_author(conn, assigns) do
    try do
      apply(view_module(conn), :page_author, [action_name(conn), assigns])
    rescue
      UndefinedFunctionError -> default_page_author(conn, assigns)
    end
  end

  def default_page_title(_conn, _assigns),       do: gettext "Default Page Title"
  def default_page_author(_conn, _assigns),      do: gettext "Default Page Author"
  def default_page_keywords(_conn, _assigns),    do: gettext "Default,Page,Keywords"
  def default_page_description(_conn, _assigns), do: gettext "Default Page Description"

  @doc """
  Provides tuples for all alternative languages supported.
  """
  def language_annotations(conn) do
    Exblur.Gettext.supported_locales
    |> Enum.concat(["x-default"])
    |> Enum.map(fn
      "x-default" -> {"x-default", localized_url(conn, nil)}
      lang        -> {lang, localized_url(conn, lang)}
    end)
  end

  def fb_locales do
    Exblur.Gettext.supported_locales
    |> Enum.map(fn lang ->
      # Cannot call `locale/0` inside guard clause
      current = locale()
      case lang do
        lang when lang == current ->
          {"og:locale", lang}
        lang ->
          {"og:locale:alternate", lang}
      end
    end)
  end

  def localized_url(conn, alt) do
    host   = Phoenix.Router.Helpers.url(Exblur.Router, conn)
    path   = conn.request_path
    params =
      if blank?(alt) do
        Map.delete(conn.params, "hl")
        |> URI.encode_query
      else
        Map.merge(conn.params, %{"hl" => alt})
        |> URI.encode_query
      end

    URI.parse(host <> path <> "?" <> params)
    |> to_string
  end

end

