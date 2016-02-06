defmodule Mix.Tasks.Exblur.BuildEntry do
  use Exblur.Web, :task
  alias Exblur.Entry
  alias Exblur.VideoEntry

  require Logger

  @shortdoc "Sends a greeting to us from Hello Phoenix"

  @moduledoc """
    This is where we would put any long form documentation or doctests.
  """
  def run(_args) do
    setup

    entries =
      Entry.query
      # |> Entry.xvideos
      |> Entry.reserved
      |> limit([_e], 1)
      |> Mongo.all

    models =
      Enum.map entries, fn(entry) ->
        # entry |> IO.inspect
        # abc = BingTranslator.translate(entry.title, to: "ja")
        # IO.inspect abc

        # ve.title = fixable.sentence(fixable.tag(bing.en_to_ja entry.title))
        # ve.content = fixable.sentence(fixable.tag(bing.en_to_ja entry.content))
        # ve.embed_code = fix_embed_code(ve.embed_code, ve.title)
        # ve.tag_list = entry.tags.map{|tag| fixable.tag(bing.en_to_ja tag)}.join(',')

        Repo.transaction fn ->
          case VideoEntry.video_creater(entry) do
            {:error, reason} ->
              Repo.rollback(reason); Logger.error("#{inspect reason}")
              nil

            {:ok, _model} ->
              Entry.already_post(entry)
              nil

            {:new, model} ->
              Entry.already_post(entry)
              model
          end
        end
      end
      |> Enum.filter(&(&1 != nil))

    # Put built up document to Elasticsearch
    if length(models) > 0 do
      Es.VideoEntry.reindex
      Logger.debug("finish reindex")
    end

    Mix.shell.info "Finish to build entry"
  end

  def setup do
    Repo.start_link
    Mongo.start_link
    HTTPoison.start
    BingTranslator.configure
  end

  # We can define other functions as needed here.
end
