defmodule Exblur.Thumb do
  use Exblur.Web, :model
  use Arc.Ecto.Model

  alias Exblur.Thumb, as: Model
  alias Exblur.ThumbUploader

  require Logger

  schema "thumbs" do
    field :image, ThumbUploader.Type
    field :created_at, Ecto.DateTime, default: Ecto.DateTime.utc

    belongs_to :video_entry, Exblur.VideoEntry
  end

  @required_fields ~w(video_entry_id)
  @optional_fields ~w()

  @required_file_fields ~w(image)
  @optional_file_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> cast_attachments(params, @required_file_fields, @optional_file_fields)
  end

  # fetch icon url
  def get_thumb(model), do: ThumbUploader.url {model.image, model}
  def get_thumb(model, version), do: ThumbUploader.url {model.image, model}, version

  def create_by_scrapy(video_entry, scrapy) do
    image =
      "#{Application.get_env(:exblur, :scrapy)[:endpoint]}#{scrapy["path"]}"
      |> Plug.Exblur.Upload.make_plug!

    params = %{"video_entry_id" => video_entry.id, "image" => image}
    case Repo.insert(changeset(%Model{}, params)) do
      {:error, reason} ->
        Logger.error("#{inspect reason}")
        {:error, reason}

      {_, model} ->
        {:ok, model}
    end
  end

end