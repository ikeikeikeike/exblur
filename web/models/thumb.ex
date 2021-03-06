defmodule Exblur.Thumb do
  use Exblur.Web, :model
  use Arc.Ecto.Schema

  alias Exblur.{Thumb, ThumbUploader}

  require Logger

  schema "thumbs" do
    field :image, ThumbUploader.Type
    field :created_at, Ecto.DateTime, default: Ecto.DateTime.utc

    belongs_to :entry, Exblur.Entry
  end

  @required_fields ~w(entry_id)
  @optional_fields ~w()
  @attache_files ~w(image)

  def changeset(model, params \\  %{}) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> cast_attachments(params, @attache_files)
  end

  # fetch icon url
  def get_thumb(model), do: ThumbUploader.url {model.image, model}
  def get_thumb(model, version), do: ThumbUploader.url {model.image, model}, version

  def create_by_scrapy(entry, scrapy) do
    image =
      "#{Application.get_env(:exblur, :scrapy)[:endpoint]}#{scrapy["path"]}"
      |> Exblur.Plug.Upload.make_plug!

    params = %{"entry_id" => entry.id, "image" => image}
    case Repo.insert(changeset(%Thumb{}, params)) do
      {:error, reason} ->
        Logger.error("#{inspect reason}")
        {:error, reason}

      {_, model} ->
        {:ok, model}
    end
  end

end
