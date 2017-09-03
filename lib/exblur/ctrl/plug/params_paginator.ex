defmodule Exblur.Ctrl.Plug.ParamsPaginator do
  import Plug.Conn
  import CommonDeviceDetector.Detector

  def init(opts), do: opts
  def call(conn, _opts) do
    params =
      if desktop?(conn) do
        %{"page_size" => "33"}
      else
        %{"page_size" => "13"}
      end

    struct conn, [params: Map.merge(conn.params, params)]
  end
end
