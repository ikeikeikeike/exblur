defmodule Exblur.Redis.Like do
  use Rdtype,
    uri: Application.get_env(:exblur, :redis)[:like],
    coder: Exblur.Redis.Json,
    type: :set

  @prefix "exblur_like"

  def store(id, value) do
    add "#{@prefix}:#{id}", value
  end

  def ids do
    keys "#{@prefix}:*"
  end
end
