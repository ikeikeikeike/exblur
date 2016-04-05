defprotocol Blank do
  @fallback_to_any true
  def blank?(data)
end

defimpl Blank, for: Integer do
  def blank?(_), do: false
end

defimpl Blank, for: String do
  def blank?(''),    do: true
  def blank?(_),     do: false
end

defimpl Blank, for: BitString do
  def blank?(""),    do: true
  def blank?(_),     do: false
end

defimpl Blank, for: List do
  def blank?([]), do: true
  def blank?(_),  do: false
end

defimpl Blank, for: Tuple do
  def blank?({}), do: true
  def blank?(_),  do: false
end

defimpl Blank, for: Map do
  def blank?(%{}), do: true
  def blank?(_),  do: false
end

defimpl Blank, for: Atom do
  def blank?(false), do: true
  def blank?(nil),   do: true
  def blank?(_),     do: false
end

defimpl Blank, for: Any do
  def blank?(_), do: false
end
