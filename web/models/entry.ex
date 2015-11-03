defmodule Exblur.Entry do
  # use Ecto.Model
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

end
