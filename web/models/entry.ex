defmodule Exblur.Entry do
  use Exblur.Web, :model

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "entries" do

    field :posted, :boolean

    field :url, :string
    field :name, :string
    field :time, :integer
    field :title, :string
    field :content, :string
    field :embed_code, :string

    field :tags, {:array, :string}
    field :divas, {:array, :string}

    field :images, {:array, :map}
    field :image_urls, {:array, :string}

    # index({name: 1}, {name: "name_index", background: true})
  end

  @required_fields ~w()
  @optional_fields ~w(posted)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  # posted entry true.
  def already_post(model) do
    if ! model.posted do
      Mongo.update(changeset(model, %{posted: true}))
    end
  end

  def query do
    from e in Exblur.Entry,
    select: e
  end

  def asg(query) do
    from e in query,
    where: e.name == "asg"
  end

  def ero_video(query) do
    from e in query,
    where: e.name == "ero_video"
  end

  def fc2(query) do
    from e in query,
    where: e.name == "fc2"
  end

  def japan_whores(query) do
    from e in query,
    where: e.name == "japan_whores"
  end

  def pornhost(query) do
    from e in query,
    where: e.name == "pornhost"
  end

  def pornhub(query) do
    from e in query,
    where: e.name == "pornhub"
  end

  def redtube(query) do
    from e in query,
    where: e.name == "redtube"
  end

  def tokyo_tube(query) do
    from e in query,
    where: e.name == "tokyo_tube"
  end

  def tokyo_porn_tube(query) do
    from e in query,
    where: e.name == "tokyo_porn_tube"
  end

  def tube8(query) do
    from e in query,
    where: e.name == "tube8"
  end

  def xhamster(query) do
    from e in query,
    where: e.name == "xhamster"
  end

  def xvideos(query) do
    from e in query,
    where: e.name == "xvideos"
        or e.name == "jp_xvideos"
  end

  def released(query) do
    from e in query,
    where: e.posted == true
  end

  def reserved(query) do
    from e in query,
    where: e.posted == false
       and e.embed_code != ""
       and not(is_nil(e.embed_code))
  end

  def failed(query) do
    from e in query,
    where: e.posted == false
       and (is_nil(e.embed_code) or e.embed_code == "")
  end

end
