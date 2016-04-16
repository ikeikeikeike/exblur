defmodule Exblur.Diva.BirthdayView do
  use Exblur.Web, :view
  import Exblur.WebView

  def page_title(_, _), do: gettext("All Divas") <> " - " <> gettext("Default Page Title")
  def page_keywords(_, _), do: gettext("Default,Page,Keywords") <> "," <> gettext("Diva,Page,Keywords")
  def page_description(_, _), do: gettext "Diva Page Description"

end
