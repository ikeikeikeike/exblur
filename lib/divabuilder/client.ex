defmodule Divabuilder.Client do
  use HTTPoison.Base

  # @endpoint "http://apiactress.appspot.com/api/1/getdata/"

  # defp process_url(url) do
    # @endpoint <> url
  # end

  defp process_request_headers(headers) do
    Keyword.put(headers, :follow_redirect, true)
  end

end
