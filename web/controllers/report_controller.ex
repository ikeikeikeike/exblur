defmodule Exblur.ReportController do
  use Exblur.Web, :controller

  alias Exblur.Redis.{Like, Broken}

  def like(conn, %{"id" => id}) do
    Like.store id, seskey(conn)

    json conn, %{"message" => "ok"}
  end

  def broken(conn, %{"id" => id}) do
    Broken.store id, seskey(conn)

    json conn, %{"message" => "ok"}
  end

  defp seskey(conn) do
    conn.cookies[Application.get_env(:exblur, :seskey)]
  end

end
