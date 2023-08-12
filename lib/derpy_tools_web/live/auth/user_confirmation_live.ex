defmodule DerpyToolsWeb.UserConfirmationLive do
  use DerpyToolsWeb, :live_view

  alias DerpyTools.Accounts

  def render(%{live_action: :edit} = assigns) do
    ~H"""
    <div class="h-[75vh] grid w-full grow grid-cols-1 place-items-center">
      <div
        class="max-w-[26rem] w-full p-4 sm:px-5"
        id="user-confirmation"
        data-file={__ENV__.file}
        data-line={__ENV__.line}
        phx-hook={Application.fetch_env!(:derpy_tools, :show_inspector?) && "SourceInspector"}
      >
        <div class="text-center">
          <img
            class="mx-auto"
            width="64"
            height="64"
            src={~p"/images/emojis/nerd_face.gif"}
            alt="logo"
          />
          <div class="mt-4">
            <h2 class="text-2xl font-semibold text-slate-600 dark:text-navy-100">
              Confirm your account
            </h2>
            <p class="text-slate-400 dark:text-navy-300">
              Hey, we're glad to have you on board! Please confirm your account to continue using the app.
            </p>
          </div>
        </div>
        <.form
          for={@form}
          id="confirmation_form"
          phx-submit="confirm_account"
          class="card mt-5 rounded-lg p-5 lg:p-7"
        >
          <.input field={@form[:token]} type="hidden" />
          <.button phx-disable-with="Confirming..." class="w-full !mt-0">Confirm my account</.button>
        </.form>
        <p class="mt-4 text-center">
          <.link navigate={~p"/users/register"}>Register</.link>
          | <.link navigate={~p"/users/log_in"}>Log in</.link>
        </p>
      </div>
    </div>
    """
  end

  def mount(%{"token" => token}, _session, socket) do
    form = to_form(%{"token" => token}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: nil]}
  end

  # Do not log in the user after confirmation to avoid a
  # leaked token giving the user access to the account.
  def handle_event("confirm_account", %{"user" => %{"token" => token}}, socket) do
    case Accounts.confirm_user(token) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "User confirmed successfully.")
         |> redirect(to: ~p"/")}

      :error ->
        # If there is a current user and the account was already confirmed,
        # then odds are that the confirmation link was already visited, either
        # by some automation or by the user themselves, so we redirect without
        # a warning message.
        case socket.assigns do
          %{current_user: %{confirmed_at: confirmed_at}} when not is_nil(confirmed_at) ->
            {:noreply, redirect(socket, to: ~p"/")}

          %{} ->
            {:noreply,
             socket
             |> put_flash(:error, "User confirmation link is invalid or it has expired.")
             |> redirect(to: ~p"/")}
        end
    end
  end
end
