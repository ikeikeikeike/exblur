defmodule Plug.Exblur.Upload do

  require Logger

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
    case HTTPoison.get(filename, [connect_timeout: 30]) do
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
