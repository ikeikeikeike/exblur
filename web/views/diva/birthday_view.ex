defmodule Exblur.Diva.BirthdayView do
  use Exblur.Web, :view
  import Exblur.WebView
  alias Exblur.Ordinalizer.Month

  def page_title(:index, _assigns), do: gettext("diva birthday index page title") <> " - " <> gettext("Default Page Title")
  def page_title(:year, assigns) do
    params = assigns.conn.params
    gettext("diva birthday year page title with %{year}", year: params["year"]) <> " - " <> gettext("Default Page Title")
  end
  def page_title(:month, assigns) do
    params = assigns.conn.params
    gettext("diva birthday month page title with %{year} and %{month}",
             year: params["year"], month: Month.ordinalize(locale(), params["month"])) <> " - " <> gettext("Default Page Title")
  end
  def page_title(_, _), do: gettext("diva birthday index page title") <> " - " <> gettext("Default Page Title")

  def page_keywords(_, _), do: gettext("Default,Page,Keywords") <> "," <> gettext("Diva,Page,Keywords")

  def page_description(:index, _assigns), do: gettext("diva birthday index page title with %{name}", name: gettext("Site Name"))
  def page_description(:year, assigns) do
    params = assigns.conn.params
    gettext "diva birthday year page title with %{name} and %{year}",
             name: gettext("Site Name"), year: params["year"]
  end
  def page_description(:month, assigns) do
    params = assigns.conn.params
    gettext "diva birthday month page title with %{name} and %{year} and %{month}",
             name: gettext("Site Name"), year: params["year"], month: Month.ordinalize(locale(), params["month"])
  end
  def page_description(_, _), do: gettext "Diva Page Description"

end
