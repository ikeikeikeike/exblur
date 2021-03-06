defmodule Exblur.Translator.Bing do

  # - Doing translate when including abobe 4 alphabets.
  # - Ascii will be translating.
  #
  def translate?(word) do
    Exblur.Imitation.String.is_ascii?(word) && word =~ ~r([A-Za-z]{4,})
  end

  def translate(word, opts \\ [to: "ja"])
  def translate(word, _opts) when "" ==  word,  do: word
  def translate(word, _opts) when is_nil(word), do: word
  def translate(word, opts) do
    case translate?(word) do
      false ->
        word

      true ->
        ConCache.get_or_store :exblur_cache, "translator.bing:#{word}", fn() ->
          BingTranslator.translate([text: word] ++ opts)
        end
    end
  end

end
