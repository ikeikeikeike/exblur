defmodule Extoon.Repo.Migrations.CreateEntryDivas do
  use Ecto.Migration

  def up do
    """
    CREATE TABLE entry_divas (
        id integer NOT NULL,
        entry_id integer,
        diva_id integer,
        created_at timestamp without time zone NOT NULL,
        updated_at timestamp without time zone NOT NULL
    );

    CREATE SEQUENCE entry_divas_id_seq
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;

    ALTER SEQUENCE entry_divas_id_seq OWNED BY entry_divas.id;
    """
    |> Exblur.SQL.split
    |> Enum.each(&execute/1)

  end

  def down do
    """
    DROP DATABASE IF EXISTS entry_divas;
    DROP SEQUENCE entry_divas_id_seq;
    """
    |> Exblur.SQL.split
    |> Enum.each(&execute/1)


  end

end
