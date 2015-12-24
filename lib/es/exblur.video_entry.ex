defmodule Es.Exblur.VideoEntry do

  defmodule CreateIndex do
    import Tirexs.Mapping
    import Tirexs.Index.Settings

    @index_name "exblur_video_entreis"

    # require Tirexs.ElasticSearch
    # settings = Tirexs.ElasticSearch.config()
    # Tirexs.ElasticSearch.delete("exblur_video_entreis", settings)

    def put do

      Tirexs.DSL.define [type: "dsl", index: @index_name], fn(index, es_settings) ->
        settings do
          analysis do
            filter    "exblur_posfilter", type: "kuromoji_part_of_speech", stoptags: ["助詞-格助詞-一般", "助詞-終助詞"]

            tokenizer "exblur_tokenizer", type: "kuromoji_tokenizer"
            tokenizer "ngram_tokenizer",  type: "nGram", min_gram: "2", max_gram: "3", token_chars: ["letter", "digit"]

            analyzer  "default",          type: "custom", tokenizer: "exblur_tokenizer"
            analyzer  "exblur_analyzer",  type: "custom", tokenizer: "exblur_tokenizer", filter: ["kuromoji_baseform", "exblur_posfilter", "cjk_width"]
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

          indexes "title",          type: "string", analyzer: "exblur_analyzer"
          indexes "content",        type: "string", analyzer: "exblur_analyzer"

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
end
