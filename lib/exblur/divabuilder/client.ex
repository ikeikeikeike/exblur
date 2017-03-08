defmodule Exblur.Divabuilder.Client do
  use HTTPoison.Base

  # @endpoint "http://apiactress.appspot.com/api/1/getdata/"

  # defp process_url(url) do
    # @endpoint <> url
  # end

  defp process_request_headers(headers) do
    headers
    |> Keyword.put(:follow_redirect, true)
    |> Keyword.put(:timeout, 100000)
    |> Keyword.put(:recv_timeout, 100000)
    |> Keyword.put(:connect_timeout, 100000)
  end

end
