defmodule DeviceDetector do
  alias UAInspector.Result
  alias UAInspector.Parser

  def desktop?(%Plug.Conn{} = conn) do
    conn
    |> Plug.Conn.get_req_header("user-agent")
    |> List.first
    |> desktop?
  end
  def desktop?(useragent) do
    case Parser.parse(useragent) do
      %Result{device: %Result.Device{type: "smartphone"}} -> false
      %Result{device: %Result.Device{type: "tablet"}} -> false
      %Result{device: %Result.Device{type: "smart display"}} -> false
      %Result{device: %Result.Device{type: "feature phone"}} -> false
      %Result{device: %Result.Device{type: "phablet"}} -> false
      %Result{device: %Result.Device{type: "portable media player"}} -> false
      %Result{device: %Result.Device{type: "camera"}} -> false
      %Result{device: %Result.Device{type: "car browser"}} -> false
      %Result.Bot{user_agent: ua} -> ! Regex.match?(~r/mobile/i, ua)
      _ -> true
    end
  end

  def mobile?(%Plug.Conn{} = conn) do
    conn
    |> Plug.Conn.get_req_header("user-agent")
    |> List.first
    |> mobile?
  end
  def mobile?(useragent) do
    case Parser.parse(useragent) do
      %Result{device: %Result.Device{type: "desktop"}} -> false
      %Result{device: %Result.Device{type: "console"}} -> false
      %Result{device: %Result.Device{type: "tv"}} -> false
      %Result{device: %Result.Device{type: :unknown, brand: :unknown, model: :unknown}} -> false
      %Result.Bot{user_agent: ua} -> Regex.match?(~r/mobile/i, ua)
      _ -> true
    end
  end

end
