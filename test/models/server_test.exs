defmodule Exblur.ServerTest do
  use Exblur.ModelCase

  alias Exblur.Server

  @valid_attrs %{description: "some content", domain: "some content", icon: "some content", keywords: "some content", primary: true, title: "some content", twitter_url: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Server.changeset(%Server{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Server.changeset(%Server{}, @invalid_attrs)
    refute changeset.valid?
  end
end
