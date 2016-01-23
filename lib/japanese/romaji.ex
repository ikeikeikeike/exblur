defmodule Japanese.Romaji do
  alias Japanese.Table

  def katakana(text) do
    text
    |> normalize
    |> hira2kata 
    |> String.codepoints
    |> detect_romaji
  end

  def hiragana(text) do
    text
    |> normalize
    |> hira2kata 
    |> String.codepoints
    |> detect_romaji
    |> kata2hira
  end

  defp detect_romaji(list, kana \\ "")
  defp detect_romaji([], kana), do: kana
  defp detect_romaji([head|tail], kana) do
    cond do
      # ン
      head == "m" && Enum.member?(["p", "b", "m"], List.first(tail)) ->
        detect_romaji(tail, kana <> "ン")
      # ッ
      (  
        head == List.first(tail) && Regex.match?(~r/[a-z]/, head) && 
       !Enum.member?(["a", "i", "u", "e", "o", "n"], head)
      ) ->
        detect_romaji(tail, kana <> "ッ")
      # otherwise
      true ->
        case pos_loop([head] ++ tail) do
          {_, nil} ->
            detect_romaji(tail, kana <> head)
          {tail, letter} ->
            detect_romaji(tail, kana <> letter)
        end
    end
  end

  defp pos_loop(list), do: pos_loop(list, 3)
  defp pos_loop(list, num) do
    case letter = Table.romaji2kana[Enum.join(Enum.take(list, num))] do
      nil ->
        if num > 1, do: pos_loop(list, num - 1), else: {list, nil}
      _ ->
        {Enum.slice(list, num, length(list)), letter}
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
