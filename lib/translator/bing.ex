defmodule Translator.Bing do

  # - Doing translate when including abobe 4 alphabets.
  # - Ascii will be translating.
  #
  def translate?(word) do
    Imitation.String.is_ascii?(word) && word =~ ~r([A-Za-z]{4,})
  end

  def translate(word) when "" ==  word,  do: word
  def translate(word) when is_nil(word), do: word
  def translate(word) do
    case translate?(word) do
      false ->
        word

      true ->
        ConCache.get_or_store exblur_cache:, "translator.bing:#{key}", fn ->
          BingTranslator.translate(word, to: "ja")
        end
    end
  end

end
