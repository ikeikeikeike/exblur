defmodule Exblur do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Start the endpoint when the application starts
      supervisor(Exblur.Endpoint, []),
      # Start the Ecto repository
      worker(Exblur.Repo, []),
      # Here you could define other workers and supervisors as children
      # worker(Exblur.Worker, [arg1, arg2, arg3]),
      worker(Exblur.Mongo, []),
      worker(ConCache, [[ttl_check: :timer.seconds(10), ttl: :timer.seconds(1200) ], [name: :exblur_cache]]),
      worker(ConCache, [[ttl_check: :timer.seconds(600), ttl: :timer.seconds(60 * 60 * 24 * 1)], [name: :tag]], id: :exblur_tag_cache),
      worker(ConCache, [[ttl_check: :timer.seconds(600), ttl: :timer.seconds(60 * 60 * 24 * 1)], [name: :diva]], id: :exblur_diva_cache),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Exblur.Supervisor]
    Supervisor.start_link(children, opts)

    # for error
    # Logger.add_backend(ExSentry.LoggerBackend)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Exblur.Endpoint.config_change(changed, removed)
    :ok
  end
end
