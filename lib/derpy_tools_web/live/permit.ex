defmodule DerpyToolsWeb.Permit do
  import Phoenix.LiveView
  use Phoenix.Component

  alias DerpyTools.Accounts

  def on_mount(:anyone, _params, session, socket) do
    socket =
      with {:ok, user} <- find_current_user(session) do
        %{"live_socket_id" => live_socket_id} = session

        socket
        |> assign_new(:current_user, fn -> user end)
        |> subscribe_user()
        |> assign(live_socket_id: live_socket_id)
      else
        {:error, _} ->
          socket
          |> assign(current_user: nil)
      end

    {:cont, socket}
  end

  defp find_current_user(%{"user_token" => user_token}),
    do: {:ok, Accounts.get_user_by_session_token(user_token)}

  defp find_current_user(_), do: {:error, nil}

  defp subscribe_user(socket) do
    %{current_user: current_user} = socket.assigns
    if connected?(socket), do: Accounts.subscribe(current_user)
    socket
  end
end
