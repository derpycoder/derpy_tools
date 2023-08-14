defmodule DerpyToolsWeb.CommandPalleteComponent do
  use DerpyToolsWeb, :live_component

  @doc """
  Renders a modal.

  ## Examples

      <.modal id="confirm-modal">
        This is a modal.
      </.modal>

  JS commands may be passed to the `:on_cancel` to configure
  the closing/cancel event, for example:

      <.modal id="confirm" on_cancel={JS.navigate(~p"/posts")}>
        This is another modal.
      </.modal>

  """
  attr :id, :string, required: true
  attr :show, :boolean, default: false
  attr :on_cancel, JS, default: %JS{}
  slot :inner_block, required: true

  def render(assigns) do
    ~H"""
    <div
      id={@id}
      phx-mounted={@show && show_modal(@id)}
      phx-remove={hide_modal(@id)}
      data-cancel={JS.exec(@on_cancel, "phx-remove")}
      class="relative z-50 hidden"
      phx-window-keydown={show_modal(@id)}
      phx-key="p"
      phx-hook="CommandPalette"
    >
      <div
        id={"#{@id}-bg"}
        class="bg-zinc-50/50 fixed inset-0 transition-opacity dark:bg-navy-500/50"
        aria-hidden="true"
      />
      <div
        class="fixed inset-0 overflow-y-auto"
        aria-labelledby={"#{@id}-title"}
        aria-describedby={"#{@id}-description"}
        role="dialog"
        aria-modal="true"
        tabindex="0"
      >
        <div class="flex min-h-full items-center justify-center">
          <div class="w-full max-w-3xl">
            <.focus_wrap
              id={"#{@id}-container"}
              phx-window-keydown={JS.exec("data-cancel", to: "##{@id}")}
              phx-key="escape"
              phx-click-away={JS.exec("data-cancel", to: "##{@id}")}
              class="shadow-zinc-700/10 ring-zinc-700/10 relative hidden rounded-2xl bg-white shadow-2xl ring-1 transition dark:bg-navy-900"
            >
              <div
                id={"#{@id}-content"}
                class="transform divide-y divide-gray-500 divide-opacity-20 overflow-hidden rounded-xl transition-all"
              >
                <div class="relative">
                  <svg
                    class="pointer-events-none absolute top-3.5 left-4 h-5 w-5 text-slate-50 dark:text-gray-500"
                    fill="none"
                    viewBox="0 0 24 24"
                    stroke-width="1.5"
                    stroke="currentColor"
                    aria-hidden="true"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      d="M21 21l-5.197-5.197m0 0A7.5 7.5 0 105.196 5.196a7.5 7.5 0 0010.607 10.607z"
                    />
                  </svg>
                  <input
                    type="text"
                    class="h-12 w-full border-0 bg-transparent pr-4 pl-11 text-white focus:ring-0 sm:text-sm"
                    placeholder="Search..."
                  />
                </div>
                <!-- Default state, show/hide based on command palette state. -->
                <ul class="max-h-80 scroll-py-2 divide-y divide-gray-500 divide-opacity-20 overflow-y-auto">
                  <li class="p-2">
                    <h2 class="mt-4 mb-2 px-3 text-xs font-semibold text-gray-200">
                      Recent searches
                    </h2>
                    <ul class="text-sm text-gray-400">
                      <!-- Active: "bg-gray-800 text-white" -->
                      <li class="group flex cursor-default select-none items-center rounded-md px-3 py-2">
                        <!-- Active: "text-white", Not Active: "text-gray-500" -->
                        <svg
                          class="h-6 w-6 flex-none text-gray-500"
                          fill="none"
                          viewBox="0 0 24 24"
                          stroke-width="1.5"
                          stroke="currentColor"
                          aria-hidden="true"
                        >
                          <path
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            d="M2.25 12.75V12A2.25 2.25 0 014.5 9.75h15A2.25 2.25 0 0121.75 12v.75m-8.69-6.44l-2.12-2.12a1.5 1.5 0 00-1.061-.44H4.5A2.25 2.25 0 002.25 6v12a2.25 2.25 0 002.25 2.25h15A2.25 2.25 0 0021.75 18V9a2.25 2.25 0 00-2.25-2.25h-5.379a1.5 1.5 0 01-1.06-.44z"
                          />
                        </svg>
                        <span class="ml-3 flex-auto truncate">
                          Workflow Inc. / Website Redesign
                        </span>
                        <!-- Not Active: "hidden" -->
                        <span class="ml-3 hidden flex-none text-gray-400">Jump to...</span>
                      </li>
                    </ul>
                  </li>
                  <li class="p-2">
                    <h2 class="sr-only">Quick actions</h2>
                    <ul class="text-sm text-gray-400">
                      <!-- Active: "bg-gray-800 text-white" -->
                      <li class="group flex cursor-default select-none items-center rounded-md px-3 py-2">
                        <!-- Active: "text-white", Not Active: "text-gray-500" -->
                        <svg
                          class="h-6 w-6 flex-none text-gray-500"
                          fill="none"
                          viewBox="0 0 24 24"
                          stroke-width="1.5"
                          stroke="currentColor"
                          aria-hidden="true"
                        >
                          <path
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            d="M19.5 14.25v-2.625a3.375 3.375 0 00-3.375-3.375h-1.5A1.125 1.125 0 0113.5 7.125v-1.5a3.375 3.375 0 00-3.375-3.375H8.25m3.75 9v6m3-3H9m1.5-12H5.625c-.621 0-1.125.504-1.125 1.125v17.25c0 .621.504 1.125 1.125 1.125h12.75c.621 0 1.125-.504 1.125-1.125V11.25a9 9 0 00-9-9z"
                          />
                        </svg>
                        <span class="ml-3 flex-auto truncate">Add new file...</span>
                        <span class="ml-3 flex text-xs font-semibold text-gray-400">
                          <kbd class="font-sans">⌘</kbd><kbd class="font-sans">N</kbd>
                        </span>
                      </li>
                      <li class="group flex cursor-default select-none items-center rounded-md px-3 py-2">
                        <svg
                          class="h-6 w-6 flex-none text-gray-500"
                          fill="none"
                          viewBox="0 0 24 24"
                          stroke-width="1.5"
                          stroke="currentColor"
                          aria-hidden="true"
                        >
                          <path
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            d="M12 10.5v6m3-3H9m4.06-7.19l-2.12-2.12a1.5 1.5 0 00-1.061-.44H4.5A2.25 2.25 0 002.25 6v12a2.25 2.25 0 002.25 2.25h15A2.25 2.25 0 0021.75 18V9a2.25 2.25 0 00-2.25-2.25h-5.379a1.5 1.5 0 01-1.06-.44z"
                          />
                        </svg>
                        <span class="ml-3 flex-auto truncate">Add new folder...</span>
                        <span class="ml-3 flex text-xs font-semibold text-gray-400">
                          <kbd class="font-sans">⌘</kbd><kbd class="font-sans">F</kbd>
                        </span>
                      </li>
                      <li class="group flex cursor-default select-none items-center rounded-md px-3 py-2">
                        <svg
                          class="h-6 w-6 flex-none text-gray-500"
                          fill="none"
                          viewBox="0 0 24 24"
                          stroke-width="1.5"
                          stroke="currentColor"
                          aria-hidden="true"
                        >
                          <path
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            d="M5.25 8.25h15m-16.5 7.5h15m-1.8-13.5l-3.9 19.5m-2.1-19.5l-3.9 19.5"
                          />
                        </svg>
                        <span class="ml-3 flex-auto truncate">Add hashtag...</span>
                        <span class="ml-3 flex text-xs font-semibold text-gray-400">
                          <kbd class="font-sans">⌘</kbd><kbd class="font-sans">H</kbd>
                        </span>
                      </li>
                      <li class="group flex cursor-default select-none items-center rounded-md px-3 py-2">
                        <svg
                          class="h-6 w-6 flex-none text-gray-500"
                          fill="none"
                          viewBox="0 0 24 24"
                          stroke-width="1.5"
                          stroke="currentColor"
                          aria-hidden="true"
                        >
                          <path
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            d="M9.568 3H5.25A2.25 2.25 0 003 5.25v4.318c0 .597.237 1.17.659 1.591l9.581 9.581c.699.699 1.78.872 2.607.33a18.095 18.095 0 005.223-5.223c.542-.827.369-1.908-.33-2.607L11.16 3.66A2.25 2.25 0 009.568 3z"
                          />
                          <path
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            d="M6 6h.008v.008H6V6z"
                          />
                        </svg>
                        <span class="ml-3 flex-auto truncate">Add label...</span>
                        <span class="ml-3 flex text-xs font-semibold text-gray-400">
                          <kbd class="font-sans">⌘</kbd><kbd class="font-sans">L</kbd>
                        </span>
                      </li>
                    </ul>
                  </li>
                </ul>
                <!-- Results, show/hide based on command palette state. -->
                <ul class="max-h-96 overflow-y-auto p-2 text-sm text-gray-400">
                  <!-- Active: "bg-gray-800 text-white" -->
                  <li class="group flex cursor-default select-none items-center rounded-md px-3 py-2">
                    <!-- Active: "text-white", Not Active: "text-gray-500" -->
                    <svg
                      class="h-6 w-6 flex-none text-gray-500"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke-width="1.5"
                      stroke="currentColor"
                      aria-hidden="true"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        d="M2.25 12.75V12A2.25 2.25 0 014.5 9.75h15A2.25 2.25 0 0121.75 12v.75m-8.69-6.44l-2.12-2.12a1.5 1.5 0 00-1.061-.44H4.5A2.25 2.25 0 002.25 6v12a2.25 2.25 0 002.25 2.25h15A2.25 2.25 0 0021.75 18V9a2.25 2.25 0 00-2.25-2.25h-5.379a1.5 1.5 0 01-1.06-.44z"
                      />
                    </svg>
                    <span class="ml-3 flex-auto truncate">
                      Workflow Inc. / Website Redesign
                    </span>
                    <!-- Not Active: "hidden" -->
                    <span class="ml-3 hidden flex-none text-gray-400">Jump to...</span>
                  </li>
                </ul>
                <!-- Empty state, show/hide based on command palette state. -->
                <div class="px-6 py-14 text-center sm:px-14">
                  <svg
                    class="mx-auto h-6 w-6 text-gray-500"
                    fill="none"
                    viewBox="0 0 24 24"
                    stroke-width="1.5"
                    stroke="currentColor"
                    aria-hidden="true"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      d="M2.25 12.75V12A2.25 2.25 0 014.5 9.75h15A2.25 2.25 0 0121.75 12v.75m-8.69-6.44l-2.12-2.12a1.5 1.5 0 00-1.061-.44H4.5A2.25 2.25 0 002.25 6v12a2.25 2.25 0 002.25 2.25h15A2.25 2.25 0 0021.75 18V9a2.25 2.25 0 00-2.25-2.25h-5.379a1.5 1.5 0 01-1.06-.44z"
                    />
                  </svg>
                  <p class="mt-4 text-sm text-gray-200">
                    We couldn't find any projects with that term. Please try again.
                  </p>
                </div>
              </div>
            </.focus_wrap>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def mount(socket) do
    {:ok, socket}
  end
end
