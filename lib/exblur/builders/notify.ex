defmodule Exblur.Builders.Notify do
  import Exblur.Builders.Base

  alias Exblur.Repo

  def video do
    videos =
      Repo.execute_and_load("""
      select count(*) as videos from entries
      """, [])

    removal =
      Repo.execute_and_load("""
      select count(*) as removal from entries where removal = true
      """, [])

    review =
      Repo.execute_and_load("""
      select count(*) as review from entries where review = false
      """, [])

    publish =
      Repo.execute_and_load("""
      select count(*) as publish from entries where publish = false
      """, [])

    likes =
      Repo.execute_and_load("""
      select count(*) as likes from entries where likes > 0
      """, [])

    broken =
      Repo.execute_and_load("""
      select count(*) as broken from entries where broken > 0
      """, [])

    sites =
      Repo.execute_and_load("""
      select s.name, count(s.id) from entries as e join sites s on s.id = e.site_id group by s.id order by count desc
      """, [])

    videos ++ removal ++ review ++ publish ++
      likes ++ broken ++ sites
    |> format()
    |> send_slack("VIDEO")
  end

  def diva do
    divas =
      Repo.execute_and_load("""
      select count(*) as divas from divas
      """, [])

    images =
      Repo.execute_and_load("""
      select count(*) as images from divas where image is not null or image != ''
      """, [])

    appeared =
      Repo.execute_and_load("""
      select name, appeared from divas where appeared is not null order by appeared desc limit 10
      """, [])

    busts =
      Repo.execute_and_load("""
      select count(*) as busts from divas where bust is not null or bust != 0
      """, [])

    format(appeared ++ divas ++ images ++ busts)
    |> send_slack("DIVA")
  end

  def tag do
    tags =
      Repo.execute_and_load("""
      select count(*) as tags from tags
      """, [])

    format(tags)
    |> send_slack("TAG")
  end

  def format(records) do
    formated =
      Enum.map records, fn record ->
        Enum.map(record, fn {k, v} -> "#{k}\t#{v}" end)
        |> Enum.join("\t")
      end

    Enum.join(formated, "\n")
  end

  @webhook_url Application.get_env(:exblur, :slack)[:webhook]
  def send_slack(io, name) do
    params = %{
      link_names: 1,
      channel: "#alert_exblur",
      username: "Summaries",
      text: "------ #{name} ------\n" <> io,
    }
    HTTPoison.post @webhook_url, Poison.encode!(params), [{"Content-Type", "application/json"}]
  end

end
