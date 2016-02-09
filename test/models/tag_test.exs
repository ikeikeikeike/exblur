defmodule Exblur.TagTest do
  use Exblur.ModelCase

  alias Exblur.Tag

  @valid_attrs %{kana: "some content", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Tag.changeset(%Tag{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Tag.changeset(%Tag{}, @invalid_attrs)
    refute changeset.valid?
  end
end
