defmodule Exblur.ReportController do
  use Exblur.Web, :controller

  alias Exblur.Redis.{Like, Broken}

  def like(conn, %{"id" => id}) do
    Like.add "exblur_like:#{id}", seskey(conn)

    json conn, %{"message" => "ok"}
  end

  def broken(conn, %{"id" => id}) do
    Broken.add "exblur_broken:#{id}", seskey(conn)

    json conn, %{"message" => "ok"}
  end

  defp seskey(conn) do
    conn.cookies[Application.get_env(:exblur, :seskey)]
  end

end
