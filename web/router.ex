defmodule Exblur.Router do
  use Exblur.Web, :router
  # use ExSentry.Plug

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers

    # plug Plug.Static, at: "/uploads", from: :exblur

    plug Plug.Exblur.AssignLocale
    plug Plug.Exblur.HandleLocalizedPath
    plug Plug.Exblur.ConfigureGettext
  end

  pipeline :api do
    plug :accepts, ["json", "txt", "text", "xml"]
  end

  scope "/", Exblur do
    pipe_through :api

    get "/rss", RssController, :index
    get "/robots.txt", RobotController, :index
  end

  scope "/", Exblur do
    pipe_through :browser # Use the default browser stack

    get  "/reception/contact", ReceptionController, :contact
    post "/reception/contact", ReceptionController, :contact
    get  "/reception/removal", ReceptionController, :removal
    post "/reception/removal", ReceptionController, :removal

    get "/diva/atoz", Diva.AtozController, :index
    get "/diva/date-of-birth/:year/:month", Diva.BirthdayController, :month
    get "/diva/date-of-birth/:year", Diva.BirthdayController, :year
    get "/diva/date-of-birth", Diva.BirthdayController, :index
    get "/diva/bracup", Diva.BracupController, :index
    get "/diva/waste", Diva.WasteController, :index
    get "/diva/bust", Diva.BustController, :index
    get "/diva/hip", Diva.HipController, :index
    get "/diva/height", Diva.HeightController, :index
    get "/diva/blood", Diva.BloodController, :index

    get "/tags", TagController, :index
    get "/divas", DivaController, :index
    get "/about", AboutController, :index
    get "/:tag", EntryController, :index, as: :entrytag  # if tag does not exists in database, Exblur throws `not found` exception.

    get "/", EntryController, :index

    get "/vid/:id/:title", EntryController, :show
    get "/vid/:id/", EntryController, :show

    get "/divas/:diva", EntryController, :index, as: :entrydiva
    get "/divas/autocomplete/:search", DivaController, :autocomplete

    get "/tags/autocomplete/:search", TagController, :autocomplete
  end

  # Other scopes may use custom stacks.
  # scope "/api", Exblur do
  #   pipe_through :api
  # end
end
