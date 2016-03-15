defmodule Exblur.Tag do
  use Exblur.Web, :model

  use Es
  use Es.Index
  use Es.Document

  alias Exblur.Tag, as: Model
  alias Imitation.Q

  es :model, Model

  schema "tags" do
    field :name,   :string
    field :kana,   :string
    field :romaji, :string
    field :gyou,   :string
    field :orig,   :string

    field :created_at, Ecto.DateTime, default: Ecto.DateTime.utc
    field :updated_at, Ecto.DateTime, default: Ecto.DateTime.utc

    has_many :entry_tags, Exblur.EntryTag
    has_many :entries, through: [:entry_tags, :entry]
  end

  @required_fields ~w(name)
  @optional_fields ~w(kana romaji gyou orig)
  @relational_fields ~w(entries)a

  def query do
    from e in Model,
     select: e,
    preload: ^@relational_fields
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def find_or_create_by_name(name) do
    query = from v in Model, where: v.name == ^name
    Q.find_or_create(query, changeset(%Model{}, %{name: name}))
  end

  def search_data(model) do
    [
      _id: model.id,
      name: model.name,
      kana: model.kana,
      orig: model.orig,
      romaji: model.romaji,
    ]
  end

  def search(word) do
    queries = Tirexs.Search.search [index: get_index, from: 0, size: 5, fields: []] do
      query do
        dis_max do
          queries do
            multi_match word, ["name"]
            prefix "name", word
            multi_match word, ["kana"]
            prefix "kana", word
            multi_match word, ["orig"]
            prefix "orig", word
            multi_match word, ["romaji"]
            prefix "romaji", word
          end
        end
      end
    end

    queries
    |> ppquery
    |> Tirexs.Query.create_resource
  end

  def create_index(index \\ get_index) do
    Tirexs.DSL.define [type: "tag", index: index, number_of_shards: "5", number_of_replicas: "1"], fn(index, es_settings) ->
      settings do
        analysis do
          tokenizer "ngram_tokenizer", type: "nGram",  min_gram: "2", max_gram: "3", token_chars: ["letter", "digit"]
          analyzer  "ngram_analyzer",  tokenizer: "ngram_tokenizer"
        end
      end
      |> ppquery

      {index, es_settings}
    end

    Tirexs.DSL.define [type: "tag", index: index], fn(index, es_settings) ->
      mappings do
        indexes "name",   [type: "string", fields: [raw:      [type: "string", index: "not_analyzed"],
                                                    tokenzed: [type: "string", index: "analyzed",     analyzer: "ngram_analyzer"]]]
        indexes "kana",   [type: "string", fields: [raw:      [type: "string", index: "not_analyzed"],
                                                    tokenzed: [type: "string", index: "analyzed",     analyzer: "ngram_analyzer"]]]
        indexes "orig",   [type: "string", fields: [raw:      [type: "string", index: "not_analyzed"],
                                                    tokenzed: [type: "string", index: "analyzed",     analyzer: "ngram_analyzer"]]]
        indexes "romaji", [type: "string", fields: [raw:      [type: "string", index: "not_analyzed"],
                                                    tokenzed: [type: "string", index: "analyzed",     analyzer: "ngram_analyzer"]]]
      end
      |> ppquery

      {index, es_settings}
    end

    :ok
  end

end
