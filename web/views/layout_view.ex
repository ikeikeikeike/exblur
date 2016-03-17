defmodule Exblur.LayoutView do
  use Exblur.Web, :view
  import Exblur.WebView

  def page_title(conn, assigns) do
    try do
      apply(view_module(conn), :page_title, [action_name(conn), assigns])
    rescue
      UndefinedFunctionError -> default_page_title(conn, assigns)
    end
  end

  def default_page_title(_conn, _assigns) do
    gettext "Default Page Title"
  end

end

