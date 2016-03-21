defmodule Mix.Tasks.Exblur.BuildDiva do
  use Exblur.Web, :task

  @shortdoc "Builds diva table using apiactress.appspot.com data."

  @moduledoc """
  nothing
  """
  def run, do: run([])
  def run(args) do
    setup

    Divabuilder.Build.run args

    Mix.shell.info "Finish to build diva"
  end

  def setup do
    Mix.Task.run "app.start", []
    Mix.Task.load_all
    ConCache.start_link [
      ttl_check:     :timer.seconds(1),
      ttl:           :timer.seconds(600),
      touch_on_read: true
    ], name: :exblur_cache
  end

  # We can define other functions as needed here.
end
