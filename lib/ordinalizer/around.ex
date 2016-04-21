defmodule Ordinalizer.Around do
  @moduledoc false

  def ten(locale, number) when not is_number(number) do
    {n, _} = Integer.parse(number)
    ten(locale, n)
  end

  def ten(locale, number) when is_number(number) do
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

  def five(locale, number) when not is_number(number) do
    {n, _} = Integer.parse(number)
    five(locale, n)
  end

  def five(locale, number) when is_number(number) do
    case locale do
      "en" ->
        case number do
          5   -> "Around 5-9"
          10  -> "Around 10-14"
          15  -> "Around 15-19"
          20  -> "Around 20-24"
          25  -> "Around 25-29"
          30  -> "Around 30-34"
          35  -> "Around 35-39"
          40  -> "Around 40-44"
          45  -> "Around 45-49"
          50  -> "Around 50-54"
          55  -> "Around 55-59"
          60  -> "Around 60-64"
          65  -> "Around 65-69"
          70  -> "Around 70-74"
          75  -> "Around 75-79"
          80  -> "Around 80-84"
          85  -> "Around 85-89"
          90  -> "Around 90-94"
          95  -> "Around 95-99"
          100 -> "Around 100-104"
          105 -> "Around 105-109"
          110 -> "Around 110-114"
          115 -> "Around 115-119"
          120 -> "Around 120-124"
          125 -> "Around 125-129"
          130 -> "Around 130-134"
          135 -> "Around 135-139"
          140 -> "Around 140-144"
          145 -> "Around 145-149"
          150 -> "Around 150-154"
          155 -> "Around 155-159"
          160 -> "Around 160-164"
          165 -> "Around 165-169"
          170 -> "Around 170-174"
          175 -> "Around 175-179"
        end
      "ja" ->
        case number do
          5   -> "5-9"
          10  -> "10-14"
          15  -> "15-19"
          20  -> "20-24"
          25  -> "25-29"
          30  -> "30-34"
          35  -> "35-39"
          40  -> "40-44"
          45  -> "45-49"
          50  -> "50-54"
          55  -> "55-59"
          60  -> "60-64"
          65  -> "65-69"
          70  -> "70-74"
          75  -> "75-79"
          80  -> "80-84"
          85  -> "85-89"
          90  -> "90-94"
          95  -> "95-99"
          100 -> "100-104"
          105 -> "105-109"
          110 -> "110-114"
          115 -> "115-119"
          120 -> "120-124"
          125 -> "125-129"
          130 -> "130-134"
          135 -> "135-139"
          140 -> "140-144"
          145 -> "145-149"
          150 -> "150-154"
          155 -> "155-159"
          160 -> "160-164"
          165 -> "165-169"
          170 -> "170-174"
          175 -> "175-179"
        end
    end
  end


end
