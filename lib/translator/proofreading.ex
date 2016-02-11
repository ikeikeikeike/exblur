defmodule Translator.Proofreading do
  alias Translator.Proofreading, as: Proof

  def configure do
    filters =
      Path.join(File.cwd!, "config/translate_filters.yml")
      |> YamlElixir.read_from_file

    start_link([tags: filters["tags"], sentences: filters["sentences"]])
    {:ok, []}
  end

  def configure(tags_filter, sentences_filter) do
    start_link([tags: tags_filter, sentences: sentences_filter])
    {:ok, []}
  end

  defp start_link(value) do
    Agent.start_link(fn -> value end, name: __MODULE__)
  end

  @doc """
  Get the filters
  """
  def filters do
    Agent.get(__MODULE__, fn config -> config end)
  end

  # sentence needs data types below.
  #
  #  - from_word: 'from word'
  #  - to_word: 'to_word'
  #  or
  #  - from_word: 'from word'
  #  - to_word: 'word1,word2,ward3'
  #
  def sentence(word) when "" ==  word,  do: word
  def sentence(word) when is_nil(word), do: word
  def sentence(word) do
    filters = Proof.filters

    word
    |> proof_tag(filters[:tags])
    |> proof_sentence(filters[:sentences])
  end

  defp proof_tag(word, []), do: word
  defp proof_tag(word, [map|tail]) do
    word
    |> String.replace(map["from_word"], map["to_word"])
    |> proof_tag(tail)
  end

  defp proof_sentence(word, []), do: word
  defp proof_sentence(word, [map|tail]) do
    value = Enum.random(String.split(map["to_word"], ","))

    word
    |> String.replace(map["from_word"], value)
    |> proof_sentence(tail)
  end

end
