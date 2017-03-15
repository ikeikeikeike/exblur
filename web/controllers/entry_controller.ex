defmodule Exblur.EntryController do
  use Exblur.Web, :controller

  import Exblur.Checks, only: [blank?: 1]

  alias Exblur.{Entry, Diva, Ecto.Q}

  plug :scrub_params, "entry" when action in [:create, :update]
  plug Redisank.Plug.Access, [key: "id"] when action in [:show]
  plug Exblur.Ctrl.Plug.AssignTag
  plug Exblur.Ctrl.Plug.AssignDiva

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

    conn
    |> struct([params: Map.merge(%{"st" => "desc"}, params)])
    |> render("index.html", entries: pager, diva: Q.fuzzy_find(Diva, params["search"]))
  end

  def pickup(conn, params) do
    pager = esearch(params["search"], params, st: "pick")

    conn
    |> struct([params: Map.merge(%{"st" => "pick"}, params)])
    |> render("index.html", entries: pager, diva: Q.fuzzy_find(Diva, params["search"]))
  end

  def hottest(conn, params) do
    pager = esearch(params["search"], params, st: "hot")

    conn
    |> struct([params: Map.merge(%{"st" => "hot"}, params)])
    |> render("index.html", entries: pager, diva: Q.fuzzy_find(Diva, params["search"]))
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
    params = Map.merge(params, %{"search" => if(blank?(word), do: nil, else: word)})
    params =
      if length(opts) > 0 do
        Map.merge params, Enum.into(opts, %{})
      else
        params
      end

    query = Entry.published(Entry.query)
    none  =
      query
      |> Exblur.ESx.search(Entry.search(%{"search" => nil}))

    try do
      Exblur.ESx.search(query, Entry.search(params))
      |> Exblur.ESx.paginate(params)
    rescue _ ->
        Exblur.ESx.paginate none, params
    catch  _ ->
        Exblur.ESx.paginate none, params
    end
  end
end
