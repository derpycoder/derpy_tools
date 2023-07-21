defmodule DerpyToolsWeb.UserLoginLive do
  use DerpyToolsWeb, :live_view

  import DerpyToolsWeb.IconComponents

  def render(assigns) do
    ~H"""
    <div class="grid w-full h-[100svh] grow grid-cols-1 place-items-center">
      <div
        class="w-full max-w-[26rem] p-4 sm:px-5"
        id="user-login"
        data-file={__ENV__.file}
        data-line={__ENV__.line}
        phx-hook={Application.fetch_env!(:derpy_tools, :show_inspector?) && "SourceInspector"}
      >
        <div class="text-center">
          <img
            class="mx-auto"
            width="64"
            height="64"
            src={~p"/images/emojis/grinning_face_with_big_eyes.gif"}
            alt="logo"
          />
          <div class="mt-4">
            <h2 class="text-2xl font-semibold text-slate-600 dark:text-navy-100">
              Welcome Back
            </h2>
            <p class="text-slate-400 dark:text-navy-300">
              Please log in to continue
            </p>
          </div>
        </div>
        <.form
          class="card mt-5 rounded-lg p-5 lg:p-7"
          for={@form}
          id="login_form"
          action={~p"/users/log_in"}
          phx-update="ignore"
          phx-window-keyup={JS.dispatch("phx:focus", to: "#email")}
          phx-key="/"
        >
          <.input
            field={@form[:email]}
            placeholder="Enter Email"
            type="text"
            required
            id="email"
            label="Email:"
            autofocus
          >
            <:icon>
              <.icon class="hero-at-symbol h-5 w-5 transition-colors duration-200" />
            </:icon>
          </.input>
          <.input
            field={@form[:password]}
            placeholder="Enter Password"
            type="password"
            required
            label="Password:"
            class="mt-4"
          >
            <:icon>
              <.icon class="hero-lock-closed h-5 w-5 transition-colors duration-200" />
            </:icon>
          </.input>
          <div class="mt-6 flex items-center justify-between space-x-2">
            <label class="inline-flex items-center space-x-2">
              <.input field={@form[:remember_me]} type="checkbox" />
              <span class="line-clamp-1">Remember me</span>
            </label>
            <.link
              navigate={~p"/users/reset_password"}
              class="text-xs text-slate-400 transition-colors line-clamp-1 hover:text-slate-800 focus:text-slate-800 dark:text-navy-300 dark:hover:text-navy-100 dark:focus:text-navy-100"
            >
              Forgot Password?
            </.link>
          </div>
          <.button phx-disable-with="Logging in...">
            Log In <span aria-hidden="true" class="ml-2">&rarr;</span>
          </.button>
          <div class="mt-4 text-center text-xs+">
            <p class="line-clamp-1">
              <span>Dont have Account?</span>
              <.link
                navigate={~p"/users/register"}
                class="text-primary transition-colors hover:text-primary-focus dark:text-accent-light dark:hover:text-accent"
              >
                Create account
              </.link>
            </p>
          </div>
          <div class="my-7 flex items-center space-x-3">
            <div class="h-px flex-1 bg-slate-200 dark:bg-navy-500"></div>
            <p>OR</p>
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
        <div class="mt-8 flex justify-center text-xs text-slate-400 dark:text-navy-300">
          <a href="#">Privacy Notice</a>
          <div class="mx-3 my-1 w-px bg-slate-200 dark:bg-navy-500"></div>
          <a href="#">Term of service</a>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = live_flash(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
