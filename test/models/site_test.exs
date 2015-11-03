defmodule Exblur.SiteTest do
  use Exblur.ModelCase

  alias Exblur.Site

  @valid_attrs %{icon: "some content", last_modified: "2010-04-17 14:00:00", name: "some content", rss: "some content", url: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Site.changeset(%Site{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Site.changeset(%Site{}, @invalid_attrs)
    refute changeset.valid?
  end
end
