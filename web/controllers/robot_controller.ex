defmodule Exblur.RobotController do
  use Exblur.Web, :controller

  def index(conn, _params) do
    host = Plug.Conn.get_req_header(conn, "host") |> List.first

    text conn, """
    Sitemap: http://#{host}/sitemap.xml.gz
    """
  end

end
