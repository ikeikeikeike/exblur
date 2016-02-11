defmodule Exblur.VideoEntryDiva do
  use Exblur.Web, :model
  alias Exblur.VideoEntryDiva, as: Model
  alias Imitation.Q

  schema "video_entry_divas" do
    belongs_to :video_entry, Exblur.VideoEntry
    belongs_to :diva,        Exblur.Diva

    field :created_at,       Ecto.DateTime, default: Ecto.DateTime.utc
    field :updated_at,       Ecto.DateTime, default: Ecto.DateTime.utc
  end

  @required_fields ~w(video_entry_id diva_id)
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def changeset(model, video_entry, diva) do
    params =
      %{video_entry_id: video_entry.id, diva_id: diva.id}

    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def find_or_create(entry, diva) do
    query =
      from v in Model,
      where: v.diva_id == ^diva.id
         and v.video_entry_id == ^entry.id

    Q.find_or_create(query, changeset(%Model{}, entry, diva))
  end

end
