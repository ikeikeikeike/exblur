defmodule Exblur.DivaView do
  use Exblur.Web, :view
  import Exblur.WebView

  def render("autocomplete.json", %{divas: divas}) do
    render_many(divas, __MODULE__, "typeahead.json")
  end

  def render("typeahead.json", %{diva: diva}) do
    %{
      name: diva.name,
      kana: diva.kana,
      romaji: diva.romaji,
      gyou: diva.gyou,
      height: diva.height,
      weight: diva.weight,
      bust: diva.bust,
      bracup: diva.bracup,
      waist: diva.waste,
      hip: diva.hip,
      blood: diva.blood,
      birthday: diva.birthday,
      image:  divaimg(diva),
      appeared: diva.appeared,
    }
  end

  def page_title(_, _), do: gettext("All Divas") <> " - " <> gettext("Default Page Title")
  def page_keywords(_, _), do: gettext("Default,Page,Keywords") <> "," <> gettext("Diva,Page,Keywords")
  def page_description(_, _), do: gettext "diva page title with %{name}", name: gettext("Site Name")

end
