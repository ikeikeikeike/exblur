defmodule Exblur.Sitemap do
  use ExSitemapGenerator
  alias Exblur.Router.Helpers

  create do
    ExSitemapGenerator.start_link
    ExSitemapGenerator.Config.set :max_sitemap_links, 10000

    entries =
      Exblur.Entry
      |> Exblur.Repo.all

    divas =
      Exblur.Diva
      |> Exblur.Repo.all

    tags =
      Exblur.Tag
      |> Exblur.Repo.all

    Enum.each [false, true], fn bool ->
      add Helpers.entry_url(Exblur.Endpoint, :index),
        priority: 0.5, changefreq: "hourly", lastmod: nil, mobile: bool

      add Helpers.diva_url(Exblur.Endpoint, :index),
        priority: 0.5, changefreq: "hourly", lastmod: nil, mobile: bool

      add Helpers.tag_url(Exblur.Endpoint, :index),
        priority: 0.5, changefreq: "hourly", lastmod: nil, mobile: bool

      add Helpers.blood_url(Exblur.Endpoint, :index),
        priority: 0.5, changefreq: "hourly", lastmod: nil, mobile: bool

      add Helpers.height_url(Exblur.Endpoint, :index),
        priority: 0.5, changefreq: "hourly", lastmod: nil, mobile: bool

      add Helpers.hip_url(Exblur.Endpoint, :index),
        priority: 0.5, changefreq: "hourly", lastmod: nil, mobile: bool

      add Helpers.bust_url(Exblur.Endpoint, :index),
        priority: 0.5, changefreq: "hourly", lastmod: nil, mobile: bool

      add Helpers.waste_url(Exblur.Endpoint, :index),
        priority: 0.5, changefreq: "hourly", lastmod: nil, mobile: bool

      add Helpers.bracup_url(Exblur.Endpoint, :index),
        priority: 0.5, changefreq: "hourly", lastmod: nil, mobile: bool

      add Helpers.birthday_url(Exblur.Endpoint, :index),
        priority: 0.5, changefreq: "hourly", lastmod: nil, mobile: bool

      # Wing it
      Enum.each 1..12, fn year ->
        add Helpers.birthday_url(Exblur.Endpoint, :year, year),
          priority: 0.5, changefreq: "hourly", lastmod: nil, mobile: bool

        Enum.each 1..28, fn month ->
          add Helpers.birthday_url(Exblur.Endpoint, :month, year, month),
            priority: 0.5, changefreq: "hourly", lastmod: nil, mobile: bool
        end
      end

      add Helpers.atoz_url(Exblur.Endpoint, :index),
        priority: 0.5, changefreq: "hourly", lastmod: nil, mobile: bool

      entries
      |> Enum.each(fn entry ->
        add Helpers.entry_url(Exblur.Endpoint, :show, entry.id, entry.title),
          priority: 0.5, changefreq: "hourly", lastmod: nil, mobile: bool
      end)

      divas
      |> Enum.each(fn diva ->
        add Helpers.entrydiva_url(Exblur.Endpoint, :index, diva.name),
          priority: 0.5, changefreq: "hourly", lastmod: nil, mobile: bool
      end)

      tags
      |> Enum.each(fn tag ->
        add Helpers.entrytag_url(Exblur.Endpoint, :index, tag.name),
          priority: 0.5, changefreq: "hourly", lastmod: nil, mobile: bool
      end)

    end
  end

end
