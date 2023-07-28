defmodule DerpyTools.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      DerpyToolsWeb.Telemetry,
      # Start the Ecto repository
      DerpyTools.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: DerpyTools.PubSub},
      # Start Finch
      {Finch, name: DerpyTools.Finch},
      # Start the Endpoint (http/https)
      DerpyToolsWeb.Endpoint,
      # PromEx should be started after the Endpoint, to avoid unnecessary error messages
      DerpyTools.PromEx
      # Start a worker by calling: DerpyTools.Worker.start_link(arg)
      # {DerpyTools.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DerpyTools.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DerpyToolsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
