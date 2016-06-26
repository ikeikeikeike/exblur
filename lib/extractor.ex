defmodule TextExtractor do

  def safe_title(url) do
    Regex.replace(~r/\\|\/|\:/, url, "-")
  end

end
