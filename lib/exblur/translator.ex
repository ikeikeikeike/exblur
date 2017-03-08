defmodule Exblur.Translator do
  @doc """
  translator
  """
  defdelegate translate?(word), to: Exblur.Translator.Bing, as: :translate?
  defdelegate translate(word), to: Exblur.Translator.Bing, as: :translate
  defdelegate translate(word, opts), to: Exblur.Translator.Bing, as: :translate

  @doc """
  Proofreading
  """
  defdelegate tag(word), to: Exblur.Translator.Proofreading, as: :tag
  defdelegate sentence(word), to: Exblur.Translator.Proofreading, as: :sentence

  @doc """
  configuration
  """
  def configure do
    BingTranslator.configure
    Exblur.Translator.Proofreading.configure
  end
end
