defmodule Exblur.Mongo do
  use Ecto.Repo,
    otp_app: :exblur,
    adapter: Mongo.Ecto
end
