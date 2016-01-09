defmodule Exblur.VideoEntryDivaTest do
  use Exblur.ModelCase

  alias Exblur.VideoEntryDiva

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = VideoEntryDiva.changeset(%VideoEntryDiva{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = VideoEntryDiva.changeset(%VideoEntryDiva{}, @invalid_attrs)
    refute changeset.valid?
  end
end
