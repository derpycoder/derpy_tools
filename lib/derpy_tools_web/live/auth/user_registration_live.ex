defmodule DerpyToolsWeb.UserRegistrationLive do
  use DerpyToolsWeb, :live_view

  alias DerpyTools.Accounts
  alias DerpyTools.Accounts.User
  import DerpyToolsWeb.IconComponents

  def render(assigns) do
    ~H"""
    <div class="h-[100svh] grid w-full grow grid-cols-1 place-items-center">
      <div
        class="max-w-[26rem] w-full p-4 sm:px-5"
        id="user-registration"
        data-file={__ENV__.file}
        data-line={__ENV__.line}
        phx-hook={Application.fetch_env!(:derpy_tools, :show_inspector?) && "SourceInspector"}
      >
        <div class="text-center">
          <img
            class="mx-auto"
            width="64"
            height="64"
            src={~p"/images/emojis/smiling_face_with_hearts.gif"}
            alt="logo"
          />
          <div class="mt-4">
            <h2 class="text-2xl font-semibold text-slate-600 dark:text-navy-100">
              Welcome To Derpy Tools
            </h2>
            <p class="text-slate-400 dark:text-navy-300">
              Please create an account to continue
            </p>
          </div>
        </div>
        <.form
          class="card mt-5 rounded-lg p-5 lg:p-7"
          for={@form}
          id="registration_form"
          phx-submit="save"
          phx-change="validate"
          phx-trigger-action={@trigger_submit}
          method="post"
          action={~p"/users/log_in?_action=registered"}
          phx-window-keyup={JS.dispatch("phx:focus", to: "#username")}
          phx-key="/"
        >
          <.error :if={@check_errors}>
            Oops, something went wrong! Please check the errors below.
          </.error>
          <.input
            id="username"
            field={@form[:username]}
            placeholder="Username"
            type="text"
            label="Name:"
            autofocus
          >
            <:icon>
              <.icon class="hero-finger-print h-5 w-5 transition-colors duration-200" />
            </:icon>
          </.input>
          <.input
            field={@form[:email]}
            placeholder="Enter Email"
            type="text"
            required
            phx-debounce="1000"
            label="Email:"
            class="mt-4"
          >
            <:icon>
              <.icon class="hero-at-symbol h-5 w-5 transition-colors duration-200" />
            </:icon>
          </.input>
          <.input
            field={@form[:password]}
            placeholder="Password"
            type="password"
            required
            phx-debounce="1000"
            class="mt-4"
            label="Password:"
          >
            <:icon>
              <.icon class="hero-lock-closed h-5 w-5 transition-colors duration-200" />
            </:icon>
          </.input>
          <.input
            field={@form[:repeated_password]}
            placeholder="Repeat Password"
            type="password"
            label="Confirm Password:"
            class="mt-4"
          >
            <:icon>
              <.icon class="hero-lock-closed h-5 w-5 transition-colors duration-200" />
            </:icon>
          </.input>
          <div class="mt-6 flex items-center space-x-2">
            <.input field={@form[:agree_privacy_policy]} type="checkbox" />
            <p class="line-clamp-1">
              I agree with
              <a href="#" class="text-slate-400 hover:underline dark:text-navy-300">
                privacy policy
              </a>
            </p>
          </div>
          <.button phx-disable-with="Creating account...">
            Register
          </.button>
          <div class="mt-4 text-center text-xs+">
            <p class="line-clamp-1">
              <span>Already have an account? </span>
              <.link
                navigate={~p"/users/log_in"}
                class="text-primary transition-colors hover:text-primary-focus dark:text-accent-light dark:hover:text-accent"
              >
                Sign In
              </.link>
            </p>
          </div>
          <div class="my-7 flex items-center space-x-3">
            <div class="h-px flex-1 bg-slate-200 dark:bg-navy-500"></div>
            <p class="text-tiny+ uppercase">or sign up with email</p>
            <div class="h-px flex-1 bg-slate-200 dark:bg-navy-500"></div>
          </div>
          <div class="flex space-x-4">
            <button class="btn w-full space-x-3 border border-slate-300 font-medium text-slate-800 hover:bg-slate-150 focus:bg-slate-150 active:bg-slate-150/80 dark:border-navy-450 dark:text-navy-50 dark:hover:bg-navy-500 dark:focus:bg-navy-500 dark:active:bg-navy-500/90">
              <.google_logo />
              <span>Google</span>
            </button>
            <button class="btn w-full space-x-3 border border-slate-300 font-medium text-slate-800 hover:bg-slate-150 focus:bg-slate-150 active:bg-slate-150/80 dark:border-navy-450 dark:text-navy-50 dark:hover:bg-navy-500 dark:focus:bg-navy-500 dark:active:bg-navy-500/90">
              <.github_logo />
              <span>Github</span>
            </button>
          </div>
        </.form>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )

        changeset = Accounts.change_user_registration(user)
        {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
