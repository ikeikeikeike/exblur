defmodule Exblur.Diva do
  use Exblur.Web, :model
  use Arc.Ecto.Schema

  use ESx.Schema

  alias Exblur.{ESx, Diva, DivaUploader}
  alias Exblur.Imitation.Q

  schema "divas" do
    field :name,       :string
    field :kana,       :string
    field :romaji,     :string
    field :gyou,       :string

    field :height,     :integer
    field :weight,     :integer

    field :bust,       :integer
    field :bracup,     :string
    field :waste,      :integer  # waist
    field :hip,        :integer

    field :blood,      :string
    field :birthday,   Ecto.Date
    field :age,        :integer, virtual: true

    field :image,      DivaUploader.Type

    field :appeared,   :integer

    timestamps([{:inserted_at, :created_at}])

    has_many :entry_divas, Exblur.EntryDiva
    has_many :entries, through: [:entry_divas, :entry]
  end

  index_name "es_diva"
  document_type "diva"

  mapping _all: [enabled: false] do
    indexes "name",
      type: "string",
      analyzer: "ngram_analyzer"
    indexes "kana",
      type: "string",
      analyzer: "ngram_analyzer"
    indexes "romaji",
      type: "string",
      analyzer: "ngram_analyzer"
  end

  settings do
    analysis do
      tokenizer "ngram_tokenizer",
        type: "nGram",
        min_gram: "2", max_gram: "3",
        token_chars: ["letter", "digit"]
      analyzer"default",
        type: "custom",
        tokenizer: "ngram_tokenizer"
      analyzer"ngram_analyzer",
        tokenizer: "ngram_tokenizer"
    end
  end

  @required_fields ~w(name)
  @optional_fields ~w(kana romaji gyou height weight bust bracup waste hip blood birthday appeared)
  @relational_fields ~w(entries)a
  @actress_fields ~w(name kana romaji gyou)

  @required_file_fields ~w()
  @optional_file_fields ~w(image)

  def as_indexed_json(model, _opts) do
    %{
      name: model.name,
      kana: model.kana,
      romaji: (if model.romaji, do: String.replace(model.romaji, "_", ""))
    }
  end

  def esreindex do
    ESx.reindex __MODULE__
  end

  def essuggest(word) do
    %{
      size: 5,
      fields: [],
      query: %{
        filtered: %{
          query: %{
            multi_match: %{
              query: word,
              fields: ~w(name kana romaji)
            },
            # prefix: %{}
          },
          filter: %{},
        }
      }
    }
  end

  def put_es_document(model) do
    model
    |> Repo.preload(@relational_fields)
    |> ESx.index_document
  end

  def delete_es_document(model) do
    model
    |> Repo.preload(@relational_fields)
    |> ESx.delete_document
  end

  def query do
    from e in Diva,
     select: e,
    preload: ^@relational_fields
  end

  def changeset(model, params \\  %{}) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> cast_attachments(params, @required_file_fields, @optional_file_fields)
  end

  def changeset_actress(model, actress) do
    params =
      actress
      |> Map.put("kana",   actress["yomi"])
      |> Map.put("romaji", actress["oto"])
      |> Map.put("image",  actress["thumb"])
      |> Enum.filter(&(elem(&1, 0) in @actress_fields))
      |> Enum.into(%{})
      # for {key, val} <- actress, into: %{}, do: {String.to_atom(key), val}

    changeset(model, params)
  end

  def changeset_profile(model, profile) do
    params =
      profile
      |> Map.put("kana",     profile["Kana"])
      |> Map.put("romaji",   profile["Romaji"])
      |> Map.put("gyou",     profile["Gyou"])
      |> Map.put("height",   profile["Height"])
      |> Map.put("weight",   profile["Weight"])
      |> Map.put("bust",     profile["Bust"])
      |> Map.put("bracup",   profile["Bracup"])
      |> Map.put("waste",    profile["Waste"])
      |> Map.put("hip",      profile["Hip"])
      |> Map.put("blood",    profile["Blood"])
      |> Map.put("birthday", profile["Birthday"])

    if profile["Icon"] && profile["Icon"]["Src"] do
      params =
        try do
          image =
            profile["Icon"]["Src"]
            |> Exblur.Plug.Upload.make_plug!

          Map.put(params, "image",  image)
        catch
          _ -> params
        end
    end

    changeset(model, Enum.into(params, %{}))
  end

  def find_or_create_by_name(name) do
    query = from v in Diva, where: v.name == ^name
    Q.find_or_create(query, changeset(%Diva{}, %{name: name}))
  end

  def diva_creater(actress) do
    query = from v in Diva, where: v.name == ^actress["name"]
    Q.find_or_create(query, changeset_actress(%Diva{}, actress))
  end

  # fetch icon url
  def get_thumb(model), do: DivaUploader.url {model.image, model}
  def get_thumb(model, version), do: DivaUploader.url {model.image, model}, version

end
