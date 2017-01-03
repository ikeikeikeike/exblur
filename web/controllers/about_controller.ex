defmodule Exblur.AboutController do
  use Exblur.Web, :controller

  plug Exblur.Ctrl.Plug.AssignTag
  plug Exblur.Ctrl.Plug.AssignDiva

  def index(conn, _params) do
    render conn, "index.html"
  end
end
