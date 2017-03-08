defmodule Exblur.Divabuilder.Image.Detector do
  import Mogrify
  require Logger

  defmodule HttpError do
    defexception message: "http error"
  end

  def urlinfo(url) when is_nil(url), do: {:ng, "no filename"}
  def urlinfo(url) when url == "",   do: {:ng, "no filename"}
  def urlinfo(url) do
    filename = "/tmp/#{Path.basename(URI.parse(url).path)}"
    unless File.exists?(filename), do: File.write!(filename, recursive_request!(url).body)

    info(filename)
  rescue
    x in HttpError -> {:ng, x}
    x in File.Error -> {:ng, x}
  end

  def info(filename) when is_nil(filename), do: {:ng, "no filename"}
  def info(filename) when filename == "",   do: {:ng, "no filename"}
  def info(filename) do
    magic =
      filename
      |> open
      |> verbose

    {:ok, magic}
  rescue
    x in MatchError -> {:ng, x}
    x in File.Error -> {:ng, x}
  end

  defp recursive_request!(filename, retry \\ 10) do
    case HTTPoison.get(filename, [connect_timeout: 30]) do
      {:error, reason} ->
        Logger.warn "#{inspect reason}"

        if retry < 1 do
          raise HttpError, message: reason
        end

        filename
        |> recursive_request!(retry - 1)

      {_, resp} -> resp
    end
  end

end
