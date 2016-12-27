defmodule Exblur.Repo.Migrations.CreateThumbs do
  use Ecto.Migration

  def up do
    """
    CREATE TABLE thumbs (
        id integer NOT NULL,
        entry_id integer,
        image character varying(255),
        created_at timestamp without time zone NOT NULL
    );

    CREATE SEQUENCE thumbs_id_seq
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;

    ALTER SEQUENCE thumbs_id_seq OWNED BY thumbs.id;
    """
    |> Exblur.SQL.split
    |> Enum.each(&execute/1)
  end

  def down do
    """
    DROP DATABASE IF EXISTS thumbs;
    DROP SEQUENCE thumbs_id_seq;
    """
    |> Exblur.SQL.split
    |> Enum.each(&execute/1)
  end
end
