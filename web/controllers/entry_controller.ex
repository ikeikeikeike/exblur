defmodule Exblur.EntryController do
  use Exblur.Web, :controller

  alias Exblur.Entry, as: Model
  alias Exblur.Diva
  alias Exblur.Ecto.Q, as: Q

  plug :scrub_params, "entry" when action in [:create, :update]
  plug Redisank.Plug.Access, [key: "id"] when action in [:show]

  def index(conn, %{"diva" => diva} = params) do
    # if diva param does not exists in database, throw `not found` exception.
    # Repo.get_by! Exblur.Diva, name: diva
    es = esearch(diva, params)
    render(conn, "index.html", entries: es[:entries], diva: Q.fuzzy_find(Diva, diva))
  end

  def index(conn, %{"tag" => tag} = params) do
    # if tag does not exists in database, throw `not found` exception.
    # Repo.get_by! Exblur.Tag, name: tag
    es = esearch(tag, params)
    render(conn, "index.html", entries: es[:entries], diva: Q.fuzzy_find(Diva, tag))
  end

  def index(conn, params) do
    es = esearch(params["search"], params)
    render(conn, "index.html", entries: es[:entries], diva: Q.fuzzy_find(Diva, params["search"]))
  end

  def hottest(conn, params) do
    es = esearch(params["search"], params)
    render(conn, "index.html", entries: es[:entries], diva: Q.fuzzy_find(Diva, params["search"]))
  end

  def show(conn, %{"id" => id, "title" => title}) do
    params =
      %{}
      |> Es.Params.prepare_params(1, 15)
      |> Map.put(:query, Model.query)
      |> Map.put(:st, "match")

    entries =
      Model.search(title, params)
      |> Es.Paginator.paginate(params)

    render(conn, "show.html", entry: Repo.get!(Model.query, id), entries: entries)
  end

  def show(conn, %{"id" => id} = params) do
    es = esearch(nil, params, 15)
    render(conn, "show.html", entry: Repo.get!(Model.query, id), entries: es[:entries])
  end

  defp esearch(word, params, limit \\ 35) do
    params =
      params
      |> Es.Params.prepare_params(1, limit)
      |> Map.put(:query, Model.query)

    entries =
      Model.search(word != "" && word || nil, params)
      |> Es.Paginator.paginate(params)

    [entries: entries, params: params]
  end

end
