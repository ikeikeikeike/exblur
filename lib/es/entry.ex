defmodule Es.Entry do
  # need to agent.
  use Es
  use Es.Index
  use Es.Document

  es :model, Exblur.Entry

  def search_data(model) do
    [
      _id: model.id,
      url: model.url,
      time: model.time,
      title: model.title,
      # content: model.content,

      tags: Enum.map(model.tags, &(&1.name)),
      divas: Enum.map(model.divas, &(&1.name)),

      review: model.review,
      publish: model.publish,
      removal: model.removal,

      published_at: model.published_at,

      site_name: (if model.site_id, do: model.site.name, else: ""),
      server_title: (if model.server_id, do: model.server.title, else: ""),
      server_domain: (if model.server_id, do: model.server.domain, else: "")
    ]
  end

  def search(word \\ nil, options \\ []) do

    # pagination
    page = max(options[:page] |> to_i, 1)
    per_page = (options[:limit] || options[:per_page] || options[:page_size] || 10000)
    offset = options[:offset] || (page - 1) * per_page

    # queries = search [index: @index_name, from: 0, size: 10, fields: [:tag, :article], explain: 5, version: true, min_score: 0.5] do
    queries = Tirexs.Search.search [index: get_index, fields: [], from: offset, size: per_page] do

      query do
        match_all
      end

      # query do
        # term "title", ""
      # end

      filter do
        _and [_cache: true] do
          filters do
            terms "review",  [true]
            terms "publish", [true]
            terms "removal", [false]
            # terms "server_domain" Server.shown_domain(request.host)
            # terms "site_name"
            # terms "divas"
          end
        end
      end

      facets do
        # tags [global: true] do
          # terms field: "tags"
        # end

        tags do
          terms field: "tags", size: 180
          facet_filter do
            _and [_cache: true] do
              filters do
                terms "review",  [true]
                terms "publish", [true]
                terms "removal", [false]
                # terms "server_domain" Server.shown_domain(request.host)
                # terms "site_name"
                # terms "divas"
              end
            end
          end
        end

        divas do
          terms field: "divas", size: 180
          facet_filter do
            _and [_cache: true] do
              filters do
                terms "review",  [true]
                terms "publish", [true]
                terms "removal", [false]
                # terms "server_domain" Server.shown_domain(request.host)
                # terms "site_name"
                # terms "divas"
              end
            end
          end
        end

      end

      sort do
        [
          [published_at: "desc"]
        ]
      end

      # TODO: highlight: word highlight
      # TODO: phrase suggester API: I'm not sure that you want like this right ?
      # TODO: completion suggester API: autocomplete
      # XXX: more like this: relational contents

    end

    if word do
      fields = [:title, :tags, :divas]  # , :content

      s = Keyword.delete(queries[:search], :query) ++ Tirexs.Query.query do
        multi_match word, fields # , cutoff_frequency: 0.001, boost: 10, use_dis_max: false, operator: "and"
      end

      queries = Keyword.put queries, :search, s
    end

    Logger.debug "#{inspect queries}"
    Logger.debug "#{JSX.prettify! JSX.encode!(queries)}"
    Tirexs.Query.create_resource(queries)
  end

  # settings = Tirexs.ElasticSearch.config()
  # Tirexs.ElasticSearch.delete("exblur_video_entreis", settings)

  def create_index(index \\ get_index) do
    Tirexs.DSL.define [type: "entry", index: index], fn(index, es_settings) ->
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

    Tirexs.DSL.define [type: "entry", index: index], fn(index, es_settings) ->
      mappings do
        # indexes "id",             type: "long",   index: "not_analyzed", include_in_all: false
        indexes "url",            type: "string", index: "not_analyzed"

        indexes "site_name",      type: "string", index: "not_analyzed"
        indexes "server_title",   type: "string", index: "not_analyzed"
        indexes "server_domain",  type: "string", index: "not_analyzed"

        indexes "tags",           type: "string", index: "not_analyzed"
        indexes "divas",          type: "string", index: "not_analyzed"

        indexes "title",          type: "string", analyzer: "ja_analyzer"
        # indexes "content",        type: "string", analyzer: "ja_analyzer"

        indexes "time",           type: "long"
        indexes "published_at",   type: "date" #  ,   format: "strict_date_optional_time"

        indexes "review",         type: "boolean"
        indexes "publish",        type: "boolean"
        indexes "removal",        type: "boolean"
      end

      {index, es_settings}
    end
  end
end
