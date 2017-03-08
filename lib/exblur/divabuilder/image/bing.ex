defmodule Exblur.Divabuilder.Image.Bing do
  require Logger

  alias Exblur.Divabuilder.Client
  alias Plug.Exblur.Upload

  @config Application.get_env(:exblur, :bing_image)

  def search(name) do
    query = fn q ->
      String.replace(@config[:query], "[[[query]]]", q)
    end

    case Client.get(query.(name), [{"User-agent", @config[:user_agent]}], [hackney: [basic_auth: @config[:basic_auth]]]) do
      {:error, _} ->
        []
      {:ok, resp} ->
        case Poison.decode(resp.body) do
          {:ok, map} ->
            map["d"]["results"]
          {:error, _} ->
            []
        end
    end
  end

  def make_plug!(name) when is_bitstring(name), do: make_plug!(nil, search(name))
  def make_plug!(plug, []), do: plug
  def make_plug!(nil, [result|tail]) do
    try do
      make_plug!(Upload.make_plug!(result["MediaUrl"]), [])
    catch
      _ -> make_plug!(nil, tail)
    end
  end

end
