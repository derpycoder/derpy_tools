defmodule DerpyToolsWeb.UserForgotPasswordLive do
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
            src={~p"/images/emojis/zany_face.gif"}
            alt="logo"
          />
          <div class="mt-4">
            <h2 class="text-2xl font-semibold text-slate-600 dark:text-navy-100">
              Forgot your password?
            </h2>
            <p class="text-slate-400 dark:text-navy-300">
              We'll send a password reset link to your inbox
            </p>
          </div>
        </div>
        <.form
          for={@form}
          id="reset_password_form"
          phx-submit="send_email"
          class="card mt-5 rounded-lg p-5 lg:p-7"
        >
          <.input field={@form[:email]} type="email" placeholder="Email" required label="Email:">
            <:icon>
              <.icon class="hero-at-symbol h-5 w-5 transition-colors duration-200" />
            </:icon>
          </.input>

          <.button phx-disable-with="Sending..." class="w-full">
            Recover Password
          </.button>
        </.form>
        <p class="text-center text-sm mt-4">
          <.link navigate={~p"/users/register"}>Register</.link>
          | <.link navigate={~p"/users/log_in"}>Log in</.link>
        </p>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{}, as: "user"))}
  end

  def handle_event("send_email", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_reset_password_instructions(
        user,
        &url(~p"/users/reset_password/#{&1}")
      )
    end

    info =
      "If your email is in our system, you will receive instructions to reset your password shortly."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end
end
