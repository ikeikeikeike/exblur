defmodule Mix.Tasks.Exblur.PublishEntry do
  use Exblur.Web, :task
  alias Exblur.Entry

  require Logger

  @shortdoc "Sends a greeting to us from Hello Phoenix"

  @moduledoc """
    This is where we would put any long form documentation or doctests.
  """
  def run, do: run([])
  def run(_args) do
    setup

    entries = Entry.initialized_entries

    # Clean video: Physical delete entries coz before publishing those.
    entries
    |> where([e], e.content == "%contents.fc2.com%")
    |> Repo.delete_all

    # Clean video: Physical delete entries coz before publishing those.
    # Entrybuilder::Query.chinese_spams(
      # entries: reserve_entries).delete_all

    # .where(site: Site.order("RANDOM()").first)
    entries =
      entries
      |> order_by([p], p.id)
      |> limit([_e], 200)

    Enum.each Repo.all(entries), fn(e) ->
      # checker = Entrybuilder::Deadlink.get_checker ve.site, ve.url

      # if checker.failure? || !checker.available? do
        # Clean video: Physical delete entries coz before publishing those.
        # ve.destroy
      # else
        Entry.publish_entry(e)

      # end

      Mix.shell.info "Publish: #{e.id}:#{Ecto.DateTime.utc}"
      :timer.sleep(if Mix.env == :prod, do: 6340, else: 200)
    end

    Mix.shell.info "Finish to publish entries"
  end

  def setup do
    Mix.Task.run "app.start", []
    Mix.Task.load_all
  end
end
