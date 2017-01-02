defmodule Exblur.Ctrl.Plug.AssignDiva do
  import Plug.Conn
  import Ecto.Query, only: [from: 2]

  alias Exblur.{Diva, Repo}

  def init(opts), do: opts
  def call(conn, _opts) do
    divas =
      ConCache.get_or_store :diva, "assign_diva:2000", fn ->
        queryable =
          from q in Diva,
            where: q.appeared > 0,
            order_by: [desc: q.appeared],
            limit: 2000

        Repo.all queryable
      end

    conn
    |> assign(:top_divas, divas)
  end
end
