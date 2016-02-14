defmodule Translator do
  @doc """
  translator
  """
  defdelegate translate?(word), to: Translator.Bing, as: :translate?
  defdelegate translate(word), to: Translator.Bing, as: :translate
  defdelegate translate(word, opts), to: Translator.Bing, as: :translate

  @doc """
  Proofreading
  """
  defdelegate tag(word), to: Translator.Proofreading, as: :tag
  defdelegate sentence(word), to: Translator.Proofreading, as: :sentence

  @doc """
  configuration
  """
  def configure do
    BingTranslator.configure
    Translator.Proofreading.configure
  end
end
