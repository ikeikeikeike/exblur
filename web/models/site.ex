defmodule Exblur.Site do
  use Exblur.Web, :model
  alias Exblur.Site

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

  defmodule Const do
    import Exblur.Macros.Attr
    attr :asg,             "asg.to"
    attr :ero_video,       "ero-video.net"
    attr :fc2,             "video.fc2.com"
    attr :japan_whores,    "jp.japan-whores.com"
    attr :pornhost,        "www.pornhost.com"
    attr :pornhub,         "jp.pornhub.com"
    attr :redtube,         "www.redtube.com"
    attr :tokyo_tube,      "www.tokyo-tube.com"
    attr :tokyo_porn_tube, "www.tokyo-porn-tube.com"
    attr :tube8,           "www.tube8.com"
    attr :xhamster,        "jp.xhamster.com"
    attr :xvideos,         "jp.xvideos.com"

    attr :domains, ~w(
      asg.to
      ero-video.net
      video.fc2.com
      jp.japan-whores.com
      www.pornhost.com
      jp.pornhub.com
      www.redtube.com
      www.tokyo-tube.com
      www.tokyo-porn-tube.com
      www.tube8.com
      jp.xhamster.com
      jp.xvideos.com
    )
  end

  def asg?(model),             do: model.name == Site.Const.asg
  def ero_video?(model),       do: model.name == Site.Const.ero_video
  def fc2?(model),             do: model.name == Site.Const.fc2
  def japan_whores?(model),    do: model.name == Site.Const.japan_whores
  def pornhost?(model),        do: model.name == Site.Const.pornhost
  def pornhub?(model),         do: model.name == Site.Const.pornhub
  def redtube?(model),         do: model.name == Site.Const.redtube
  def tokyo_tube?(model),      do: model.name == Site.Const.tokyo_tube
  def tokyo_porn_tube?(model), do: model.name == Site.Const.tokyo_porn_tube
  def tube8?(model),           do: model.name == Site.Const.tube8
  def xhamster?(model),        do: model.name == Site.Const.xhamster
  def xvideos?(model),         do: model.name == Site.Const.xvideos
  def whats_this?(model),      do: model.name

  defp gsub_domain(name), do: name |> String.replace("-", "_") |> String.replace("_", ".") 
  def select_domain(name) do
    {:ok, ptn} = Regex.compile gsub_domain(name)

    Enum.filter(Site.Const.domains, fn(domain) -> 
      Regex.match? ptn, gsub_domain(domain) 
    end) 
  end

  def video_creator_by_name(name) do
    video_creator "http://#{List.first(select_domain(name))}"
  end

  def video_creator(url) do

  end

end
