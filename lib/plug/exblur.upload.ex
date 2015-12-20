defmodule Plug.Exblur.Upload do

  require Logger

  def make_plug_upload!(url) do
    filename = Exfavicon.find url 
    basename = Path.basename URI.parse(filename).path

    resp = recursive_request!(filename)

    path = "/tmp/#{basename}"
    File.write!(path, resp.body)

    %Plug.Upload{path: path, filename: basename}
  end

  defp recursive_request!(filename, retry \\ 5) do
    case HTTPoison.get(filename, [connect_timeout: 30]) do
      {:error, reason} ->
        Logger.warn "#{inspect reason}"
        if retry < 1, do: throw(reason)
        recursive_request!(filename, retry - 1)
      {_, resp} ->
        resp
    end
  end

end
