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
        word
        # translated = Rails.cache.fetch("en_to_ja:#{word}", expires_in: 15.days) do
          # BingTranslator.translate("Hello. This will be translated!", to: "ja")
          # client.translate word, from: 'en', to: 'ja'
        # end

        # translated
    end
  end

end
