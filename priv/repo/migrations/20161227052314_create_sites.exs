defmodule Exblur.Repo.Migrations.CreateSites do
  use Ecto.Migration

  def up do
    """
    CREATE TABLE sites (
        id integer NOT NULL,
        name character varying(255),
        url character varying(255),
        rss character varying(255),
        icon character varying(255),
        last_modified timestamp without time zone,
        created_at timestamp without time zone NOT NULL,
        updated_at timestamp without time zone NOT NULL
    );

    CREATE SEQUENCE sites_id_seq
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;

    ALTER SEQUENCE sites_id_seq OWNED BY sites.id;
    """
    |> Exblur.SQL.split
    |> Enum.each(&execute/1)


  end

  def down do
    """
    DROP DATABASE IF EXISTS sites;
    DROP SEQUENCE sites_id_seq;
    """
    |> Exblur.SQL.split
    |> Enum.each(&execute/1)


  end

end
