defmodule Exblur.EntryController do
  use Exblur.Web, :controller

  alias Exblur.{Entry, Diva, Ecto.Q}

  plug :scrub_params, "entry" when action in [:create, :update]
  plug Redisank.Plug.Access, [key: "id"] when action in [:show]

  def index(conn, %{"diva" => diva} = params) do
    # if diva param does not exists in database, throw `not found` exception.
    # Repo.get_by! Exblur.Diva, name: diva
    pager = esearch(diva, params)
    render(conn, "index.html", entries: pager, diva: Q.fuzzy_find(Diva, diva))
  end

  def index(conn, %{"tag" => tag} = params) do
    # if tag does not exists in database, throw `not found` exception.
    # Repo.get_by! Exblur.Tag, name: tag
    pager = esearch(tag, params)
    render(conn, "index.html", entries: pager, diva: Q.fuzzy_find(Diva, tag))
  end

  def index(conn, params) do
    pager = esearch(params["search"], params)
    render(conn, "index.html", entries: pager, diva: Q.fuzzy_find(Diva, params["search"]))
  end

  def hottest(conn, params) do
    pager = esearch(params["search"], params)
    render(conn, "index.html", entries: pager, diva: Q.fuzzy_find(Diva, params["search"]))
  end

  def show(conn, %{"id" => id, "title" => title}) do
    params =
      %{}
      |> Es.Params.prepare_params(1, 15)
      |> Map.put(:query, Entry.query)
      |> Map.put(:st, "match")

    entries =
      Entry.search(title, params)
      |> Es.Paginator.paginate(params)

    render(conn, "show.html", entry: Repo.get!(Entry.query, id), entries: entries)
  end

  def show(conn, %{"id" => id} = params) do
    pager = esearch(nil, params, 15)
    render(conn, "show.html", entry: Repo.get!(Entry.query, id), entries: pager)
  end

  defp esearch(word, params, limit \\ nil) do
    params = Map.merge(params, %{search: word})
    params =
      if limit do
        Map.merge(params, %{page_size: limit})
      else
        params
      end

    Entry.query
    |> Exblur.ESx.search(Entry.search(params))
    |> Exblur.ESx.paginate(params)
  end

end
