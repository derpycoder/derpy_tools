defmodule DerpyToolsWeb.Plugs.ReleaseCheck do
  import Plug.Conn

  def init(opts), do: opts

  def call(%Plug.Conn{request_path: "/release"} = conn, _opts) do
    conn
    |> send_resp(200, Application.fetch_env!(:derpy_tools, :release_name))
    |> halt()
  end

  def call(conn, _opts), do: conn
end
