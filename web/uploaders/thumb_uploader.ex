defmodule Exblur.ThumbUploader do
  use Arc.Definition
  use Arc.Ecto.Definition

  @versions [:original, :size_100x66, :size_200x132, :size_300x200]
  @extension_whitelist ~w(.jpg .jpeg .gif .png .ico .bmp)

  def acl(:thumb, _), do: :public_read

  def validate({file, _}) do
    file_extension = file.file_name |> Path.extname |> String.downcase
    Enum.member?(@extension_whitelist, file_extension)
  end

  def transform(:size_100x66, _) do
    {:convert, "-thumbnail 100x66^ -gravity center -extent 100x66"}
  end

  def transform(:size_200x132, _) do
    {:convert, "-thumbnail 200x132^ -gravity center -extent 200x132"}
  end

  def transform(:size_300x200, _) do
    {:convert, "-thumbnail 300x200^ -gravity center -extent 300x200"}
  end

  def s3_object_headers(_version, {file, _scope}) do
    [content_type: Plug.MIME.path(file.file_name)] # for "image.png", would produce: "image/png"
  end

  # def __storage, do: Arc.Storage.Local
  # def __storage, do: Arc.Storage.S3

  def filename(version, {file, scope}) do
    "#{scope.entry_id}_#{version}_#{file.file_name}"
  end

  def storage_dir(_version, {_file, model}) do
    dirname =
      model.__struct__
      |> String.Chars.to_string
      |> String.downcase
      |> String.split(".")
      |> List.last

    "uploads/#{dirname}/#{model.entry_id}"
  end

  def default_url(:original) do
    "https://placehold.it/300x200"
  end

  def default_url(:size_100x66) do
    "https://placehold.it/100x66"
  end

  def default_url(:size_200x132) do
    "https://placehold.it/200x132"
  end

  def default_url(:size_300x200) do
    "https://placehold.it/300x200"
  end

end
