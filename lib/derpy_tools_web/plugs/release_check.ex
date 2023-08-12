defmodule DerpyToolsWeb.Plugs.ReleaseCheck do
  @moduledoc """
  Added a /release route to check if a project is certain color: purple, canary, blue, or green.
  """
  import Plug.Conn

  def init(opts), do: opts

  def call(%Plug.Conn{request_path: "/release"} = conn, _opts) do
    conn
    |> send_resp(200, Application.fetch_env!(:derpy_tools, :release_name))
    |> halt()
  end

  def call(conn, _opts), do: conn
end
