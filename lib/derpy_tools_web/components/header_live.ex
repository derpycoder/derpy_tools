defmodule DerpyToolsWeb.HeaderLive do
  use DerpyToolsWeb, :live_view
  alias DerpyTools.Utils

  import DerpyToolsWeb.IconComponents

  on_mount {DerpyToolsWeb.Permit, :anyone}

  def mount(_params, _session, socket) do
    socket =
      if connected?(socket) do
        %{"timezone" => timezone, "locale" => locale} = get_connect_params(socket)
        assign(socket, timezone: timezone, locale: locale)
      else
        assign(socket, timezone: nil, locale: nil)
      end

    {:ok, socket, layout: false}
  end

  def render(assigns) do
    ~H"""
    <!-- App Header Wrapper-->
    <nav class="nav header" id="header-nav" phx-hook="KeyboardShortcuts">
      <!-- App Header  -->
      <div class="header-container relative flex w-full backdrop-blur-md supports-[backdrop-filter]:bg-white/80 dark:supports-[backdrop-filter]:bg-navy-900/80 print:hidden">
        <!-- Header Items -->
        <div class="flex w-full items-center justify-between">
          <span
            id="logo"
            data-file={__ENV__.file}
            data-line={__ENV__.line}
            phx-hook={Application.fetch_env!(:derpy_tools, :show_inspector?) && "SourceInspector"}
          >
            <.link
              navigate={~p"/"}
              class="font-sponge-bob flex text-center text-slate-700 dark:text-slate-200"
            >
              <span class="text-3xl" id="mock-derpy" phx-hook="SpongeBobText">
                <%= Utils.sponge_bob_text("Derpy") %>
              </span>
              <span class="relative ml-2 inline-block text-2xl before:absolute before:-inset-1 before:block before:h-10 before:-skew-y-3 before:bg-pink-500">
                <span class="relative text-white" id="mock-tools" phx-hook="SpongeBobText">
                  <%= Utils.sponge_bob_text("Tools") %>
                </span>
              </span>
            </.link>
          </span>
          <!-- Left: Sidebar Toggle Button -->
          <%!-- <div class="h-7 w-7">
            <button
              id="menu-toggle"
              phx-click={JS.navigate(~p"/")}
              class="menu-toggle active text-primary ml-0.5 flex h-7 w-7 flex-col justify-center space-y-1.5 outline-none focus:outline-none dark:text-accent-light/80"
            >
              <span></span>
              <span></span>
              <span></span>
            </button>
          </div> --%>
          <!-- Right: Header buttons -->
          <div class="-mr-1.5 flex items-center space-x-2">
            <!-- Mobile Search Toggle -->
            <button class="btn h-8 w-8 rounded-full p-0 hover:bg-slate-300/20 focus:bg-slate-300/20 active:bg-slate-300/25 dark:hover:bg-navy-300/20 dark:focus:bg-navy-300/20 dark:active:bg-navy-300/25 sm:hidden">
              <i class="hero-magnifying-glass" />
            </button>

            <span><%= @locale %></span>
            <span><%= @timezone %></span>
            <!-- Main Searchbar -->
            <div
              id="command-palette-search-bar"
              data-file={__ENV__.file}
              data-line={__ENV__.line}
              phx-hook={Application.fetch_env!(:derpy_tools, :show_inspector?) && "SourceInspector"}
              class="group relative mr-4 flex h-8"
            >
              <button
                id="search-box"
                placeholder="Search here..."
                class="w-60 border-slate-400 peer h-full rounded-full bg-slate-150 px-4 pl-9 text-xs+ text-slate-800 ring-primary/50 hover:bg-slate-200 focus:ring-1.5 dark:bg-navy-900/90 dark:text-navy-100 dark:placeholder-navy-300 dark:ring-accent/50 dark:hover:bg-navy-900/80 dark:focus:bg-navy-900/80"
                type="text"
                x-ref="popperRef"
                phx-click={show_modal("command-palette")}
              />
              <div class="pointer-events-none absolute flex h-full w-10 items-center justify-center text-slate-400 peer-focus:text-primary dark:text-navy-300 dark:peer-focus:text-accent">
                <i class="hero-magnifying-glass" />
              </div>
              <label
                for="search-box"
                class="absolute right-3 flex h-full cursor-pointer items-center justify-center"
              >
                <kbd class="pt-2 text-lg">⌘</kbd>
                <kbd>k</kbd>
              </label>
            </div>
            <!-- Dark Mode Toggle -->
            <button
              id="dark-mode-toggle"
              phx-hook="DarkModeToggle"
              class="btn day h-8 w-8 rounded-full p-0 hover:bg-slate-300/20 focus:bg-slate-300/20 active:bg-slate-300/25 dark:hover:bg-navy-300/20 dark:focus:bg-navy-300/20 dark:active:bg-navy-300/25"
            >
              <.moon />
              <.sun />
            </button>
            <!-- Notification-->
            <div
              x-effect="if($store.global.isSearchbarActive) isShowPopper = false"
              x-data="usePopper({placement:'bottom-end',offset:12})"
              @click.outside="isShowPopper && (isShowPopper = false)"
              class="flex"
            >
              <button
                @click="isShowPopper = !isShowPopper"
                x-ref="popperRef"
                class="btn relative h-8 w-8 rounded-full p-0 hover:bg-slate-300/20 focus:bg-slate-300/20 active:bg-slate-300/25 dark:hover:bg-navy-300/20 dark:focus:bg-navy-300/20 dark:active:bg-navy-300/25"
              >
                <.icon class="hero-bell w-5.5 h-5.5 text-slate-500 dark:text-navy-100" />
              </button>
            </div>
            <!-- Right Sidebar Toggle -->
            <button
              @click="$store.global.isRightSidebarExpanded = true"
              class="btn h-8 w-8 rounded-full p-0 hover:bg-slate-300/20 focus:bg-slate-300/20 active:bg-slate-300/25 dark:hover:bg-navy-300/20 dark:focus:bg-navy-300/20 dark:active:bg-navy-300/25"
            >
              <.app_grid />
            </button>
            <span class="border-slate-900/15 h-5.5 border-r dark:border-slate-300/75"></span>
            <.heartbeat />
            <span class="border-slate-900/15 h-5.5 border-r dark:border-slate-300/75"></span>
            <%= if @current_user do %>
              <.link
                navigate={~p"/users/settings"}
                class="btn relative h-8 w-8 rounded-full p-0 hover:bg-slate-300/20 focus:bg-slate-300/20 active:bg-slate-300/25 dark:hover:bg-navy-300/20 dark:focus:bg-navy-300/20 dark:active:bg-navy-300/25"
              >
                <.icon class="hero-adjustments-horizontal w-5.5 h-5.5 text-slate-500 dark:text-navy-100" />
              </.link>
              <.link
                href={~p"/users/log_out"}
                method="delete"
                class="btn bg-gradient-to-r from-fuchsia-600 to-pink-600 font-medium text-white"
              >
                Log out
              </.link>
            <% else %>
              <.link
                navigate={~p"/users/log_in"}
                class="btn bg-gradient-to-r from-green-400 to-blue-600 font-medium text-white"
              >
                Log in
              </.link>
            <% end %>
          </div>
        </div>
      </div>
    </nav>
    """
  end

  def open_command_pallete(js \\ %JS{}) do
    js
    |> JS.dispatch("phx:focus", to: "#search-box")
  end

  def handle_event("open-command-palette", %{"key" => "k", "metaKey" => true}, socket) do
    {:noreply,
     socket
     |> push_event("phx:focus", %{
       to: "#search-box"
     })}
  end

  def handle_event("open-command-palette", _params, socket), do: {:noreply, socket}

  def handle_event("ping", %{"rtt" => _rtt}, socket) do
    {:noreply, socket |> push_event("pong", %{})}
  end

  def heartbeat(assigns) do
    ~H"""
    <button
      id="heartbeat"
      data-file={__ENV__.file}
      data-line={__ENV__.line}
      phx-hook={Application.fetch_env!(:derpy_tools, :show_inspector?) && "SourceInspector"}
      class="btn relative h-8 w-8 rounded-full p-0 hover:bg-slate-300/20 focus:bg-slate-300/20 active:bg-slate-300/25 dark:hover:bg-navy-300/20 dark:focus:bg-navy-300/20 dark:active:bg-navy-300/25"
    >
      <.icon class="online-indicator hero-wifi-solid w-5.5 h-5.5 bg-lime-500" />

      <span class="ping-indicator absolute top-0 right-0 flex h-3 w-3 items-center justify-center">
        <span class="bg-secondary absolute inline-flex h-full w-full animate-ping rounded-full opacity-80">
        </span>
        <span class="bg-secondary inline-flex h-2 w-2 rounded-full"></span>
      </span>

      <span
        id="ping-display"
        class="ping-display text-tiny absolute -bottom-3 rounded-lg bg-pink-400 p-1 font-semibold text-white empty:hidden"
        phx-hook="Ping"
      />

      <.icon class="offline-indicator hero-x-mark absolute right-1 bottom-1 h-4 w-4 mix-blend-difference" />
    </button>
    """
  end
end
