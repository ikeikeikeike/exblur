defmodule Japanese.Romaji do
  # alias Japanese.Table

  # def romaji2kana(text, options \\ []) do
    # text = hira2kata(normalize(text))
    # pos = 0
    # k = nil
    # kana = ''
    # chars =  text.split(//u)
    # while true do
      # # ン
      # if chars[pos] == 'm' && ['p', 'b', 'm'].include?(chars[pos + 1])
        # kana += 'ン'
        # pos += 1
        # next
      # end

      # # ッ
      # if chars[pos] == chars[pos + 1] && !['a', 'i', 'u', 'e', 'o', 'n'].include?(chars[pos]) && chars[pos] =~ /[a-z]/
        # kana += 'ッ'
        # pos += 1
        # next
      # end

      # Enum.each [3, 2, 1], fn t ->
        # substr = chars.slice(pos, t).join
        # k = ROMAJI2KANA[substr]
        # if k do
          # kana += k
          # pos += t
          # break
        # end
      # end
      # unless k do
        # kana += chars.slice(pos, 1).join
        # pos += 1
      # end

      # if pos >= chars.size, do: break
    # end

    # kana_type = options[:kana_type] || :katakana
    # kana = kata2hira(kana) if :hiragana == kana_type.to_sym
      
    # kana
  # end

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
    detect_romaji(tail, kana <> head)
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
