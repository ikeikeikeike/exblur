defmodule Exblur.DivaView do
  use Exblur.Web, :view
  import Exblur.WebView

  def render("autocomplete.json", %{divas: divas}) do
    render_many(divas, Exblur.TagView, "typeahead.json")
  end

  def render("typeahead.json", %{diva: diva}) do
    %{value: diva.name, tokens: String.split(diva.name)}
  end

end
