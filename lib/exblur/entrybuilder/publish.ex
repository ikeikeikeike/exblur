defmodule Exblur.Entrybuilder.Publish do
  use Exblur.Web, :build
  alias Exblur.Entry

  require Logger

  def run, do: run([])
  def run(_args) do

    entries = Entry.initialized Entry

    # .where(site: Site.order("RANDOM()").first)
    entries =
      entries
      |> order_by([p], p.id)
      |> limit([_e], 200)

    Enum.each Repo.all(entries), fn(e) ->
      # checker = Exblur.Entrybuilder::Deadlink.get_checker ve.site, ve.url

      # if checker.failure? || !checker.available? do
        # Clean video: Physical delete entries coz before publishing those.
        # ve.destroy
      # else
        Entry.publish_entry(e)

      # end

      Logger.info "Publish: #{e.id}:#{Ecto.DateTime.utc}"
      :timer.sleep(500)
    end

    Logger.info "Finish to publish entries"
  end
end
