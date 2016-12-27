defmodule Exblur.Repo.Migrations.CreateDiva do
  use Ecto.Migration

  def up do
    """
    CREATE TABLE divas (
        id integer NOT NULL,
        name character varying(255),
        kana character varying(255),
        romaji character varying(255),
        gyou character varying(255),
        height integer,
        weight integer,
        bust integer,
        bracup character varying(255),
        waste integer,
        hip integer,
        blood character varying(255),
        birthday date,
        image character varying(255),
        created_at timestamp without time zone NOT NULL,
        updated_at timestamp without time zone NOT NULL,
        appeared integer DEFAULT 0
    );

    CREATE SEQUENCE divas_id_seq
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;

    ALTER SEQUENCE divas_id_seq OWNED BY divas.id;
    """
    |> Exblur.SQL.split
    |> Enum.each(&execute/1)


  end

  def down do
    """
    DROP DATABASE IF EXISTS divas;
    DROP SEQUENCE divas_id_seq;
    """
    |> Exblur.SQL.split
    |> Enum.each(&execute/1)

  end


end
