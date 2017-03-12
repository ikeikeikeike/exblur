defmodule Exblur.Redis.Broken do
  use Rdtype,
    uri: Application.get_env(:exblur, :redis)[:broken],
    coder: Exblur.Redis.Json,
    type: :set
end
