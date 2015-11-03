defmodule Exblur.Site do
  use Exblur.Web, :model

  schema "sites" do
    field :name, :string
    field :url, :string
    field :rss, :string
    field :icon, :string
    field :last_modified, Ecto.DateTime

    field :created_at, Ecto.DateTime, default: Ecto.DateTime.local
    field :updated_at, Ecto.DateTime, default: Ecto.DateTime.local

    has_many :video_entries, Exblur.VideoEntry, on_delete: :fetch_and_delete
  end

  @required_fields ~w(name url rss icon last_modified)
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
