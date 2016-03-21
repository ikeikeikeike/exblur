defmodule Exblur.IconUploader do
  use Arc.Definition
  use Arc.Ecto.Definition

  @versions [:original, :thumb]
  @extension_whitelist ~w(.jpg .jpeg .gif .png .ico .bmp)

  def acl(:thumb, _), do: :public_read

  def validate({file, _}) do
    file_extension = file.file_name |> Path.extname |> String.downcase
    Enum.member?(@extension_whitelist, file_extension)
  end

  def transform(:thumb, _) do
    {:convert, "-thumbnail 100x100^ -gravity center -extent 100x100"}
  end

  def s3_object_headers(_version, {file, _scope}) do
    [content_type: Plug.MIME.path(file.file_name)] # for "image.png", would produce: "image/png"
  end

  def __storage, do: Arc.Storage.S3

  def filename(version, {file, scope}) do
    "#{scope.id}_#{version}_#{file.file_name}"
  end

  def storage_dir(_version, {_file, model}) do
    dirname =
      model.__struct__
      |> String.Chars.to_string
      |> String.downcase
      |> String.split(".")
      |> List.last

    "uploads/#{dirname}/#{model.id}"
  end

  def default_url(:original) do
    "https://placehold.it/100x100"
  end

  def default_url(:thumb) do
    "https://placehold.it/100x100"
  end
end
