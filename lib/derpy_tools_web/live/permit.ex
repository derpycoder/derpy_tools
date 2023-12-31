defmodule DerpyToolsWeb.Permit do
  @moduledoc """
  Authentication code for live view pages. To restrict those pages to an admin, a normal user or anyone.
  """
  import Phoenix.LiveView
  use Phoenix.Component

  alias DerpyTools.Accounts

  def on_mount(:anyone, _params, session, socket) do
    socket =
      case find_current_user(session) do
        {:ok, user} ->
          %{"live_socket_id" => live_socket_id} = session

          socket
          |> assign_new(:current_user, fn -> user end)
          |> subscribe_user()
          |> assign(live_socket_id: live_socket_id)

        {:error, _} ->
          socket
          |> assign(current_user: nil)
      end

    {:cont, socket}
  end

  defp find_current_user(%{"user_token" => user_token}) do
    case Accounts.get_user_by_session_token(user_token) do
      nil -> {:error, nil}
      user -> {:ok, user}
    end
  end

  defp find_current_user(_), do: {:error, nil}

  defp subscribe_user(socket) do
    %{current_user: current_user} = socket.assigns
    if connected?(socket), do: Accounts.subscribe(current_user)
    socket
  end
end
