defmodule Exblur.VideoEntryTag do
  use Exblur.Web, :model
  alias Exblur.VideoEntryTag, as: Model
  alias Imitation.Q

  schema "video_entry_tags" do
    belongs_to :video_entry, Exblur.VideoEntry
    belongs_to :tag,         Exblur.Tag

    field :created_at,       Ecto.DateTime, default: Ecto.DateTime.utc
    field :updated_at,       Ecto.DateTime, default: Ecto.DateTime.utc
  end

  @required_fields ~w(video_entry_id tag_id)
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def changeset(model, video_entry, tag) do
    params =
      %{video_entry_id: video_entry.id, tag_id: tag.id}

    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def find_or_create(entry, tag) do
    query =
      from v in Model,
      where: v.tag_id == ^tag.id
         and v.video_entry_id == ^entry.id

    Q.find_or_create(query, changeset(%Model{}, entry, tag))
  end


end
