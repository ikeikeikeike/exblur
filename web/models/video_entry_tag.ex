defmodule Exblur.VideoEntryTag do
  use Exblur.Web, :model
  alias Exblur.VideoEntryDiva, as: Model

  schema "video_entry_tags" do
    belongs_to :video_entry, Exblur.VideoEntry
    belongs_to :tag,         Exblur.Tag

    field :created_at,       Ecto.DateTime, default: Ecto.DateTime.utc
    field :updated_at,       Ecto.DateTime, default: Ecto.DateTime.utc
  end

  @required_fields ~w(video_entry_id tag_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def changeset(model, video_entry, diva) do
    model
    |> cast(%{video_entry_id: video_entry.id, tag_id: diva.id}, @required_fields, @optional_fields)
  end

end
