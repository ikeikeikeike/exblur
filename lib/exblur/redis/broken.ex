defmodule Exblur.Redis.Broken do
  use Rdtype,
    uri: Application.get_env(:exblur, :redis)[:broken],
    coder: Exblur.Redis.Json,
    type: :set

  @prefix "exblur_broken"

  def store(id, value) do
    add "#{@prefix}:#{id}", value
  end

  def ids do
    keys "#{@prefix}:*"
  end
end
