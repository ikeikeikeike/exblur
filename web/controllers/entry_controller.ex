defmodule Exblur.EntryController do
  use Exblur.Web, :controller
  alias Exblur.Entry, as: Model

  plug :scrub_params, "entry" when action in [:create, :update]


  def index(conn, %{"diva" => diva} = params) do
    # if diva param does not exists in database, throw `not found` exception.
    # Repo.get_by! Exblur.Diva, name: diva

    params =
      params
      |> Es.Params.prepare_params(1, 25)
      |> Map.put(:query, Model.query)

    entries =
      Model.search(diva != "" && diva || nil, params)
      |> Es.Paginator.paginate(params)

    render(conn, "index.html", entries: entries)
  end

  def index(conn, %{"tag" => tag} = params) do
    # if tag does not exists in database, throw `not found` exception.
    # Repo.get_by! Exblur.Tag, name: tag

    params =
      params
      |> Es.Params.prepare_params(1, 25)
      |> Map.put(:query, Model.query)

    entries =
      Model.search(tag != "" && tag || nil, params)
      |> Es.Paginator.paginate(params)

    render(conn, "index.html", entries: entries)
  end

  def index(conn, params) do
    params =
      params
      |> Es.Params.prepare_params(1, 25)
      |> Map.put(:query, Model.query)

    entries =
      Model.search(params[:search] != "" && params[:search] || nil, params)
      |> Es.Paginator.paginate(params)

    render(conn, "index.html", entries: entries)
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

end
