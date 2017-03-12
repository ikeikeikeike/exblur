defmodule Exblur.Redis.Like do
  use Rdtype,
    uri: Application.get_env(:exblur, :redis)[:like],
    coder: Exblur.Redis.Json,
    type: :set
end
