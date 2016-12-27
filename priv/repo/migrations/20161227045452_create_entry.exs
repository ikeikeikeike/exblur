defmodule Exblur.Repo.Migrations.CreateEntry do
  use Ecto.Migration

  def up do
    """
    CREATE TABLE entries (
        id integer NOT NULL,
        url text,
        title character varying(255),
        content text,
        embed_code text,
        "time" integer,
        sort integer DEFAULT null,
        published_at timestamp without time zone,
        review boolean DEFAULT false,
        publish boolean DEFAULT false,
        removal boolean DEFAULT false,
        site_id integer,
        created_at timestamp without time zone NOT NULL,
        updated_at timestamp without time zone NOT NULL
    );

    CREATE SEQUENCE entries_id_seq
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;

    ALTER SEQUENCE entries_id_seq OWNED BY entries.id;
    """
    |> Exblur.SQL.split
    |> Enum.each(&execute/1)

  end

  def down do
    """
    DROP DATABASE IF EXISTS entries;
    DROP SEQUENCE entries_id_seq;
    """
    |> Exblur.SQL.split
    |> Enum.each(&execute/1)

  end

end
