defmodule Exblur.Repo do
  use Ecto.Repo, otp_app: :exblur
  # use Scrivener, page_size: 10

  def execute_and_load(sql, params) do
    Ecto.Adapters.SQL.query!(__MODULE__, sql, params)
    |> load_into()
  end
  def execute_and_load(sql, params, model) do
    Ecto.Adapters.SQL.query!(__MODULE__, sql, params)
    |> load_into(model)
  end

  defp load_into(qs) do
    cols = Enum.map qs.columns, & String.to_atom(&1)

    Enum.map qs.rows, fn row ->
      Enum.zip(cols, row) |> Enum.into(%{})
    end
  end
  defp load_into(qs, model) do
    Enum.map qs.rows, fn(row) ->
      zip    = Enum.zip(qs.columns, row)
      fields = Enum.reduce(zip, %{}, fn({key, value}, map) ->
        Map.put(map, key, value)
      end)

      __MODULE__.load model, fields
    end
  end

end
