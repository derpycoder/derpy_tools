defmodule DerpyToolsWeb.Plugs.HealthCheck do
  import Plug.Conn

  def init(opts), do: opts

  def call(%Plug.Conn{request_path: "/health"} = conn, _opts) do
    conn
    |> send_resp(200, DerpyTools.Application.uptime())
    |> halt()
  end

  def call(conn, _opts), do: conn
end
