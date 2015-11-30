defmodule Mix.Tasks.Exblur.Greeting do
  use Exblur.Web, :task
  alias Exblur.Entry

  @shortdoc "Sends a greeting to us from Hello Phoenix"

  @moduledoc """
    This is where we would put any long form documentation or doctests.
  """

  def run(_args) do
    Mongo.start_link
    HTTPoison.start
    BingTranslator.configure

    limit = 5

    query = Entry.query 
            |> Entry.xvideos 
            |> Entry.reserved 
            |> limit([_], ^limit) 
            |> Mongo.all

    query |> Enum.each(fn(entry) -> 

    # entry |> IO.inspect 
    abc = BingTranslator.translate(entry.title, to: "ja")
    IO.inspect abc

    # ve.title = fixable.sentence(fixable.tag(bing.en_to_ja entry.title))
    # ve.content = fixable.sentence(fixable.tag(bing.en_to_ja entry.content))
    # ve.embed_code = fix_embed_code(ve.embed_code, ve.title)
    # ve.tag_list = entry.tags.map{|tag| fixable.tag(bing.en_to_ja tag)}.join(',')

    end)

    # IO.inspect query

    # record = Exblur.Mongo.get Exblur.Entry, "56169c0b20103e0eb9f89f6e"
    # IO.inspect record
    # Mix.shell.info "Greetings from the Hello Phoenix Application!"
  end

  # We can define other functions as needed here.
end
