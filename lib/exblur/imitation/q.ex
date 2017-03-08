defmodule Exblur.Imitation.Q do
  alias Exblur.Repo

  def find_or_create(query, cset) do
    case model = Repo.one(query) do
      nil ->
        case Repo.insert(cset) do
          {:ok, model} ->
            {:new, model}

          {:error, cset} ->
            {:error, cset}
        end
      _ ->
        {:ok, model}
    end
  end

end
