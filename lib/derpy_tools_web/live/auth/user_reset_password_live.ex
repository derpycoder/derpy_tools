defmodule DerpyToolsWeb.UserResetPasswordLive do
  use DerpyToolsWeb, :live_view

  alias DerpyTools.Accounts

  def render(assigns) do
    ~H"""
    <div class="grid w-full grow grid-cols-1 place-items-center h-[80vh]">
      <div class="w-full max-w-[26rem] p-4 sm:px-5">
        <div class="text-center">
          <img
            class="mx-auto"
            width="64"
            height="64"
            src={~p"/images/emojis/shushing_face.gif"}
            alt="logo"
          />
          <div class="mt-4">
            <h2 class="text-2xl font-semibold text-slate-600 dark:text-navy-100">
              Reset Password
            </h2>
          </div>
        </div>
        <.form
          for={@form}
          id="reset_password_form"
          phx-submit="reset_password"
          phx-change="validate"
          class="card mt-5 rounded-lg p-5 lg:p-7"
        >
          <.error :if={@form.errors != []}>
            Oops, something went wrong! Please check the errors below.
          </.error>
          <.input field={@form[:password]} type="password" label="New Password:" required />
          <.input
            field={@form[:password_confirmation]}
            type="password"
            label="Confirm Password:"
            required
            class="mt-4"
          />
          <.button phx-disable-with="Resetting..." class="w-full">Reset Password</.button>
        </.form>

        <p class="text-center text-sm mt-4">
          <.link navigate={~p"/users/register"}>Register</.link>
          | <.link navigate={~p"/users/log_in"}>Log in</.link>
        </p>
      </div>
    </div>
    """
  end

  def mount(params, _session, socket) do
    socket = assign_user_and_token(socket, params)

    form_source =
      case socket.assigns do
        %{user: user} ->
          Accounts.change_user_password(user)

        _ ->
          %{}
      end

    {:ok, assign_form(socket, form_source), temporary_assigns: [form: nil]}
  end

  # Do not log in the user after reset password to avoid a
  # leaked token giving the user access to the account.
  def handle_event("reset_password", %{"user" => user_params}, socket) do
    case Accounts.reset_user_password(socket.assigns.user, user_params) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Password reset successfully.")
         |> redirect(to: ~p"/users/log_in")}

      {:error, changeset} ->
        {:noreply, assign_form(socket, Map.put(changeset, :action, :insert))}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_password(socket.assigns.user, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_user_and_token(socket, %{"token" => token}) do
    if user = Accounts.get_user_by_reset_password_token(token) do
      assign(socket, user: user, token: token)
    else
      socket
      |> put_flash(:error, "Reset password link is invalid or it has expired.")
      |> redirect(to: ~p"/")
    end
  end

  defp assign_form(socket, %{} = source) do
    assign(socket, :form, to_form(source, as: "user"))
  end
end
