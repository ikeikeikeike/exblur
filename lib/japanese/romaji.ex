defmodule Japanese.Romaji do
  alias Japanese.Table

  def romaji2kana(text, options \\ []) do
    chars = 
      text
      |> normalize
      |> hira2kata 
      |> String.codepoints

    kana = detect_romaji(chars)

    case (options[:kana_type] || :katakana) do
      :hiragana ->
        kata2hira(kana)
      _ ->
        kana
    end
  end

  def detect_romaji(list, kana \\ "")
  def detect_romaji([], kana), do: kana
  def detect_romaji([head|tail], kana) do
    cond do
      # ン
      head == "m" && Enum.member?(["p", "b", "m"], List.first(tail)) ->
        detect_romaji(tail, kana <> "ン")
      # ッ
      head == List.first(tail) && ! Enum.member?(["a", "i", "u", "e", "o", "n"], head) && Regex.match?(~r/[a-z]/, head) ->
        detect_romaji(tail, kana <> "ッ")
      # otherwise
      true ->
        letters = 
          Enum.map((3..1), fn(n) ->
            taken = 
              tail
              |> Enum.take(n)
              |> Enum.join 

            if taken != "", do: Table.romaji2kana[taken], else: nil
          end)
          |> Enum.filter(&(&1 != nil))

        if letters == [] do
          letters = tail |> Enum.take(1)
        end

        detect_romaji(tail, kana <> Enum.join(letters))
    end
  end

  def hira2kata(text) when is_binary(text), do: hira2kata(to_char_list(text))
  def hira2kata(text) when is_atom(text), do: hira2kata(to_char_list(text))
  def hira2kata(text) when is_list(text) do
    :os.cmd(:string.join(['echo ', text, ' | nkf --katakana -Ww'], ''))
      |> parse_stdout
  end
  def hira2kata(_), do: nil

  def kata2hira(text) when is_binary(text), do: kata2hira(to_char_list(text))
  def kata2hira(text) when is_atom(text), do: kata2hira(to_char_list(text))
  def kata2hira(text) when is_list(text) do
    :os.cmd(:string.join(['echo ', text, ' | nkf --hiragana -Ww'], ''))
      |> parse_stdout
  end
  def kata2hira(_), do: nil

  def normalize(text) when is_binary(text), do: normalize(to_char_list(text))
  def normalize(text) when is_atom(text), do: normalize(to_char_list(text))
  def normalize(text) when is_list(text) do
    :os.cmd(:string.join(['echo ', text, ' | nkf -mZ0Wwh0'], ''))
      |> parse_stdout
      |> String.downcase
  end
  def normalize(_), do: nil
  
  defp parse_stdout(outstring) do
    outstring
      |> to_string
      |> String.split("\n")
      |> List.first
  end
end
