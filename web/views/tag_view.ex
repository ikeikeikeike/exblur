defmodule Exblur.TagView do
  use Exblur.Web, :view

  def render("autocomplete.json", %{tags: tags}) do
    render_many(tags, Exblur.TagView, "typeahead.json")
  end

  def render("typeahead.json", %{tag: tag}) do
    %{value: tag.name, tokens: String.split(tag.name)}
  end
end
