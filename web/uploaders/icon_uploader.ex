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
    {:convert, "-thumbnail 100x100^ -gravity center -extent 100x100 -format png"}
  end

  def __storage, do: Arc.Storage.Local

  def filename(version, {file, scope}) do
    "#{scope.id}_#{version}_#{file.file_name}"
  end

  def storage_dir(_version, {_file, scope}) do
    "uploads/avatars/#{scope.id}"
  end

  def default_url(_version, :thumb) do
    "https://placehold.it/100x100"
  end
end
