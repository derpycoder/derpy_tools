defmodule DerpyToolsWeb.UserConfirmationInstructionsLive do
  use DerpyToolsWeb, :live_view

  alias DerpyTools.Accounts

  def render(assigns) do
    ~H"""
    <div class="grid w-full grow grid-cols-1 place-items-center h-[85vh]">
      <div
        class="w-full max-w-[26rem] p-4 sm:px-5"
        id="user-confirmation-instructions"
        data-file={__ENV__.file}
        data-line={__ENV__.line}
        phx-hook={Application.fetch_env!(:derpy_tools, :show_inspector?) && "SourceInspector"}
      >
        <div class="text-center">
          <img
            class="mx-auto"
            width="64"
            height="64"
            src={~p"/images/emojis/thinking_face.gif"}
            alt="logo"
          />
          <div class="mt-4">
            <h2 class="text-2xl font-semibold text-slate-600 dark:text-navy-100">
              No confirmation instructions received?
            </h2>
            <p class="text-slate-400 dark:text-navy-300">
              We'll send a new confirmation link to your inbox
            </p>
          </div>
        </div>
        <.form
          for={@form}
          id="resend_confirmation_form"
          phx-submit="send_instructions"
          class="card mt-5 rounded-lg p-5 lg:p-7"
        >
          <.input field={@form[:email]} type="email" placeholder="Email" required label="Email:">
            <:icon>
              <.icon class="hero-at-symbol h-5 w-5 transition-colors duration-200" />
            </:icon>
          </.input>

          <.button phx-disable-with="Sending..." class="w-full">
            Resend Confirmation Instructions
          </.button>
        </.form>
        <p class="text-center mt-4">
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

  def handle_event("send_instructions", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_confirmation_instructions(
        user,
        &url(~p"/users/confirm/#{&1}")
      )
    end

    info =
      "If your email is in our system and it has not been confirmed yet, you will receive an email with instructions shortly."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end
end
