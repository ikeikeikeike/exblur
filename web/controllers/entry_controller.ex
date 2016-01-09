defmodule Exblur.EntryController do
  use Exblur.Web, :controller

  # alias Exblur.VideoEntry

  require Tirexs.Query

  plug :scrub_params, "video_entry" when action in [:create, :update]

  def index(conn, _params) do

    entries = Repo.all(Exblur.VideoEntry)

    ventries = 
      Es.Exblur.VideoEntry.do_search
      |> Tirexs.Query.result 

    render(conn, "index.html", entries: entries, ventries: ventries)
  end

  # def index(conn, _params) do
    # entries = Repo.all(Entry)
    # render(conn, "index.html", entries: entries)
  # end

  # def new(conn, _params) do
    # changeset = VideoEntry.changeset(%VideoEntry{})
    # render(conn, "new.html", changeset: changeset)
  # end

  # def create(conn, %{"entry" => entry_params}) do
    # changeset = VideoEntry.changeset(%VideoEntry{}, entry_params)

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
    # entry = Repo.get!(VideoEntry, id)
    # render(conn, "show.html", entry: entry)
  # end

  # def edit(conn, %{"id" => id}) do
    # entry = Repo.get!(VideoEntry, id)
    # changeset = VideoEntry.changeset(entry)
    # render(conn, "edit.html", entry: entry, changeset: changeset)
  # end

  # def update(conn, %{"id" => id, "entry" => entry_params}) do
    # entry = Repo.get!(VideoEntry, id)
    # changeset = VideoEntry.changeset(entry, entry_params)

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
    # entry = Repo.get!(VideoEntry, id)

    # # Here we use delete! (with a bang) because we expect
    # # it to always work (and if it does not, it will raise).
    # Repo.delete!(entry)

    # conn
    # |> put_flash(:info, "Entry deleted successfully.")
    # |> redirect(to: entry_path(conn, :index))
  # end
end
