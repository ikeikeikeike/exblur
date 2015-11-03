defmodule Exblur.VideoEntryTest do
  use Exblur.ModelCase

  alias Exblur.VideoEntry

  @valid_attrs %{content: "some content", embed_code: "some content", publish: true, published_at: "2010-04-17 14:00:00", removal: true, review: true, time: 42, title: "some content", url: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = VideoEntry.changeset(%VideoEntry{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = VideoEntry.changeset(%VideoEntry{}, @invalid_attrs)
    refute changeset.valid?
  end
end
