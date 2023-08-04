defmodule DerpyToolsWeb.Plugs.VersionCheck do
  import Plug.Conn

  def init(opts), do: opts

  def call(%Plug.Conn{request_path: "/version"} = conn, _opts) do
    {<<git_sha::binary-size(8), _rest::binary>>, _exit_code} =
      System.cmd("git", ["rev-parse", "HEAD"])

    conn
    |> send_resp(200, git_sha)
    |> halt()
  end

  def call(conn, _opts), do: conn
end
