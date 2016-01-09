defmodule Exblur.DivaTest do
  use Exblur.ModelCase

  alias Exblur.Diva

  @valid_attrs %{bust: "some content", height: 42, kana: "some content", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Diva.changeset(%Diva{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Diva.changeset(%Diva{}, @invalid_attrs)
    refute changeset.valid?
  end
end
