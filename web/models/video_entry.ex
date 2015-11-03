defmodule Exblur.VideoEntry do
  use Exblur.Web, :model

  schema "video_entries" do
    field :url, :string
    field :title, :string
    field :content, :string
    field :embed_code, :string
    field :time, :integer
    field :published_at, Ecto.DateTime
    field :review, :boolean, default: false
    field :publish, :boolean, default: false
    field :removal, :boolean, default: false

    field :created_at, Ecto.DateTime, default: Ecto.DateTime.local
    field :updated_at, Ecto.DateTime, default: Ecto.DateTime.local

    belongs_to :site, Exblur.Site
    belongs_to :server, Exblur.Server
  end

  @required_fields ~w(url title content embed_code time published_at review publish removal)
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
