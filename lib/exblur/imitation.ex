defmodule Exblur.Imitation do
  @doc """
  ruby converters
  """
  defdelegate to_i(numeric), to: Exblur.Imitation.Converter, as: :to_i
end
