defmodule Exblur.LayoutView do
  use Exblur.Web, :view
  import Exblur.WebView

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
    |> Enum.map(fn l ->
      case l do
        "x-default" -> {"x-default", localized_url(conn, "")}
        l -> {l, localized_url(conn, l)}
      end
    end)
  end

  def fb_locales do
    Exblur.Gettext.supported_locales
    |> Enum.map(fn l ->
      # Cannot call `locale/0` inside guard clause
      current = locale()
      case l do
        l when l == current -> {"og:locale", l}
        l -> {"og:locale:alternate", l}
      end
    end)
  end

  defp localized_url(conn, alt) do
    host = Phoenix.Router.Helpers.url(Exblur.Router, conn)
    path =
      ~r/\/#{locale}(\/(?:[^?]+)?|$)/
      |> Regex.replace(conn.request_path, "#{alt}\\1")

    if String.starts_with?(path, alt) do
      URI.parse(host <> path)
    else
      params =
        Map.merge(conn.params, %{"hl" => alt})
        |> URI.encode_query
      URI.parse(host <> path <> "?" <> params)
    end
    |> to_string
  end

end

