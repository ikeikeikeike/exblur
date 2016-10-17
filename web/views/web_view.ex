defmodule Exblur.WebView do
  alias Exblur.Repo
  alias Exblur.Diva
  alias Exblur.Ecto.Q

  alias Phoenix.HTML.Tag

  import Ecto.Query, only: [from: 1, from: 2]

  def imgfallback, do: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsQAAA7EAZUrDhsAAAANSURBVBhXYzh8+PB/AAffA0nNPuCLAAAAAElFTkSuQmCC"

  def locale do
    Gettext.get_locale(Exblur.Gettext)
  end

  def translate_default({msg, opts}) do
    Gettext.dngettext(Exblur.Gettext, "default", msg, msg, opts[:count] || 0, opts)
  end
  def translate_default(msg) do
    Gettext.dgettext(Exblur.Gettext, "default", msg || "")
  end

  def take_params(%Plug.Conn{} = conn, keys)        when is_list(keys),                    do: take_params(conn, keys, %{})
  def take_params(%Plug.Conn{} = conn, keys, merge) when is_list(keys) and is_list(merge), do: take_params(conn, keys, Enum.into(merge, %{}))
  def take_params(%Plug.Conn{} = conn, keys, merge) do
    conn.params
    |> Map.take(keys)
    |> Map.merge(merge)
  end

  def to_qstring(params) do
    "?" <> URI.encode_query params
  end

  def take_hidden_field_tags(%Plug.Conn{} = conn, keys) when is_list(keys) do
    Enum.map take_params(conn, keys), fn{key, value} ->
      Tag.tag(:input, type: "hidden", id: key, name: key, value: value)
    end
  end

  def divaimg(diva) do
    Exblur.Diva.get_thumb(diva)
  end

  def to_age(date) do
    d = Timex.Date.today
    age = d.year - date.year
    if (date.month > d.month or (date.month >= d.month and date.day > d.day)), do: age = age - 1
    age
  end

  def thumb_one(thumbs) do
    if length(thumbs) > 0, do: Exblur.Thumb.get_thumb(List.first(thumbs)), else: nil
  end

  def thumb_one(thumbs, version) do
    if length(thumbs) > 0, do: Exblur.Thumb.get_thumb(List.first(thumbs), version), else: nil
  end

  def to_keylist(params) do
    Enum.reduce(params, [], fn {k, v}, kw ->
      if !is_atom(k), do: k = String.to_atom(k)
      Keyword.put(kw, k , v)
    end)
  end

  def showpage?(conn), do: Regex.match?(~r(/vid/.+), conn.request_path)

  def nearly_search(nil), do: []
  def nearly_search(%Diva{} = model) do
    measurements =
      Enum.map(Q.nearly_search(:measurements, Diva.query, model), & {:measurements, &1})
      ++ Enum.map(Q.nearly_search(:bracup, Diva.query, model.bracup), & {:bracup, &1})
      ++ Enum.map(Q.nearly_search(:birthday, Diva.query, model.birthday), & {:birthday, &1})

    Enum.shuffle measurements
  end

  def model_with_count(queryable, terms) when is_list(terms) do
    map =
      Enum.reduce terms, %{}, fn term, acc ->
        Map.put acc, term[:term], term[:count]
      end

    names = Enum.keys map

    queryable =
      from q in queryable,
        where: q.name in ^names,
        limit: 50

    queryable
    |> Repo.all
    |> Enum.map(& {map[&1.name], &1})
  end

  def pick_searchword(%Plug.Conn{} = conn) do
    [conn.params["search"], conn.params["tag"], conn.params["diva"]]
    |> Enum.filter(& &1)
    |> List.first
  end

end
