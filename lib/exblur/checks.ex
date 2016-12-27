defprotocol Exblur.Checks do
  @fallback_to_any true

  def blank?(data)
  def present?(data)
end

defimpl Exblur.Checks, for: Integer do
  alias Exblur.Checks
  def blank?(_),      do: false
  def present?(data), do: not Checks.blank?(data)
end

defimpl Exblur.Checks, for: String do
  alias Exblur.Checks
  def blank?(''),     do: true
  def blank?(' '),    do: true
  def blank?(_),      do: false
  def present?(data), do: not Checks.blank?(data)
end

defimpl Exblur.Checks, for: BitString do
  alias Exblur.Checks
  def blank?(""),     do: true
  def blank?(" "),    do: true
  def blank?(_),      do: false
  def present?(data), do: not Checks.blank?(data)
end

defimpl Exblur.Checks, for: List do
  alias Exblur.Checks
  def blank?([]),     do: true
  def blank?(_),      do: false
  def present?(data), do: not Checks.blank?(data)
end

defimpl Exblur.Checks, for: Tuple do
  alias Exblur.Checks
  def blank?({}),     do: true
  def blank?(_),      do: false
  def present?(data), do: not Checks.blank?(data)
end

defimpl Exblur.Checks, for: Map do
  alias Exblur.Checks
  def blank?(%{}),    do: true
  def blank?(_),      do: false
  def present?(data), do: not Checks.blank?(data)
end

defimpl Exblur.Checks, for: Atom do
  alias Exblur.Checks
  def blank?(false),  do: true
  def blank?(nil),    do: true
  def blank?(_),      do: false
  def present?(data), do: not Checks.blank?(data)
end

defimpl Exblur.Checks, for: MapSet do
  alias Exblur.Checks
  def blank?(data),   do: Enum.empty?(data)
  def present?(data), do: not Checks.blank?(data)
end

defimpl Exblur.Checks, for: Ecto.Date do
  alias Exblur.Checks
  def blank?(%Ecto.Date{year: 0, month: 0, day: 0}), do: true
  def blank?(%Ecto.Date{year: 1, month: 1, day: 1}), do: true
  def blank?(_), do: false
  def present?(data), do: not Checks.blank?(data)
end

defimpl Exblur.Checks, for: Ecto.Association.NotLoaded do
  alias Exblur.Checks

  def blank?(_), do: true
  def present?(data), do: not Checks.blank?(data)
end

defimpl Exblur.Checks, for: Any do
  def blank?(_),      do: false
  def present?(_),    do: false
end
