defmodule Exblur.Diva.AgeView do
  use Exblur.Web, :view
  import Exblur.WebView
  alias Exblur.Ordinalizer.Month

  def page_title(:index, _assigns), do: gettext("diva age index page title") <> " - " <> gettext("Default Page Title")
  def page_title(:age, assigns) do
    params = assigns.conn.params
    gettext("diva age page title with %{name}", name: params["age"]) <> " - " <> gettext("Default Page Title")
  end
  def page_title(_, _), do: gettext("diva age index page title") <> " - " <> gettext("Default Page Title")

  def page_keywords(_, _), do: gettext("Default,Page,Keywords") <> "," <> gettext("Diva,Page,Keywords")

  def page_description(:index, _assigns), do: gettext("diva age index page title with %{name}", name: gettext("Site Name"))
  def page_description(:age, assigns) do
    params = assigns.conn.params
    gettext "diva age page title with %{name} and %{age}",
             name: gettext("Site Name"), age: params["age"]
  end
  def page_description(_, _), do: gettext "Diva Page Description"

end
