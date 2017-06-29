defmodule Exblur.Divabuilder.Image.Bing do
  require Logger

  alias Exblur.Divabuilder.Client
  alias Exblur.Plug.Upload

  @config Application.get_env(:exblur, :bing_image)

  def search(name) do
    query = fn q ->
      String.replace(@config[:query], "[[[query]]]", URI.encode(q))
    end
    headers = [
      "User-Agent": @config[:user_agent],
      "Ocp-Apim-Subscription-Key": @config[:authkey]
    ]

    case Client.get(query.(name), headers) do
      {:error, _} ->
        []
      {:ok, resp} ->
        case Poison.decode(resp.body) do
          {:ok, map} ->
            map["value"]
          {:error, _} ->
            []
        end
    end
  end

  def make_plug!(name) when is_bitstring(name), do: make_plug!(nil, search(name))
  def make_plug!(plug, []), do: plug
  def make_plug!(nil, [result|tail]) do
    try do
      make_plug!(Upload.make_plug!(result["contentUrl"]), [])
    catch
      _ -> make_plug!(nil, tail)
    end
  end

end
