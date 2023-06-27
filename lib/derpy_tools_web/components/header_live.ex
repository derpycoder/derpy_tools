defmodule DerpyToolsWeb.HeaderLive do
  use DerpyToolsWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket, layout: false}
  end

  def render(assigns) do
    ~H"""
    <!-- App Header Wrapper-->
    <nav class="nav header">
      <!-- App Header  -->
      <div class="header-container supports-[backdrop-filter]:bg-white/80 dark:supports-[backdrop-filter]:!bg-navy-750/80 relative flex w-full bg-white dark:bg-navy-750 print:hidden">
        <!-- Header Items -->
        <div class="flex w-full items-center justify-between">
          <!-- Left: Sidebar Toggle Button -->
          <div class="h-7 w-7">
            <button
              id="menu-toggle"
              phx-click={JS.navigate(~p"/")}
              class="menu-toggle active ml-0.5 flex h-7 w-7 flex-col justify-center space-y-1.5 text-primary outline-none focus:outline-none dark:text-accent-light/80"
            >
              <span></span>
              <span></span>
              <span></span>
            </button>
          </div>
          <!-- Right: Header buttons -->
          <div class="-mr-1.5 flex items-center space-x-2">
            <!-- Mobile Search Toggle -->
            <button class="btn h-8 w-8 rounded-full p-0 hover:bg-slate-300/20 focus:bg-slate-300/20 active:bg-slate-300/25 dark:hover:bg-navy-300/20 dark:focus:bg-navy-300/20 dark:active:bg-navy-300/25 sm:hidden">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                class="h-5.5 w-5.5 text-slate-500 dark:text-navy-100"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
                stroke-width="1.5"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"
                />
              </svg>
            </button>
            <!-- Main Searchbar -->
            <div class="group relative mr-4 flex h-8">
              <input
                id="search-box"
                placeholder="Search here..."
                class="form-input border-slate-400 peer h-full rounded-full bg-slate-150 px-4 pl-9 text-xs+ text-slate-800 ring-primary/50 hover:bg-slate-200 focus:ring dark:bg-navy-900/90 dark:text-navy-100 dark:placeholder-navy-300 dark:ring-accent/50 dark:hover:bg-navy-900 dark:focus:bg-navy-900"
                -click="isShowPopper ? 'w-80' : 'w-60'"
                @focus="isShowPopper= true"
                type="text"
                x-ref="popperRef"
                phx-window-keydown="open-command-pallete"
              />
              <div class="pointer-events-none absolute flex h-full w-10 items-center justify-center text-slate-400 peer-focus:text-primary dark:text-navy-300 dark:peer-focus:text-accent">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  class="h-4.5 w-4.5 transition-colors duration-200"
                  fill="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path d="M3.316 13.781l.73-.171-.73.171zm0-5.457l.73.171-.73-.171zm15.473 0l.73-.171-.73.171zm0 5.457l.73.171-.73-.171zm-5.008 5.008l-.171-.73.171.73zm-5.457 0l-.171.73.171-.73zm0-15.473l-.171-.73.171.73zm5.457 0l.171-.73-.171.73zM20.47 21.53a.75.75 0 101.06-1.06l-1.06 1.06zM4.046 13.61a11.198 11.198 0 010-5.115l-1.46-.342a12.698 12.698 0 000 5.8l1.46-.343zm14.013-5.115a11.196 11.196 0 010 5.115l1.46.342a12.698 12.698 0 000-5.8l-1.46.343zm-4.45 9.564a11.196 11.196 0 01-5.114 0l-.342 1.46c1.907.448 3.892.448 5.8 0l-.343-1.46zM8.496 4.046a11.198 11.198 0 015.115 0l.342-1.46a12.698 12.698 0 00-5.8 0l.343 1.46zm0 14.013a5.97 5.97 0 01-4.45-4.45l-1.46.343a7.47 7.47 0 005.568 5.568l.342-1.46zm5.457 1.46a7.47 7.47 0 005.568-5.567l-1.46-.342a5.97 5.97 0 01-4.45 4.45l.342 1.46zM13.61 4.046a5.97 5.97 0 014.45 4.45l1.46-.343a7.47 7.47 0 00-5.568-5.567l-.342 1.46zm-5.457-1.46a7.47 7.47 0 00-5.567 5.567l1.46.342a5.97 5.97 0 014.45-4.45l-.343-1.46zm8.652 15.28l3.665 3.664 1.06-1.06-3.665-3.665-1.06 1.06z" />
                </svg>
              </div>
              <label
                for="search-box"
                class="absolute right-3 flex items-center justify-center h-full cursor-pointer"
              >
                <kbd class="custom text-[16px]">⌘</kbd><kbd class="custom">K</kbd>
              </label>
            </div>
            <!-- Dark Mode Toggle -->
            <button
              id="dark-mode-toggle"
              phx-hook="DarkModeToggle"
              class="btn day h-8 w-8 rounded-full p-0 hover:bg-slate-300/20 focus:bg-slate-300/20 active:bg-slate-300/25 dark:hover:bg-navy-300/20 dark:focus:bg-navy-300/20 dark:active:bg-navy-300/25"
            >
              <svg
                id="moon"
                class="absolute h-6 w-6 text-amber-400 origin-top"
                fill="currentColor"
                viewBox="0 0 24 24"
              >
                <path d="M11.75 3.412a.818.818 0 01-.07.917 6.332 6.332 0 00-1.4 3.971c0 3.564 2.98 6.494 6.706 6.494a6.86 6.86 0 002.856-.617.818.818 0 011.1 1.047C19.593 18.614 16.218 21 12.283 21 7.18 21 3 16.973 3 11.956c0-4.563 3.46-8.31 7.925-8.948a.818.818 0 01.826.404z" />
              </svg>
              <svg
                id="sun"
                xmlns="http://www.w3.org/2000/svg"
                class="absolute h-6 w-6 text-amber-400"
                viewBox="0 0 20 20"
                fill="currentColor"
              >
                <path
                  fill-rule="evenodd"
                  d="M10 2a1 1 0 011 1v1a1 1 0 11-2 0V3a1 1 0 011-1zm4 8a4 4 0 11-8 0 4 4 0 018 0zm-.464 4.95l.707.707a1 1 0 001.414-1.414l-.707-.707a1 1 0 00-1.414 1.414zm2.12-10.607a1 1 0 010 1.414l-.706.707a1 1 0 11-1.414-1.414l.707-.707a1 1 0 011.414 0zM17 11a1 1 0 100-2h-1a1 1 0 100 2h1zm-7 4a1 1 0 011 1v1a1 1 0 11-2 0v-1a1 1 0 011-1zM5.05 6.464A1 1 0 106.465 5.05l-.708-.707a1 1 0 00-1.414 1.414l.707.707zm1.414 8.486l-.707.707a1 1 0 01-1.414-1.414l.707-.707a1 1 0 011.414 1.414zM4 11a1 1 0 100-2H3a1 1 0 000 2h1z"
                  clip-rule="evenodd"
                />
              </svg>
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
              <svg
                xmlns="http://www.w3.org/2000/svg"
                class="h-5.5 w-5.5 text-slate-500 dark:text-navy-100"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="1.5"
                  d="M4 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2V6zM14 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2v-2zM14 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2v-2z"
                />
              </svg>
            </button>
            <span class="border-r border-slate-900/15 dark:border-slate-300/75 h-5.5"></span>
            <.heartbeat />
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

  def handle_event("open-command-pallete", %{"key" => "k", "metaKey" => true}, socket) do
    {:noreply,
     socket
     |> push_event("phx:focus", %{
       to: "#search-box"
     })}
  end

  def handle_event("open-command-pallete", _params, socket), do: {:noreply, socket}

  def handle_event("ping", %{"rtt" => _rtt}, socket) do
    {:noreply, socket |> push_event("pong", %{})}
  end

  def heartbeat(assigns) do
    ~H"""
    <button class="btn relative h-8 w-8 rounded-full p-0 hover:bg-slate-300/20 focus:bg-slate-300/20 active:bg-slate-300/25 dark:hover:bg-navy-300/20 dark:focus:bg-navy-300/20 dark:active:bg-navy-300/25">
      <.icon class="online-indicator hero-wifi-solid w-5.5 h-5.5 bg-lime-500" />

      <span class="ping-indicator absolute top-0 right-0 flex h-3 w-3 items-center justify-center">
        <span class="absolute inline-flex h-full w-full animate-ping rounded-full bg-secondary opacity-80">
        </span>
        <span class="inline-flex h-2 w-2 rounded-full bg-secondary"></span>
      </span>

      <span
        id="ping-display"
        class="ping-display absolute -bottom-3 text-tiny font-semibold text-white p-1 bg-pink-400 rounded-lg empty:hidden"
        phx-hook="Ping"
      />

      <.icon class="offline-indicator hero-x-mark w-4 h-4 absolute right-1 bottom-1 mix-blend-difference" />
    </button>
    """
  end
end
