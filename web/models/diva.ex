defmodule Exblur.Diva do
  use Exblur.Web, :model

  schema "divas" do
    field :name,       :string
    field :kana,       :string
    field :romaji,     :string
    field :gyou,       :string

    field :height,     :integer
    field :weight,     :integer

    field :bust,       :integer
    field :bracup,     :string
    field :waste,      :integer
    field :hip,        :integer

    field :blood,      :string
    field :birthday,   Ecto.Date

    field :image,      :string

    field :created_at, Ecto.DateTime, default: Ecto.DateTime.utc
    field :updated_at, Ecto.DateTime, default: Ecto.DateTime.utc

    has_many :video_entry_divas, Exblur.VideoEntryDiva
    has_many :video_entries, through: [:video_entry_divas, :video_entries]
  end

  @required_fields ~w(name kana romaji gyou height weight bust bracup waste hip blood birthday image)
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
