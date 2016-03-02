defmodule Exblur.Server do
  use Exblur.Web, :model

  schema "servers" do
    field :title, :string
    field :icon, :string
    field :domain, :string
    field :twitter_url, :string
    field :keywords, :string
    field :description, :string
    field :primary, :boolean, default: false

    field :created_at, Timex.Ecto.DateTimeWithTimezone, default: Timex.Date.now
    field :updated_at, Timex.Ecto.DateTimeWithTimezone, default: Timex.Date.now

    has_many :entries, Exblur.Entry, on_delete: :nilify_all
  end

  @required_fields ~w(title icon domain twitter_url keywords description primary)
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
