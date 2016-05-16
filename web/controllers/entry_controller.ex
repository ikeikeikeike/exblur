defmodule Exblur.EntryController do
  use Exblur.Web, :controller

  alias Exblur.Entry, as: Model
  alias Exblur.Diva

  plug :scrub_params, "entry" when action in [:create, :update]

  def index(conn, %{"diva" => diva} = params) do
    # if diva param does not exists in database, throw `not found` exception.
    # Repo.get_by! Exblur.Diva, name: diva
    es = esearch(diva, params)
    render(conn, "index.html", entries: es[:entries], diva: Diva.fuzzy_find(diva))
  end

  def index(conn, %{"tag" => tag} = params) do
    # if tag does not exists in database, throw `not found` exception.
    # Repo.get_by! Exblur.Tag, name: tag
    es = esearch(tag, params)
    render(conn, "index.html", entries: es[:entries], diva: Diva.fuzzy_find(tag))
  end

  def index(conn, params) do
    es = esearch(params["search"], params)
    render(conn, "index.html", entries: es[:entries], diva: Diva.fuzzy_find(conn.params["search"]))
  end

  def show(conn, %{"id" => id, "title" => title}) do
    params =
      %{}
      |> Es.Params.prepare_params(1, 15)
      |> Map.put(:query, Model.query)

    entries =
      Model.search(title, params)
      |> Es.Paginator.paginate(params)

    render(conn, "show.html", entry: Repo.get!(Model.query, id), entries: entries)
  end

  defp esearch(word, params) do
    params =
      params
      |> Es.Params.prepare_params(1, 35)
      |> Map.put(:query, Model.query)

    entries =
      Model.search(word != "" && word || nil, params)
      |> Es.Paginator.paginate(params)

    [entries: entries, params: params]
  end

end
