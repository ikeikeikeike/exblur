defmodule Exblur.Tag do
  use Exblur.Web, :model
  use ESx.Schema

  alias Exblur.{ESx, Tag}
  alias Exblur.Imitation.Q

  schema "tags" do
    field :name,   :string
    field :kana,   :string
    field :romaji, :string
    field :gyou,   :string
    field :orig,   :string

    timestamps([{:inserted_at, :created_at}])

    has_many :entry_tags, Exblur.EntryTag
    has_many :entries, through: [:entry_tags, :entry]
  end

  index_name "es_tag"
  document_type "tag"

  mapping _all: [enabled: false] do
    indexes "name",
      type: "string",
      analyzer: "ngram_analyzer"
    indexes "kana",
      type: "string",
      analyzer: "ngram_analyzer"
    indexes "orig",
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
  @optional_fields ~w(kana romaji gyou orig updated_at)
  @relational_fields ~w(entries)a

  def as_indexed_json(model, _opts) do
    %{
      name: model.name,
      kana: model.kana,
      orig: model.orig,
      romaji: model.romaji,
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
              fields: ~w(name kana orig romaji)
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
    from e in Tag,
     select: e,
    preload: ^@relational_fields
  end

  def changeset(model, params \\  %{}) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def find_or_create_by_name(name) do
    query = from v in Tag, where: v.name == ^name
    Q.find_or_create(query, changeset(%Tag{}, %{name: name}))
  end

end
