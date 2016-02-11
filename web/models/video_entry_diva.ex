defmodule Exblur.VideoEntryDiva do
  use Exblur.Web, :model
  alias Exblur.VideoEntryDiva, as: Model

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
    model
    |> cast(%{video_entry_id: video_entry.id, diva_id: diva.id}, @required_fields, @optional_fields)
  end

end
