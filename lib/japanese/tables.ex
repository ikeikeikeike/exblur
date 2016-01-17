defmodule Japanese.Table do
  def kana_max_length, do: 2

  def romaji2kana, do: %{
    "a"   => "ア",   "i"    => "イ",   "u"   => "ウ",   "e"   => "エ",   "o"   => "オ", "-"=>"ー",
    "xa"  => "ァ",   "xi"   => "ィ",   "xu"  => "ゥ",   "xe"  => "ェ",   "xo"  => "ォ",
    "ka"  => "カ",   "ki"   => "キ",   "ku"  => "ク",   "ke"  => "ケ",   "ko"  => "コ",
    "ca"  => "カ",   "cu"   => "ク",   "co"  => "コ",
    "ga"  => "ガ",   "gi"   => "ギ",   "gu"  => "グ",   "ge"  => "ゲ",   "go"  => "ゴ",
    "sa"  => "サ",   "si"   => "シ",   "su"  => "ス",   "se"  => "セ",   "so"  => "ソ",
    "za"  => "ザ",   "zi"   => "ジ",   "zu"  => "ズ",   "ze"  => "ゼ",   "zo"  => "ゾ",
    "ja"  => "ジャ", "ji"   => "ジ",   "ju"  => "ジュ", "je"  => "ジェ", "jo"  => "ジョ",
    "ta"  => "タ",   "ti"   => "チ",   "tu"  => "ツ",   "te"  => "テ",   "to"  => "ト",
    "da"  => "ダ",   "di"   => "ヂ",   "du"  => "ヅ",   "de"  => "デ",   "do"  => "ド",
    "na"  => "ナ",   "ni"   => "ニ",   "nu"  => "ヌ",   "ne"  => "ネ",   "no"  => "ノ",
    "ha"  => "ハ",   "hi"   => "ヒ",   "hu"  => "フ",   "he"  => "ヘ",   "ho"  => "ホ",
    "ba"  => "バ",   "bi"   => "ビ",   "bu"  => "ブ",   "be"  => "ベ",   "bo"  => "ボ",
    "pa"  => "パ",   "pi"   => "ピ",   "pu"  => "プ",   "pe"  => "ペ",   "po"  => "ポ",
    "va"  => "ヴァ", "vi"   => "ヴィ", "vu"  => "ヴ",   "ve"  => "ヴェ", "vo"  => "ヴォ",
    "fa"  => "ファ", "fi"   => "フィ", "fu"  => "フ",   "fe"  => "フェ", "fo"  => "フォ",
    "ma"  => "マ",   "mi"   => "ミ",   "mu"  => "ム",   "me"  => "メ",   "mo"  => "モ",
    "ya"  => "ヤ",   "yi"   => "イ",   "yu"  => "ユ",   "ye"  => "イェ", "yo"  => "ヨ",
    "ra"  => "ラ",   "ri"   => "リ",   "ru"  => "ル",   "re"  => "レ",   "ro"  => "ロ",
    "la"  => "ラ",   "li"   => "リ",   "lu"  => "ル",   "le"  => "レ",   "lo"  => "ロ",
    "wa"  => "ワ",   "wi"   => "ウィ", "wu"  => "ウ",   "we"  => "ウェ", "wo"  => "ヲ",
    "nn"  => "ン",   "n"    => "ン",
    "tsu" => "ツ",
    "xka" => "ヵ",   "xke"  => "ヶ",
    "xwa" => "ヮ",   "xtsu" => "ッ",   "xya" => "ャ",   "xyu" => "ュ",   "xyo" => "ョ",
    "kya" => "キャ", "kyi"  => "キィ", "kyu" => "キュ", "kye" => "キェ", "kyo" => "キョ",
    "gya" => "ギャ", "gyi"  => "ギィ", "gyu" => "ギュ", "gye" => "ギェ", "gyo" => "ギョ",
    "sya" => "シャ", "syi"  => "シィ", "syu" => "シュ", "sye" => "シェ", "syo" => "ショ",
    "sha" => "シャ", "shi"  => "シ",  "shu"  => "シュ", "she" => "シェ", "sho" => "ショ",
    "zya" => "ジャ", "zyi"  => "ジィ", "zyu" => "ジュ", "zye" => "ジェ", "zyo" => "ジョ",
    "jya" => "ジャ", "jyi"  => "ジィ", "jyu" => "ジュ", "jye" => "ジェ", "jyo" => "ジョ",
    "tya" => "チャ", "tyi"  => "チィ", "tyu" => "チュ", "tye" => "チェ", "tyo" => "チョ",
    "twa" => "トァ", "twi"  => "トィ", "twu" => "トゥ", "twe" => "トェ", "two" => "トォ",
    "dwa" => "ドァ", "dwi"  => "ドィ", "dwu" => "ドゥ", "dwe" => "ドェ", "dwo" => "ドォ",
    "cya" => "チャ", "cyi"  => "チィ", "cyu" => "チュ", "cye" => "チェ", "cyo" => "チョ",
    "cha" => "チャ", "chi"  => "チ",   "chu" => "チュ", "che" => "チェ", "cho" => "チョ",
    "tha" => "テャ", "thi"  => "ティ", "thu" => "テュ", "the" => "テェ", "tho" => "テョ",
    "dya" => "ヂャ", "dyi"  => "ヂィ", "dyu" => "ヂュ", "dye" => "ヂェ", "dyo" => "ヂョ",
    "dha" => "デャ", "dhi"  => "ディ", "dhu" => "デュ", "dhe" => "デェ", "dho" => "デョ",
    "nya" => "ニャ", "nyi"  => "ニィ", "nyu" => "ニュ", "nye" => "ニェ", "nyo" => "ニョ",
    "hya" => "ヒャ", "hyi"  => "ヒィ", "hyu" => "ヒュ", "hye" => "ヒェ", "hyo" => "ヒョ",
    "bya" => "ビャ", "byi"  => "ビィ", "byu" => "ビュ", "bye" => "ビェ", "byo" => "ビョ",
    "pya" => "ピャ", "pyi"  => "ピィ", "pyu" => "ピュ", "pye" => "ピェ", "pyo" => "ピョ",
    "mya" => "ミャ", "myi"  => "ミィ", "myu" => "ミュ", "mye" => "ミェ", "myo" => "ミョ",
    "rya" => "リャ", "ryi"  => "リィ", "ryu" => "リュ", "rye" => "リェ", "ryo" => "リョ",
    "lya" => "リャ", "lyi"  => "リィ", "lyu" => "リュ", "lye" => "リェ", "lyo" => "リョ"
  }

  def kana2romaji, do: %{
    "ア"   => ["a"], "イ" => ["i"], "ウ" => ["u"], "エ" => ["e"], "オ" => ["o"],
    "カ"   => ["ka", "ca"], "キ" => ["ki"], "ク" => ["ku"], "ケ" => ["ke"], "コ" => ["ko", "co"],
    "サ"   => ["sa"], "シ" => ["shi", "si"], "ス" => ["su"], "セ" => ["se"], "ソ" => ["so"],
    "タ"   => ["ta"], "チ" => ["chi", "ti", "ci"], "ツ" => ["tsu", "tu"], "テ" => ["te"], "ト" => ["to"],
    "ナ"   => ["na"], "ニ" => ["ni"], "ヌ" => ["nu"], "ネ" => ["ne"], "ノ" => ["no"],
    "ハ"   => ["ha"], "ヒ" => ["hi"], "フ" => ["fu", "hu"], "ヘ" => ["he"], "ホ" => ["ho"],
    "マ"   => ["ma"], "ミ" => ["mi"], "ム" => ["mu"], "メ" => ["me"], "モ" => ["mo"],
    "ヤ"   => ["ya"], "ユ" => ["yu"], "ヨ" => ["yo"],
    "ラ"   => ["ra"], "リ" => ["ri"], "ル" => ["ru"], "レ" => ["re"], "ロ" => ["ro"],
    "ワ"   => ["wa"], "ウィ" => ["wi"], "ウェ" => ["we"], "ヲ" => ["wo"], "ー" => ["-"],
    "ガ"   => ["ga"], "ギ" => ["gi"], "グ" => ["gu"], "ゲ" => ["ge"], "ゴ" => ["go"],
    "ザ"   => ["za"], "ジ" => ["ji", "zi"], "ズ" => ["zu"], "ゼ" => ["ze"], "ゾ" => ["zo"],
    "ダ"   => ["da"], "ヂ" => ["di"], "ヅ" => ["du"], "デ" => ["de"], "ド" => ["do"],
    "バ"   => ["ba"], "ビ" => ["bi"], "ブ" => ["bu"], "ベ" => ["be"], "ボ" => ["bo"],
    "パ"   => ["pa"], "ピ" => ["pi"], "プ" => ["pu"], "ペ" => ["pe"], "ポ" => ["po"],
    "キャ" => ["kya"], "キュ" => ["kyu"], "キェ" => ["kye"], "キョ" => ["kyo"],
    "ギャ" => ["gya"], "ギュ" => ["gyu"], "ギェ" => ["gye"], "ギョ" => ["gyo"],
    "シャ" => ["sha", "sya"], "シュ" => ["shu", "syu"], "シェ" => ["she", "sye"], "ショ" => ["sho", "syo"],
    "ジャ" => ["ja", "jya", "zya"], "ジュ" => ["ju", "jyu", "zyu"], "ジェ" => ["je", "jye", "zye"], "ジョ" => ["jo", "jyo", "zyo"],
    "チャ" => ["cha", "cya", "tya"], "チュ" => ["chu", "cyu", "tyu"], "チェ" => ["che", "cye", "tye"], "チョ" => ["cho", "cyo", "tyo"],
    "ヂャ" => ["dya"], "ヂュ" => ["dyu"], "ヂェ" => ["dye"], "ヂョ" => ["dyo"],
    "テャ" => ["tha"], "ティ" => ["thi"], "テュ" => ["thu"], "テョ" => ["tho"],
    "トァ" => ["twa"], "トィ" => ["twi"], "トゥ" => ["twu"], "トェ" => ["twe"], "トォ" => ["two"],
    "ドァ" => ["dwa"], "ドィ" => ["dwi"], "ドゥ" => ["dwu"], "ドェ" => ["dwe"], "ドォ" => ["dwo"],
    "ニャ" => ["nya"], "ニュ" => ["nyu"], "ニェ" => ["nye"], "ニョ" => ["nyo"],
    "ヒャ" => ["hya"], "ヒュ" => ["hyu"], "ヒェ" => ["hye"], "ヒョ" => ["hyo"],
    "ビャ" => ["bya"], "ビュ" => ["byu"], "ビェ" => ["bye"], "ビョ" => ["byo"],
    "ピャ" => ["pya"], "ピュ" => ["pyu"], "ピェ" => ["pye"], "ピョ" => ["pyo"],
    "ファ" => ["fa"], "フィ" => ["fi"], "フェ" => ["fe"], "フォ" => ["fo"],
    "ミャ" => ["mya"], "ミュ" => ["myu"], "ミェ" => ["mye"], "ミョ" => ["myo"],
    "リャ" => ["rya"], "リュ" => ["ryu"], "リェ" => ["rye"], "リョ" => ["ryo"],
    "ヴァ" => ["va"], "ヴィ" => ["vi"], "ヴ" => ["vu"], "ヴェ" => ["ve"], "ヴォ" => ["vo"],
    "デャ" => ["dha"], "ディ" => ["dhi"], "デュ" => ["dhu"], "デェ" => ["dhe"], "デョ" => ["dho"]
  }


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


  def hira2kata(text) when is_binary(text), do: hira2kata(to_char_list(text))
  def hira2kata(text) when is_atom(text), do: hira2kata(to_char_list(text))
  def hira2kata(text) when is_list(text) do
    t = :os.cmd(:string.join(['echo ', text, ' | nkf --katakana -Ww'], ''))
    |> to_string
    |> String.downcase
    |> String.split("\n")
    |> List.first

    {:ok, t}
  end
  def hira2kata(_), do: {:error, "couldnot hira2kata"}

  def kata2hira(text) when is_binary(text), do: hira2kata(to_char_list(text))
  def kata2hira(text) when is_atom(text), do: hira2kata(to_char_list(text))
  def kata2hira(text) when is_list(text) do
    t = :os.cmd(:string.join(['echo ', text, ' | nkf --hiragana -Ww'], ''))
    |> to_string
    |> String.downcase
    |> String.split("\n")
    |> List.first

    {:ok, t}
  end

  def normalize(text) when is_binary(text), do: normalize(to_char_list(text))
  def normalize(text) when is_atom(text), do: normalize(to_char_list(text))
  def normalize(text) when is_list(text) do
    t = :os.cmd(:string.join(['echo ', text, ' | nkf -mZ0Wwh0'], ''))
    |> to_string
    |> String.downcase
    |> String.split("\n")
    |> List.first

    {:ok, t}
  end
  def normalize(_), do: {:error, "couldnot normalize"}

end
