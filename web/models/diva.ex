defmodule Exblur.Diva do
  use Exblur.Web, :model

  use Es
  use Es.Index
  use Es.Document

  alias Exblur.Diva, as: Model
  alias Imitation.Q

  es :model, Model

  schema "divas" do
    field :name,       :string
    field :kana,       :string
    field :romaji,     :string
    field :gyou,       :string

    field :height,     :integer
    field :weight,     :integer

    field :bust,       :integer
    field :bracup,     :string
    field :waste,      :integer
    field :hip,        :integer

    field :blood,      :string
    field :birthday,   Ecto.Date

    # TODO: To be arc file
    field :image,      :string

    field :created_at, Ecto.DateTime, default: Ecto.DateTime.utc
    field :updated_at, Ecto.DateTime, default: Ecto.DateTime.utc

    has_many :entry_divas, Exblur.EntryDiva
    has_many :entries, through: [:entry_divas, :entry]
  end

  @required_fields ~w(name kana romaji gyou image)
  @optional_fields ~w(height weight bust bracup waste hip blood birthday)
  @relational_fields ~w(entries)a

  after_insert :put_es_document
  after_update :put_es_document
  def put_es_document(changeset) do
    changeset.model
    |> Repo.preload(@relational_fields)
    |> put_document

    changeset
  end

  after_delete :delete_es_document
  def delete_es_document(changeset) do
    changeset.model
    |> Repo.preload(@relational_fields)
    |> delete_document

    changeset
  end

  def query do
    from e in Model,
     select: e,
    preload: ^@relational_fields
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def changeset_actress(model, actress) do
    params =
      actress
      |> Map.put("romaji", actress["oto"])
      |> Map.put("kana",   actress["yomi"])
      |> Map.put("image",  actress["thumb"])
      |> Enum.filter(&(elem(&1, 0) in @required_fields))
      |> Enum.into(%{})
      # for {key, val} <- actress, into: %{}, do: {String.to_atom(key), val}

    changeset(model, params)
  end

  def find_or_create_by_name(name) do
    query = from v in Model, where: v.name == ^name
    Q.find_or_create(query, changeset(%Model{}, %{name: name}))
  end

  def diva_creater(actress) do
    query = from v in Model, where: v.name == ^actress["name"]
    Q.find_or_create(query, changeset_actress(%Model{}, actress))
  end

  def search_data(model) do
    [
      _id: model.id,
      name: model.name,
      kana: model.kana,
      romaji: String.replace(model.romaji, "_", ""),
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
            multi_match word, ["romaji"]
            prefix "romaji", word
          end
        end
      end
    end

    ppquery(queries)
    |> Tirexs.Query.create_resource
  end

  def create_index(index \\ get_index) do
    Tirexs.DSL.define [type: "diva", index: index, number_of_shards: "5", number_of_replicas: "1"], fn(index, es_settings) ->
      settings do
        analysis do
          tokenizer "ngram_tokenizer", type: "nGram",  min_gram: "2", max_gram: "3", token_chars: ["letter", "digit"]
          analyzer  "default",         type: "custom", tokenizer: "ngram_tokenizer"
          analyzer  "ngram_analyzer",                  tokenizer: "ngram_tokenizer"
        end
      end
      |> ppquery

      {index, es_settings}
    end

    Tirexs.DSL.define [type: "diva", index: index], fn(index, es_settings) ->
      mappings do
        indexes "name",   type: "string", analyzer: "ngram_analyzer"
        indexes "kana",   type: "string", analyzer: "ngram_analyzer"
        indexes "romaji", type: "string", analyzer: "ngram_analyzer"
      end
      |> ppquery

      {index, es_settings}
    end

    :ok
  end

end
