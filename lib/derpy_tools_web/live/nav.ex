defmodule DerpyToolsWeb.Nav do
  import Phoenix.LiveView

  def on_mount(:default, _params, _session, socket) do
    {:cont,
     socket
     |> attach_hook(:inspect_source, :handle_event, &handle_event/3)}
  end

  def handle_event("inspect-source", %{"file" => file, "line" => line}, socket) do
    System.cmd("code", ["--goto", "#{file}:#{line}"])

    {:halt, socket}
  end

  def handle_event(_, _, socket), do: {:cont, socket}
end
