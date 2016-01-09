defmodule Divabuilder do
  @doc """
  Fetches diva infomations
  """
  defdelegate getdata,         to: Divabuilder.Api, as: :getdata
  defdelegate getdata(prefix), to: Divabuilder.Api, as: :getdata
end
