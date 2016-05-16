defmodule Exblur.Diva do
  use Exblur.Web, :model
  use Arc.Ecto.Model

  use Es
  use Es.Index
  use Es.Document

  alias Exblur.Diva, as: Model
  alias Exblur.DivaUploader
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
    field :waste,      :integer  # waist
    field :hip,        :integer

    field :blood,      :string
    field :birthday,   Ecto.Date

    field :image,      DivaUploader.Type

    field :appeared,   :integer

    timestamps([{:inserted_at, :created_at}])

    has_many :entry_divas, Exblur.EntryDiva
    has_many :entries, through: [:entry_divas, :entry]
  end

  @required_fields ~w(name)
  @optional_fields ~w(kana romaji gyou height weight bust bracup waste hip blood birthday appeared)
  @relational_fields ~w(entries)a
  @actress_fields ~w(name kana romaji gyou)

  @required_file_fields ~w()
  @optional_file_fields ~w(image)

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
            |> Plug.Exblur.Upload.make_plug!

          Map.put(params, "image",  image)
        catch
          _ -> params
        end
    end

    changeset(model, Enum.into(params, %{}))
  end

  def find_or_create_by_name(name) do
    query = from v in Model, where: v.name == ^name
    Q.find_or_create(query, changeset(%Model{}, %{name: name}))
  end

  def diva_creater(actress) do
    query = from v in Model, where: v.name == ^actress["name"]
    Q.find_or_create(query, changeset_actress(%Model{}, actress))
  end

  # fetch icon url
  def get_thumb(model), do: DivaUploader.url {model.image, model}
  def get_thumb(model, version), do: DivaUploader.url {model.image, model}, version

  def fuzzy_find(name) when is_nil(name), do: fuzzy_find([])
  def fuzzy_find(name) when is_bitstring(name) do
    case String.split(name, ~r(、|（|）)) do
      names when length(names) == 1 ->
        diva = Repo.get_by(__MODULE__, name: List.first(names))
        if diva, do: diva, else: fuzzy_find names

      names when length(names)  > 1 ->
        fuzzy_find names

      _ -> nil
    end
  end
  def fuzzy_find([]), do: nil
  def fuzzy_find([name|tail]) do
    case Blank.blank?(name) do
      true  -> fuzzy_find(tail)
      false ->
        query =
          from p in __MODULE__,
          where: ilike(p.name, ^"%#{name}%"),
          limit: 1

        fuzzy_find([], Repo.one(query))
    end
  end
  def fuzzy_find([], diva), do: diva

  def search_data(model) do
    [
      _type: "diva",
      _id: model.id,
      name: model.name,
      kana: model.kana,
      romaji: (if model.romaji, do: String.replace(model.romaji, "_", ""))
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
    Tirexs.DSL.define [type: "diva", index: index], fn(index, es_settings) ->
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
