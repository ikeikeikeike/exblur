defmodule Exblur.LayoutView do
  use Exblur.Web, :view

  @doc """
  Renders current locale.
  """
  def locale do
    Gettext.get_locale(Exblur.Gettext)
  end

end
