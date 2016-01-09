defmodule Exblur.VideoEntryDiva do
  use Exblur.Web, :model

  schema "video_entry_divas" do
    belongs_to :video_entry, Exblur.VideoEntry
    belongs_to :diva,        Exblur.Diva

    field :created_at,      Ecto.DateTime, default: Ecto.DateTime.utc
    field :updated_at,      Ecto.DateTime, default: Ecto.DateTime.utc
  end

  @required_fields ~w()
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

end
