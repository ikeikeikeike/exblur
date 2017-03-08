defmodule Exblur.Plug.Upload do

  require Logger

  @config Application.get_env(:exblur, :http_headers)

  def detect_icon(url) do
    try do
      detect_icon! url
    rescue
      e in CaseClauseError ->
        nil
    end
  end

  def detect_icon!(url) do
    icon = Exfavicon.find(url)
    if Exfavicon.valid_favicon_url?(icon), do: make_plug!(icon), else: nil
  end

  def make_plug!(filename) do
    basename = Path.basename URI.parse(filename).path

    resp = recursive_request!(filename)

    path = "/tmp/#{basename}"
    File.write!(path, resp.body)

    %Plug.Upload{path: path, filename: basename}
  end

  defp recursive_request!(filename, retry \\ 10) do
    headers = [{"User-Agent", @config[:user_agent]}, {"connect_timeout", 30}]
    opts    = [ssl: [{:versions, [:'tlsv1.2']}]]

    case HTTPoison.get(filename, headers, opts) do
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

end