defmodule DerpyToolsWeb.UserSettingsLive do
  use DerpyToolsWeb, :live_view

  alias DerpyTools.Accounts

  def render(assigns) do
    ~H"""
    <div class="grid w-full h-screen-sm grow grid-cols-1 place-items-center">
      <div
        class="w-full max-w-[26rem] p-4 sm:px-5"
        id="user-settings"
        data-file={__ENV__.file}
        data-line={__ENV__.line}
        phx-hook={Mix.env() == :dev && "SourceInspector"}
      >
        <div class="flex flex-col items-center">
          <div class="avatar h-18 w-18">
            <div class="is-initial rounded-full bg-secondary text-4xl uppercase text-white">
              jd
            </div>
          </div>
        </div>
        <div class="mt-4 text-center">
          <h2 class="text-2xl font-semibold text-slate-600 dark:text-navy-100">
            Account Settings
          </h2>
          <p class="text-slate-400 dark:text-navy-300">
            Manage your account email address and password settings
          </p>
        </div>
        <.form
          for={@email_form}
          id="email_form"
          phx-submit="update_email"
          phx-change="validate_email"
          class="card mt-5 rounded-lg p-5 lg:p-7"
        >
          <.input field={@email_form[:email]} type="email" required label="Email:">
            <:icon>
              <.icon class="hero-at-symbol h-5 w-5 transition-colors duration-200" />
            </:icon>
          </.input>
          <.input
            field={@email_form[:current_password]}
            name="current_password"
            id="current_password_for_email"
            type="password"
            label="Password:"
            value={@email_form_current_password}
            required
            class="mt-4"
          >
            <:icon>
              <.icon class="hero-lock-closed h-5 w-5 transition-colors duration-200" />
            </:icon>
          </.input>
          <.button phx-disable-with="Changing...">Change Email</.button>
        </.form>

        <.form
          for={@password_form}
          id="password_form"
          action={~p"/users/log_in?_action=password_updated"}
          method="post"
          phx-change="validate_password"
          phx-submit="update_password"
          phx-trigger-action={@trigger_submit}
          class="card mt-5 rounded-lg p-5 lg:p-7"
        >
          <.input
            field={@password_form[:email]}
            type="hidden"
            id="hidden_user_email"
            value={@current_email}
          />
          <.input
            field={@password_form[:password]}
            type="password"
            label="New Password:"
            required
            class="mt-4"
          >
            <:icon>
              <.icon class="hero-lock-closed h-5 w-5 transition-colors duration-200" />
            </:icon>
          </.input>
          <.input
            field={@password_form[:password_confirmation]}
            type="password"
            label="Confirm Password:"
            class="mt-4"
          >
            <:icon>
              <.icon class="hero-lock-closed h-5 w-5 transition-colors duration-200" />
            </:icon>
          </.input>
          <.input
            field={@password_form[:current_password]}
            name="current_password"
            type="password"
            label="Current Password:"
            id="current_password_for_password"
            value={@current_password}
            required
            class="mt-4"
          >
            <:icon>
              <.icon class="hero-lock-closed h-5 w-5 transition-colors duration-200" />
            </:icon>
          </.input>

          <.button phx-disable-with="Changing...">Change Password</.button>
        </.form>
      </div>
    </div>
    """
  end

  def mount(%{"token" => token}, _session, socket) do
    socket =
      case Accounts.update_user_email(socket.assigns.current_user, token) do
        :ok ->
          put_flash(socket, :info, "Email changed successfully.")

        :error ->
          put_flash(socket, :error, "Email change link is invalid or it has expired.")
      end

    {:ok, push_navigate(socket, to: ~p"/users/settings")}
  end

  def mount(_params, _session, socket) do
    user = socket.assigns.current_user
    email_changeset = Accounts.change_user_email(user)
    password_changeset = Accounts.change_user_password(user)

    socket =
      socket
      |> assign(:current_password, nil)
      |> assign(:email_form_current_password, nil)
      |> assign(:current_email, user.email)
      |> assign(:email_form, to_form(email_changeset))
      |> assign(:password_form, to_form(password_changeset))
      |> assign(:trigger_submit, false)

    {:ok, socket}
  end

  def handle_event("validate_email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params

    email_form =
      socket.assigns.current_user
      |> Accounts.change_user_email(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, email_form: email_form, email_form_current_password: password)}
  end

  def handle_event("update_email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.apply_user_email(user, password, user_params) do
      {:ok, applied_user} ->
        Accounts.deliver_user_update_email_instructions(
          applied_user,
          user.email,
          &url(~p"/users/settings/confirm_email/#{&1}")
        )

        info = "A link to confirm your email change has been sent to the new address."
        {:noreply, socket |> put_flash(:info, info) |> assign(email_form_current_password: nil)}

      {:error, changeset} ->
        {:noreply, assign(socket, :email_form, to_form(Map.put(changeset, :action, :insert)))}
    end
  end

  def handle_event("validate_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params

    password_form =
      socket.assigns.current_user
      |> Accounts.change_user_password(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, password_form: password_form, current_password: password)}
  end

  def handle_event("update_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.update_user_password(user, password, user_params) do
      {:ok, user} ->
        password_form =
          user
          |> Accounts.change_user_password(user_params)
          |> to_form()

        {:noreply, assign(socket, trigger_submit: true, password_form: password_form)}

      {:error, changeset} ->
        {:noreply, assign(socket, password_form: to_form(changeset))}
    end
  end
end
