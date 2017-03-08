defmodule Mix.Tasks.Exblur.PublishEntry do
  use Exblur.Web, :task
  require Logger

  @shortdoc "Sends a greeting to us from Hello Phoenix"

  @moduledoc """
    This is where we would put any long form documentation or doctests.
  """
  def run, do: run([])
  def run(_args) do
    setup

    Exblur.Entrybuilder.Publish.run

    Mix.shell.info "Finish to publish entries"
  end

  def setup do
    Mix.Task.run "app.start", []
    Mix.Task.load_all
  end
end
