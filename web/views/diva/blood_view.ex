defmodule Exblur.Diva.BloodView do
  use Exblur.Web, :view
  import Exblur.WebView

  def page_title(:index, _assigns), do: gettext("diva blood index page title") <> " - " <> gettext("Default Page Title")
  def page_title(_, _), do: gettext("diva blood index page title") <> " - " <> gettext("Default Page Title")

  def page_keywords(_, _), do: gettext("Default,Page,Keywords") <> "," <> gettext("Diva,Page,Keywords")

  def page_description(:index, _assigns), do: gettext("diva blood index page title with %{name}", name: gettext("Site Name"))
  def page_description(_, _), do: gettext "Diva Page Description"

end
