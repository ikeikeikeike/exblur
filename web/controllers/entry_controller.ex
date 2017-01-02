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

  def latest(conn, params) do
    pager = esearch(params["search"], params)
    render(conn, "index.html", entries: pager, diva: Q.fuzzy_find(Diva, params["search"]))
  end

  def hottest(conn, params) do
    pager = esearch(params["search"], params, st: "hot")
    render(conn, "index.html", entries: pager, diva: Q.fuzzy_find(Diva, params["search"]))
  end

  def show(conn, %{"id" => id, "title" => title}) do
    pager = esearch(title, %{st: "match"}, page_size: 15)

    render(conn, "show.html", entry: Repo.get!(Entry.query, id), entries: pager)
  end

  def show(conn, %{"id" => id} = params) do
    pager = esearch(nil, params, page_size: 15)
    render(conn, "show.html", entry: Repo.get!(Entry.query, id), entries: pager)
  end

  defp esearch(word, params, opts \\ []) do
    params = Map.merge(params, %{"search" => word})
    params =
      if length(opts) > 0 do
        Map.merge params, Enum.into(opts, %{})
      else
        params
      end

    Entry.query
    |> Exblur.ESx.search(Entry.search(params))
    |> Exblur.ESx.paginate(params)
  end

end
