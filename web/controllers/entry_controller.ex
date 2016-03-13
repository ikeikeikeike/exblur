defmodule Exblur.EntryController do
  use Exblur.Web, :controller
  alias Exblur.Entry, as: Model

  plug :scrub_params, "entry" when action in [:create, :update]


  def index(conn, %{"diva" => diva} = params) do
    # if diva param does not exists in database, throw `not found` exception.
    # Repo.get_by! Exblur.Diva, name: diva

    params =
      params
      |> Es.Params.prepare_params(1, 10)
      |> Map.put(:query, Model.query)

    entries =
      Es.Entry.search(diva != "" && diva || nil, params)
      |> Es.Paginator.paginate(params)

    render(conn, "index.html", entries: entries)
  end

  def index(conn, %{"tag" => tag} = params) do
    # if tag does not exists in database, throw `not found` exception.
    Repo.get_by! Exblur.Tag, name: tag

    params =
      params
      |> Es.Params.prepare_params(1, 10)
      |> Map.put(:query, Model.query)

    entries =
      Es.Entry.search(tag != "" && tag || nil, params)
      |> Es.Paginator.paginate(params)

    render(conn, "index.html", entries: entries)
  end

  def index(conn, params) do
    params =
      params
      |> Es.Params.prepare_params(1, 10)
      |> Map.put(:query, Model.query)

    entries =
      Es.Entry.search(params[:search] != "" && params[:search] || nil, params)
      |> Es.Paginator.paginate(params)

    render(conn, "index.html", entries: entries)
  end

  def show(conn, %{"id" => id, "title" => title}) do
    params =
      %{}
      |> Es.Params.prepare_params(1, 15)
      |> Map.put(:query, Model.query)

    entries =
      Es.Entry.search(title, params)
      |> Es.Paginator.paginate(params)

    render(conn, "show.html", entry: Repo.get!(Model.query, id), related_entries: entries)
  end

  # def index(conn, _params) do
    # entries = Repo.all(Entry)
    # render(conn, "index.html", entries: entries)
  # end

  # def new(conn, _params) do
    # changeset = Entry.changeset(%Entry{})
    # render(conn, "new.html", changeset: changeset)
  # end

  # def create(conn, %{"entry" => entry_params}) do
    # changeset = Entry.changeset(%Entry{}, entry_params)

    # case Repo.insert(changeset) do
      # {:ok, _entry} ->
        # conn
        # |> put_flash(:info, "Entry created successfully.")
        # |> redirect(to: entry_path(conn, :index))
      # {:error, changeset} ->
        # render(conn, "new.html", changeset: changeset)
    # end
  # end

  # def show(conn, %{"id" => id}) do
    # entry = Repo.get!(Entry, id)
    # render(conn, "show.html", entry: entry)
  # end

  # def edit(conn, %{"id" => id}) do
    # entry = Repo.get!(Entry, id)
    # changeset = Entry.changeset(entry)
    # render(conn, "edit.html", entry: entry, changeset: changeset)
  # end

  # def update(conn, %{"id" => id, "entry" => entry_params}) do
    # entry = Repo.get!(Entry, id)
    # changeset = Entry.changeset(entry, entry_params)

    # case Repo.update(changeset) do
      # {:ok, entry} ->
        # conn
        # |> put_flash(:info, "Entry updated successfully.")
        # |> redirect(to: entry_path(conn, :show, entry))
      # {:error, changeset} ->
        # render(conn, "edit.html", entry: entry, changeset: changeset)
    # end
  # end

  # def delete(conn, %{"id" => id}) do
    # entry = Repo.get!(Entry, id)

    # # Here we use delete! (with a bang) because we expect
    # # it to always work (and if it does not, it will raise).
    # Repo.delete!(entry)

    # conn
    # |> put_flash(:info, "Entry deleted successfully.")
    # |> redirect(to: entry_path(conn, :index))
  # end
end
