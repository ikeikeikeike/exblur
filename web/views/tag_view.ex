defmodule Exblur.TagView do
  use Exblur.Web, :view
  import Exblur.WebView

  def render("autocomplete.json", %{tags: tags}) do
    render_many(tags, Exblur.TagView, "typeahead.json")
  end

  def render("typeahead.json", %{tag: tag}) do
    %{value: tag.name, tokens: String.split(tag.name)}
  end

  def page_title(_, _), do: gettext("All Tags") <> " - " <> gettext "tag page title with %{name}", name: gettext("Site Name")
  def page_keywords(_, _), do: gettext("Default,Page,Keywords") <> "," <> gettext("Tag,Page,Keywords")
  def page_description(_, _), do: gettext "tag page title with %{name}", name: gettext("Site Name")

end
