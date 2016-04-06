defmodule Exblur.DivaView do
  use Exblur.Web, :view
  import Exblur.WebView

  def render("autocomplete.json", %{divas: divas}) do
    render_many(divas, Exblur.TagView, "typeahead.json")
  end

  def render("typeahead.json", %{diva: diva}) do
    %{value: diva.name, tokens: String.split(diva.name)}
  end

  def page_title(_, _), do: gettext("ALL Divas") <> " - " <> gettext("Default Page Title")
  def page_keywords(_, _), do: gettext("Default,Page,Keywords") <> "," <> gettext("Diva,Page,Keywords")
  def page_description(_, _), do: gettext "Diva Page Description"

end
