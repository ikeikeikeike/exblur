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

    limit = 1000

    query = 
      Entry.query 
      # |> Entry.xvideos 
      |> Entry.reserved 
      |> limit([_e], ^limit) 
      |> Mongo.all

    Enum.each(query, fn(entry) ->

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
            Logger.error "#{inspect reason}"
            Repo.rollback(reason)
          {_ok, _model} ->
            Entry.already_post(entry)
        end
      end
    end)

    # IO.inspect query

    # record = Exblur.Mongo.get Exblur.Entry, "56169c0b20103e0eb9f89f6e"
    # IO.inspect record
    # Mix.shell.info "Greetings from the Hello Phoenix Application!"

  end

  def setup do
    Repo.start_link
    Mongo.start_link
    HTTPoison.start
    BingTranslator.configure
  end

  # We can define other functions as needed here.
end
