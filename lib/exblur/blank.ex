defprotocol Exblur.Blank do
  @fallback_to_any true

  def blank?(data)
  def present?(data)
end

defimpl Exblur.Blank, for: Integer do
  alias Exblur.Blank
  def blank?(_),      do: false
  def present?(data), do: not Exblur.Blank.blank?(data)
end

defimpl Exblur.Blank, for: String do
  alias Exblur.Blank
  def blank?(''),     do: true
  def blank?(' '),    do: true
  def blank?(_),      do: false
  def present?(data), do: not Exblur.Blank.blank?(data)
end

defimpl Exblur.Blank, for: BitString do
  alias Exblur.Blank
  def blank?(""),     do: true
  def blank?(" "),    do: true
  def blank?(_),      do: false
  def present?(data), do: not Exblur.Blank.blank?(data)
end

defimpl Exblur.Blank, for: List do
  alias Exblur.Blank
  def blank?([]),     do: true
  def blank?(_),      do: false
  def present?(data), do: not Exblur.Blank.blank?(data)
end

defimpl Exblur.Blank, for: Tuple do
  alias Exblur.Blank
  def blank?({}),     do: true
  def blank?(_),      do: false
  def present?(data), do: not Exblur.Blank.blank?(data)
end

defimpl Exblur.Blank, for: Map do
  alias Exblur.Blank
  def blank?(map) when map_size(map) <= 0, do: true
  def blank?(_),      do: false
  def present?(data), do: not Exblur.Blank.blank?(data)
end

defimpl Exblur.Blank, for: Atom do
  alias Exblur.Blank
  def blank?(false),  do: true
  def blank?(nil),    do: true
  def blank?(_),      do: false
  def present?(data), do: not Exblur.Blank.blank?(data)
end

defimpl Exblur.Blank, for: MapSet do
  alias Exblur.Blank
  def blank?(data),   do: Enum.empty?(data)
  def present?(data), do: not Exblur.Blank.blank?(data)
end

if Code.ensure_loaded?(Ecto) do
  defimpl Exblur.Blank, for: Ecto.Date do
    alias Exblur.Blank
    def blank?(%Ecto.Date{year: 0, month: 0, day: 0}), do: true
    def blank?(%Ecto.Date{year: 1, month: 1, day: 1}), do: true
    def blank?(_), do: false
    def present?(data), do: not Exblur.Blank.blank?(data)
  end

  defimpl Exblur.Blank, for: Ecto.Association.NotLoaded do
    alias Exblur.Blank

    def blank?(_), do: true
    def present?(data), do: not Exblur.Blank.blank?(data)
  end
end

defimpl Exblur.Blank, for: Any do
  def blank?(_),      do: false
  def present?(_),    do: false
end
