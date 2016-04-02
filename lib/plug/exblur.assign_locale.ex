defmodule Plug.Exblur.AssignLocale do
  def init(opts), do: opts

  def call(conn, _opts) do
    if locale = conn.params["locale"] do
      conn = Plug.Conn.put_session(conn, :locale, locale)
    end

    session_lang = Plug.Conn.get_session(conn, :locale)
    eccept_lang = List.first(extract_accept_language(conn))

    lang_tag =
      cond do
        session_lang -> session_lang
        eccept_lang  -> eccept_lang
      end

    locale = Exblur.Gettext.find_locale(lang_tag) || Exblur.Gettext.default_locale
    Plug.Conn.assign(conn, :locale, locale)
  end

  # Adapted from http://code.parent.co/practical-i18n-with-phoenix-and-elixir/
  defp extract_accept_language(conn) do
    case conn |> Plug.Conn.get_req_header("accept-language") do
      [value|_] ->
        value
        |> String.replace(" ", "")
        |> String.split(",")
        |> Enum.map(&parse_language_option/1)
        |> Enum.sort(&(&1.quality >= &2.quality))
        |> Enum.map(&(&1.tag))
      _ ->
        []
    end
  end

  defp parse_language_option(string) do
    captures = ~r/^(?<tag>[\w\-]+)(?:;q=(?<quality>[\d\.]+))?$/i
    |> Regex.named_captures(string)

    quality = case Float.parse(captures["quality"] || "1.0") do
      {val, _} -> val
      _ -> 1.0
    end

    %{tag: captures["tag"], quality: quality}
  end
end
