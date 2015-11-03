defmodule Mix.Tasks.Exblur.Greeting do
  use Mix.Task

  @shortdoc "Sends a greeting to us from Hello Phoenix"

  @moduledoc """
    This is where we would put any long form documentation or doctests.
  """

  def run(_args) do
    Exblur.Mongo.start_link

    record = Exblur.Mongo.get Exblur.Entry, "56169c0b20103e0eb9f89f6e"
    IO.inspect record
    Mix.shell.info "Greetings from the Hello Phoenix Application!"
  end

  # We can define other functions as needed here.
end
