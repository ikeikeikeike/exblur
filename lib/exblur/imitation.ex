defmodule Exblur.Imitation do
  @doc """
  ruby converters
  """
  defdelegate to_i(numeric), to: Exblur.Imitation.Converter, as: :to_i

  def randstr(length) do
    length
    |> :crypto.strong_rand_bytes
    |> Base.url_encode64
    |> binary_part(0, length)
  end

end
