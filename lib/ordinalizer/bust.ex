defmodule Ordinalizer.Bust do
  @moduledoc false

  def ordinalize(locale, number) when not is_number(number) do
    {n, _} = Integer.parse(number)
    ordinalize(locale, n)
  end

  def ordinalize(locale, number) when is_number(number) do
    case locale do
      "en" ->
        case number do
          10  -> "Around 10-19"
          20  -> "Around 20-29"
          30  -> "Around 30-39"
          40  -> "Around 40-49"
          50  -> "Around 50-59"
          60  -> "Around 60-69"
          70  -> "Around 70-79"
          80  -> "Around 80-89"
          90  -> "Around 90-99"
          100 -> "Around 100-109"
          110 -> "Around 110-119"
          120 -> "Around 120-129"
          130 -> "Around 130-139"
          140 -> "Around 140-149"
          150 -> "Around 150-159"
          160 -> "Around 160-169"
          170 -> "Around 170-179"
        end
      "ja" ->
        case number do
          10  -> "10-19"
          20  -> "20-29"
          30  -> "30-39"
          40  -> "40-49"
          50  -> "50-59"
          60  -> "60-69"
          70  -> "70-79"
          80  -> "80-89"
          90  -> "90-99"
          100 -> "100-109"
          110 -> "110-119"
          120 -> "120-129"
          130 -> "130-139"
          140 -> "140-149"
          150 -> "150-159"
          160 -> "160-169"
          170 -> "170-179"
        end
    end
  end

end
