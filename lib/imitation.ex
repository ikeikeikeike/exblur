defmodule Imitation do
  @doc """
  ruby converters
  """
  defdelegate to_i(numeric), to: Imitation.Converter, as: :to_i
end
