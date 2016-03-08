defmodule Exblur.Router do
  use Exblur.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Plug.Exblur.AssignLocale
    plug Plug.Exblur.HandleLocalizedPath
    plug Plug.Exblur.ConfigureGettext
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Exblur do
    pipe_through :browser # Use the default browser stack

    get "/", EntryController, :index
    get "/vid/:id/:title", EntryController, :show

    get "/divas", DivaController, :index

    get "/tags/autocomplete/:search", TagController, :autocomplete
    get "/divas/autocomplete/:search", DivaController, :autocomplete
  end

  # Other scopes may use custom stacks.
  # scope "/api", Exblur do
  #   pipe_through :api
  # end
end
