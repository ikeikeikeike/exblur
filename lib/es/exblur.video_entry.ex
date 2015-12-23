defmodule Es.Exblur.VideoEntry do

  defmodule IndexMapping do
    import Tirexs.Mapping
    require Tirexs.ElasticSearch

    settings = Tirexs.ElasticSearch.config(user: "new_user")
    Tirexs.ElasticSearch.delete("video_entreis", settings)

    Tirexs.DSL.define [type: "dsl", index: "video_entreis"], fn(index, _) ->
      mappings do
        indexes "id",             type: "long",   index: "not_analyzed", include_in_all: false
        indexes "url",            type: "string", index: "not_analyzed"

        indexes "site_name",      type: "string", index: "not_analyzed"
        indexes "server_title",   type: "string", index: "not_analyzed"
        indexes "server_domain",  type: "string", index: "not_analyzed"

        indexes "tags",           type: "string", index: "not_analyzed"
        indexes "divas",          type: "string", index: "not_analyzed"

        indexes "title",          type: "string", analyzer: "kuromoji_analyzer"
        indexes "content",        type: "string", analyzer: "kuromoji_analyzer"

        indexes "time",           type: "long"
        indexes "published_at",   type: "date",   format: "dateOptionalTime"

        indexes "review",         type: "boolean"
        indexes "publish",        type: "boolean"
        indexes "removal",        type: "boolean"
      end

      {index, settings}
    end
  end

  defmodule IndexSetting do
    import Tirexs.Index.Settings

    Tirexs.DSL.define [index: "dsl_settings"], fn(index, es_settings) ->
      settings do
        filter    "pos_filter",         [type: "kuromoji_part_of_speech", stoptags: ["助詞-格助詞-一般", "助詞-終助詞"]]

        tokenizer "kuromoji_tokenizer", [type: "kuromoji_tokenizer"]
        tokenizer "ngram_tokenizer",    [type: "nGram", min_gram: "2", max_gram: "3", token_chars: ["letter", "digit"]]

        analyzer  "default",            [type: "custom", tokenizer: "kuromoji_tokenizer"]
        analyzer  "kuromoji_analyzer",  [type: "custom", tokenizer: "kuromoji_tokenizer", filter: ["kuromoji_baseform", "pos_filter", "cjk_width"]]
        analyzer  "ngram_analyzer",     [                tokenizer: "ngram_tokenizer"]
      end

      {index, es_settings}
    end
  end

end
