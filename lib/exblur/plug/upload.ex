defmodule Exblur.Plug.Upload do

  require Logger

  @config Application.get_env(:exblur, :http_headers)

  def detect_icon(url) do
    try do
      detect_icon! url
    rescue
      _e in CaseClauseError ->
        nil
    end
  end

  def detect_icon!(url) do
    icon = Exfavicon.find(url)
    if Exfavicon.valid_favicon_url?(icon), do: make_plug!(icon), else: nil
  end

  def make_plug!(filename) do
    resp = recursive_request!(filename)

    ctype = getheader(resp.headers, "Content-Type")
    basename = "#{randstr(10)}.#{getext(ctype)}"

    path = "/tmp/#{basename}"
    File.write!(path, resp.body)

    %Plug.Upload{content_type: ctype, path: path, filename: basename}
  end

  defp recursive_request!(filename, retry \\ 10) do
    headers = [{"User-Agent", @config[:user_agent]}, {"connect_timeout", 30}]
    case HTTPoison.get(filename, headers, [follow_redirect: true]) do
      {:error, reason} ->
        Logger.warn "#{inspect reason}"

        if retry < 1 do
          throw(reason)
        end

        filename
        |> recursive_request!(retry - 1)

      {_, resp} -> resp
    end
  end

  defp randstr(len) do
    len
    |> :crypto.strong_rand_bytes
    |> Base.url_encode64
    |> binary_part(0, len)
  end

  defp getheader(headers, key) do
    headers
    |> Enum.filter(fn({k, _}) -> k == key end)
    |> List.first
    |> elem(1)
  end

  defp getext(ctype) do
    ctype
    |> MIME.extensions
    |> List.first
  end
end
