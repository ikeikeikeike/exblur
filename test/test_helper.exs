ExUnit.start

Mix.Task.run "ecto.create", ["--quiet"]
Mix.Task.run "ecto.migrate", ["--quiet"]
Ecto.Adapters.SQL.begin_test_transaction(Exblur.Repo)
Ecto.Adapters.SQL.begin_test_transaction(Exblur.Mongo)
