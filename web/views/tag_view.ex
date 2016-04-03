defmodule Exblur.TagView do
  use Exblur.Web, :view

  def render("autocomplete.json", %{tags: tags}) do
    render_many(tags, Exblur.TagView, "typeahead.json")
  end

  def render("typeahead.json", %{tag: tag}) do
    %{value: tag.name, tokens: String.split(tag.name)}
  end

  def page_title(_, _), do: gettext "ALL Tags"
  def page_keywords(_, _), do: gettext("Default,Page,Keywords") <> "," <> gettext("Tag,Page,Keywords")
  def page_description(_, _), do: gettext "Tag Page Description"

end
