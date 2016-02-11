defmodule Translator.Proofreading do

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

        # Enum.each @filters[:tags], fn{key, value} ->
          # word = word.sub(key, value)
        # end

        # Enum.each @filters[:sentences], fn(key, values) ->
          # word = word.sub(key, values.split(',').sample)
        # end

        word
      end

end
