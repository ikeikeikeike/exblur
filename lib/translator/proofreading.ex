defmodule Translator.Proofreading do
  alias Translator.Proofreading, as: Proof

  def configure(tags_filter \\ [], sentences_filter \\ []) do
    start_link([
      tags: tags_filter,  #|| Filter.find_tags.as_filter,
      sentences: sentences_filter  #|| Filter.find_sentences.as_filter
    ])
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

    Enum.each filters[:tags], fn{key, value} ->
      word = String.replace(word, key, value)
    end

    Enum.each filters[:sentences], fn(key, values) ->
      word = String.replace(word, key, Enum.random(String.split(values, ",")))
    end

    word
  end

end
