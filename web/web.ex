defmodule Exblur.Web do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

      use Exblur.Web, :controller
      use Exblur.Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """

  def model do
    quote do
      use Ecto.Schema
      # use Timex.Ecto.Timestamps

      alias Exblur.Mongo
      alias Exblur.Repo
      import Ecto.Changeset
      import Ecto.Query
    end
  end

  def controller do
    quote do
      use Phoenix.Controller

      alias Exblur.Repo
      alias Exblur.Mongo

      import Ecto
      import Ecto.Query

      import Exblur.Router.Helpers
      import Exblur.Gettext
      import Exblur.Imitation
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "web/templates"

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1, action_name: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML
      use Phoenix.HTML.SimplifiedHelpers

      import CommonDeviceDetector.Detector

      import Exblur.Router.Helpers
      import Exblur.ErrorHelpers
      import Exblur.Gettext

      import Exblur.TextExtractor
    end
  end

  def router do
    quote do
      use Phoenix.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel

      alias Exblur.Mongo
      alias Exblur.Repo
      import Ecto.Query, only: [from: 1, from: 2]
      import Exblur.Gettext
    end
  end

  def task do
    quote do
      use Mix.Task

      alias Exblur.Mongo
      alias Exblur.Repo
      import Ecto.Query
    end
  end

  def build do
    quote do
      alias Exblur.Mongo
      alias Exblur.Repo
      import Ecto.Query
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
