defmodule Sitemaps do
  use Sitemap
  alias Exblur.Router.Helpers

  def gen_sitemap do
    create do
      Sitemap.Config.update [
        host: "http://#{Application.get_env(:exblur, Exblur.Endpoint)[:url][:host]}",
        public_path: "",
        files_path: "static/",
      ]

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
        add Helpers.entry_path(Exblur.Endpoint, :index),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool

        add Helpers.diva_path(Exblur.Endpoint, :index),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool

        add Helpers.tag_path(Exblur.Endpoint, :index),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool

        add Helpers.blood_path(Exblur.Endpoint, :index),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool

        add Helpers.height_path(Exblur.Endpoint, :index),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool

        add Helpers.hip_path(Exblur.Endpoint, :index),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool

        add Helpers.bust_path(Exblur.Endpoint, :index),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool

        add Helpers.waste_path(Exblur.Endpoint, :index),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool

        add Helpers.bracup_path(Exblur.Endpoint, :index),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool

        add Helpers.birthday_path(Exblur.Endpoint, :index),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool

        # Wing it
        Enum.each 1966..1996, fn year ->
          add Helpers.birthday_path(Exblur.Endpoint, :year, year),
            priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool

          Enum.each 1..12, fn month ->
            add Helpers.birthday_path(Exblur.Endpoint, :month, year, month),
              priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool
          end
        end

        add Helpers.atoz_path(Exblur.Endpoint, :index),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool

        entries
        |> Enum.each(fn entry ->
          add Helpers.entry_path(Exblur.Endpoint, :show, entry.id, entry.title),
            priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool
        end)

        divas
        |> Enum.each(fn diva ->
          add Helpers.entrydiva_path(Exblur.Endpoint, :index, diva.name),
            priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool
        end)

        tags
        |> Enum.each(fn tag ->
          add Helpers.entrytag_path(Exblur.Endpoint, :index, tag.name),
            priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool
        end)

      end
    end
  end
end
