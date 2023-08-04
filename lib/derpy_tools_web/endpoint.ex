defmodule DerpyToolsWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :derpy_tools

  alias DerpyToolsWeb.Plugs.{HealthCheck, ReleaseCheck, VersionCheck, StatsCheck}

  # Put the health check here, before anything else
  plug HealthCheck
  plug ReleaseCheck
  plug VersionCheck
  plug StatsCheck

  plug PromEx.Plug, prom_ex_module: DerpyTools.PromEx

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_derpy_tools_key",
    signing_salt: "29I1sZWa",
    same_site: "Lax"
  ]

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    # encodings: [{"zstd", ".zstd"}],
    gzip: true,
    brotli: true,
    at: "/",
    from: :derpy_tools,
    only: DerpyToolsWeb.static_paths(),
    headers: [
      {"cache-control", "max-age=0, public, must-revalidate"}
    ]

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :derpy_tools
  end

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId

  plug Unplug,
    if: {Unplug.Predicates.RequestPathNotIn, ["/metrics", "/stats", "/health", "release"]},
    do: {Plug.Telemetry, event_prefix: [:phoenix, :endpoint]}

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug DerpyToolsWeb.Router
end
