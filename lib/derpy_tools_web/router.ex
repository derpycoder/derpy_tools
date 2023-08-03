defmodule DerpyToolsWeb.Router do
  use DerpyToolsWeb, :router
  import Redirect

  import DerpyToolsWeb.UserAuth
  alias DerpyToolsWeb.Plugs.CustomSecureBrowserHeaders

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {DerpyToolsWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers, %{"Content-Security-Policy" => ""}
    plug :fetch_current_user
    plug PromEx.Plug, prom_ex_module: DerpyTools.PromEx, path: "/metrics"
    plug Plug.Telemetry, event_prefix: [:webapp, :router]
    plug CustomSecureBrowserHeaders
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DerpyToolsWeb do
    pipe_through :browser

    # get "/", PageController, :home
    live_session :no_log_in_required,
      on_mount: [
        DerpyToolsWeb.Nav,
        {DerpyToolsWeb.Nav, :assign_nonce},
        {DerpyToolsWeb.Permit, :anyone}
      ] do
      live "/", HomePageLive
      live "/utm-builder", UtmBuilderLive
      live "/metadata-analyzer", MetadataAnalyzerLive

      # For Live View Blog Posts, with more interactivity requirements
      # live "/blog/taskfile-a-sensible-makefile-and-shell-script-alternative", TaskfileLive
      live "/blog/:post_slug", BlogLive
    end
  end

  redirect(
    "/taskfile-a-sensible-makefile-and-shell-script-alternative",
    "/blog/taskfile-a-sensible-makefile-and-shell-script-alternative",
    :permanent
  )

  # Other scopes may use custom stacks.
  # scope "/api", DerpyToolsWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:derpy_tools, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard",
        metrics: DerpyToolsWeb.Telemetry,
        csp_nonce_assign_key: %{
          style: :style_nonce,
          script: :script_nonce
        }

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", DerpyToolsWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{DerpyToolsWeb.UserAuth, :redirect_if_user_is_authenticated}, DerpyToolsWeb.Nav] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", DerpyToolsWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{DerpyToolsWeb.UserAuth, :ensure_authenticated}, DerpyToolsWeb.Nav] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end
  end

  scope "/", DerpyToolsWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{DerpyToolsWeb.UserAuth, :mount_current_user}, DerpyToolsWeb.Nav] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
