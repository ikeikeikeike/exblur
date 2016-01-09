defmodule Divabuilder.Api do
  alias Divabuilder.Client

  @endpoint "http://apiactress.appspot.com/api/1/getdata/"

  @kunrei_romaji ~w{
    a i u e o
    ka ki ku ke ko
    sa si su se so
    ta ti tu te to
    na ni nu ne no
    ha hi hu he ho
    ma mi mu me mo
    ya yu yo
    ra ri ru re ro
    wa wo nn vu
  }

  def getdata do
    Enum.map @kunrei_romaji, fn prefix ->
      %{prefix => getdata(prefix)}
    end
  end

  def getdata(prefixes) when is_list(prefixes) do
    Enum.map prefixes, fn prefix ->
      %{prefix => getdata(prefix)}
    end
  end

  def getdata(prefix) do
    case Client.get process_url(prefix) do
      {:ok, response} ->
        Poison.decode response.body
      {:error, reason} ->
        {:error, reason}
    end
  end

  defp process_url(url) do
    @endpoint <> url
  end

end
