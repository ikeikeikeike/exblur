defmodule Exblur.SQL do
  import Exblur.Checks, only: [present?: 1]

  def split(sql) do
    sql
    |> String.split(";")
    |> Enum.map(&String.replace(&1, "\n", ""))
    |> Enum.filter(&present?/1)
  end
end
