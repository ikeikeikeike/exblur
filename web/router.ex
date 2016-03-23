defmodule Exblur.Router do
  use Exblur.Web, :router

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
    plug :accepts, ["json"]
  end

  scope "/", Exblur do
    pipe_through :browser # Use the default browser stack

    get "robots.text", RobotController, :index
    get "robots.txt", RobotController, :index

    get "/:tag", EntryController, :index, as: :entrytag  # if tag does not exists in database, Exblur throws `not found` exception.
    get "/", EntryController, :index

    get "/vid/:id/:title", EntryController, :show

    get "/divas", DivaController, :index
    get "/divas/:diva", EntryController, :index, as: :entrydiva
    get "/divas/autocomplete/:search", DivaController, :autocomplete

    get "/tags/autocomplete/:search", TagController, :autocomplete
  end

  # Other scopes may use custom stacks.
  # scope "/api", Exblur do
  #   pipe_through :api
  # end
end
