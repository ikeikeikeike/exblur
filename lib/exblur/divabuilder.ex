defmodule Exblur.Divabuilder do
  @doc """
  Fetches diva infomations
  """
  defdelegate getdata,         to: Exblur.Divabuilder.Api, as: :getdata
  defdelegate getdata(prefix), to: Exblur.Divabuilder.Api, as: :getdata
end
