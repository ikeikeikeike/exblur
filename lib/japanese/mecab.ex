defmodule Japanese.Mecab do
  defstruct [:surface, :feature, :pos, :pos1, :pos2, :pos3, :cform, :ctype, :base, :read, :pron, :romaji, :kunrei, :hiragana]

  def parse(word) when is_binary(word), do: parse(to_char_list(word))
  def parse(word) when is_atom(word), do: parse(to_char_list(word))
  def parse(word) when is_list(word) do
    structs = 
      :os.cmd(:string.join(['echo ', word, ' | mecab'], ''))
      |> to_string
      |> String.split("\n")
      |> Enum.filter_map(&(&1 != "EOS" && &1 != ""), &parse_line(&1))
      
    case structs do
      {:error, reason} ->
        {:error, reason}
      _ ->
        {:ok, structs}
    end
  end
  def parse(_), do: {:error, "type error: need to set atom or string or binary in this argument"}

  def parse_line(line) when is_binary(line) do
    [s, f] = String.split(line, "\t")
    case String.split(f, ",") do
      [p, p1, p2, p3, cf, ct, b, r, pr] ->
        %Japanese.Mecab{surface: s, feature: f, pos: p, pos1: p1, pos2: p2, pos3: p3, cform: cf, ctype: ct, base: b, read: r, pron: pr}
      [p, p1, p2, p3, cf, ct, b] ->
        %Japanese.Mecab{surface: s, feature: f, pos: p, pos1: p1, pos2: p2, pos3: p3, cform: cf, ctype: ct, base: b}
      _ ->
        {:error, "cannot parse line"}
    end
  end
  def parse_line(_), do: {:error, "cannot set mecab's line to %Japanese.Mecab{}"}

end
