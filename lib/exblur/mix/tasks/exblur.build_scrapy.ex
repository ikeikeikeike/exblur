defmodule Mix.Tasks.Exblur.BuildScrapy do
  use Exblur.Web, :task
  alias Translator, as: TL

  require Logger

  @shortdoc "Sends a greeting to us from Hello Phoenix"

  @moduledoc """
    This is where we would put any long form documentation or doctests.
  """
  def run, do: run([])
  def run(args) do
    setup

    Entrybuilder.Build.run args

    Mix.shell.info "Finish to build scrapy"
  end

  def setup do
    Mix.Task.run "app.start", []
    Mix.Task.load_all
    ConCache.start_link [
      ttl_check:     :timer.seconds(1),
      ttl:           :timer.seconds(600),
      touch_on_read: true
    ], name: :exblur_cache

    TL.configure
  end

  # We can define other functions as needed here.
end
