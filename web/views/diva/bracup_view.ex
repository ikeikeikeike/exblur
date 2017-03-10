defmodule Exblur.Diva.BracupView do
  use Exblur.Web, :view
  import Exblur.WebView
  alias Exblur.Ordinalizer.Month

  def page_title(:index, _assigns), do: gettext("diva bracup index page title") <> " - " <> gettext("Default Page Title")
  def page_title(_, _), do: gettext("diva bracup index page title") <> " - " <> gettext("Default Page Title")

  def page_keywords(_, _), do: gettext("Default,Page,Keywords") <> "," <> gettext("Diva,Page,Keywords")

  def page_description(:index, _assigns), do: gettext("diva bracup index page title with %{name}", name: gettext("Site Name"))
  def page_description(_, _), do: gettext "Diva Page Description"

end
