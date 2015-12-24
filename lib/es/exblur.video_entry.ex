defmodule Es.Exblur.VideoEntry do
  import Tirexs.Bulk
  import Tirexs.Mapping
  import Tirexs.Index.Settings

  require Tirexs.ElasticSearch

  @index_name "exblur_video_entreis"

  def put_document(models) when is_list(models) do
    Enum.each models, &put_document(&1)
  end

  def put_document(model) do
    settings = Tirexs.ElasticSearch.config()

    types = model.__struct__.__changeset__

    Tirexs.Bulk.store [index: @index_name, refresh: true], settings do
      create id: 1, title: "One",   tags: ["elixir"],         type: "article"
      create id: 2, title: "Two",   tags: ["elixir", "ruby"], type: "article"
      create id: 3, title: "Three", tags: ["java"],           type: "article"
      create id: 4, title: "Four",  tags: ["erlang"],         type: "article"
    end
  end

  # settings = Tirexs.ElasticSearch.config()
  # Tirexs.ElasticSearch.delete("exblur_video_entreis", settings)

  def create_index do

    Tirexs.DSL.define [type: "dsl", index: @index_name], fn(index, es_settings) ->
      settings do
        analysis do
          filter    "ja_posfilter",     type: "kuromoji_part_of_speech", stoptags: ["助詞-格助詞-一般", "助詞-終助詞"]

          tokenizer "ja_tokenizer",     type: "kuromoji_tokenizer"
          tokenizer "ngram_tokenizer",  type: "nGram",  min_gram: "2", max_gram: "3", token_chars: ["letter", "digit"]

          analyzer  "default",          type: "custom", tokenizer: "ja_tokenizer"
          analyzer  "ja_analyzer",      type: "custom", tokenizer: "ja_tokenizer", filter: ["kuromoji_baseform", "ja_posfilter", "cjk_width"]
          analyzer  "ngram_analyzer",                   tokenizer: "ngram_tokenizer"
        end
      end

      {index, es_settings}
    end

    Tirexs.DSL.define [type: "dsl", index: @index_name], fn(index, es_settings) ->
      mappings do
        indexes "id",             type: "long",   index: "not_analyzed", include_in_all: false
        indexes "url",            type: "string", index: "not_analyzed"

        indexes "site_name",      type: "string", index: "not_analyzed"
        indexes "server_title",   type: "string", index: "not_analyzed"
        indexes "server_domain",  type: "string", index: "not_analyzed"

        indexes "tags",           type: "string", index: "not_analyzed"
        indexes "divas",          type: "string", index: "not_analyzed"

        indexes "title",          type: "string", analyzer: "ja_analyzer"
        indexes "content",        type: "string", analyzer: "ja_analyzer"

        indexes "time",           type: "long"
        indexes "published_at",   type: "date",   format: "dateOptionalTime"

        indexes "review",         type: "boolean"
        indexes "publish",        type: "boolean"
        indexes "removal",        type: "boolean"
      end

      {index, es_settings}
    end

  end
end
