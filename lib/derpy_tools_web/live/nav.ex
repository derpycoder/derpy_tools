defmodule DerpyToolsWeb.Nav do
  import Phoenix.LiveView
  use Phoenix.Component

  # @pubsub DerpyTools.PubSub

  def on_mount(:default, _params, _session, socket) do
    {:cont,
     socket
     #  |> subscribe_ping(session)
     #  |> attach_hook(:ping, :handle_event, &handle_event/3)
     |> attach_hook(:inspect_source, :handle_event, &handle_event/3)
     |> attach_hook(
       :put_path_in_socket,
       :handle_params,
       &put_path_in_socket/3
     )}
  end

  def on_mount(:assign_browser_info, _params, _session, socket) do
    socket =
      if connected?(socket) do
        %{"timezone" => timezone, "locale" => locale} = get_connect_params(socket)
        assign(socket, timezone: timezone, locale: locale)
      else
        assign(socket, timezone: nil, locale: nil)
      end

    {:cont, socket}
  end

  def on_mount(:assign_nonce, _params, session, socket) do
    %{"script_nonce" => script_nonce, "style_nonce" => style_nonce} = session

    socket = assign(socket, script_nonce: script_nonce, style_nonce: style_nonce)

    {:cont, socket}
  end

  defp handle_event("inspect-source", %{"file" => file, "line" => line}, socket) do
    System.cmd("code", ["--goto", "#{file}:#{line}"])

    {:halt, socket}
  end

  defp handle_event(_, _, socket), do: {:cont, socket}

  defp put_path_in_socket(_params, url, socket),
    do: {:cont, Phoenix.Component.assign(socket, :current_path, URI.parse(url).path)}

  # ==============================================================================
  # Subscribe & Broadcast to a Team the user belongs to,
  # that way the team members can see the pings of each other.
  # ==============================================================================

  # defp subscribe_ping(socket, %{"live_socket_id" => live_socket_id}) do
  #   topic = live_socket_id

  #   if connected?(socket), do: Phoenix.PubSub.subscribe(@pubsub, topic)

  #   assign(socket, topic: topic)
  # end

  # defp subscribe_ping(socket, %{"_csrf_token" => csrf_token}) do
  #   topic = "guest_session:#{Base.url_encode64(csrf_token)}"

  #   if connected?(socket), do: Phoenix.PubSub.subscribe(@pubsub, topic)

  #   assign(socket, topic: topic)
  # end

  # defp rate_limited_ping_broadcast(%{assigns: %{topic: topic}} = socket, rtt)
  #      when is_integer(rtt) do
  #   now = System.system_time(:millisecond)
  #   last_ping_at = socket.assigns[:last_ping_at]

  #   if is_nil(last_ping_at) || now - last_ping_at > 1000 do
  #     # ping_broadcast(topic, rtt)
  #     assign(socket, :last_ping_at, now)
  #   else
  #     socket
  #   end
  # end

  # defp rate_limited_ping_broadcast(socket, _rtt), do: socket

  # defp ping_broadcast(topic, rtt) do
  #   Phoenix.PubSub.broadcast!(
  #     @pubsub,
  #     topic,
  #     {:ping, %{rtt: rtt}}
  #   )
  # end
end
