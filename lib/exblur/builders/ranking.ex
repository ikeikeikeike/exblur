defmodule Exblur.Builders.Ranking do
  def run, do: run []
  def run([]) do
    Redisank.sum :all

    # Delete elements during days between 3 months ago to 2 months ago.
    now  = :calendar.local_time
    from = Timex.shift now, months: -3
    to   = Timex.shift now, months: -2

    Redisank.del from, to, :daily
    Redisank.del from, to, :weekly
    Redisank.del from, to, :monthly
  end

end
