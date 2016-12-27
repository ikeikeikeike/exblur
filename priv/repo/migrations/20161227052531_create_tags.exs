defmodule Exblur.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def up do
    """
    CREATE TABLE tags (
        id integer NOT NULL,
        name character varying(255),
        kana character varying(255),
        romaji character varying(255),
        orig character varying(255),
        gyou character varying(255),
        created_at timestamp without time zone NOT NULL,
        updated_at timestamp without time zone NOT NULL
    );

    CREATE SEQUENCE tags_id_seq
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;

    ALTER SEQUENCE tags_id_seq OWNED BY tags.id;
    """
    |> Exblur.SQL.split
    |> Enum.each(&execute/1)

  end

  def down do
    """
    DROP DATABASE IF EXISTS tags;
    DROP SEQUENCE tags_id_seq;
    """
    |> Exblur.SQL.split
    |> Enum.each(&execute/1)


  end
end
