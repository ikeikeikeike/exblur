defmodule Exblur.TagController do
  use Exblur.Web, :controller

  # require Tirexs.Query
  # alias Exblur.Tag, as: Model

  # def autocomplete(conn, _params) do
    # not_found unless request.xhr?
    # expires = 10.days

    # words = Rails.cache.fetch("tags_autocomplete:#{params[:search]}", expires_in: expires) do
      # tags = ActsAsTaggableOn::Tag.search params[:search],
        # fields: [{name: :text_start}],
        # limit: 5
      # tags.map{|o| {value: o.name, tokens: o.name.split}}
    # end

    # manual_cache expires

    # render json: words
  # end


end
