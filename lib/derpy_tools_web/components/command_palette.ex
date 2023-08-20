defmodule DerpyToolsWeb.CommandPaletteComponent do
  use DerpyToolsWeb, :live_component
  use DerpyToolsWeb, :html

  alias DerpyTools.Meilisearch
  alias DerpyTools.CommandPaletteSchema

  @impl true
  def mount(socket) do
    changeset = CommandPaletteSchema.change_command_palette(%CommandPaletteSchema{})

    socket =
      socket
      |> assign(
        form: to_form(changeset),
        search_result: Meilisearch.get_non_empty_search_result()
      )
      |> push_event("search-results-ready", %{query: ""})

    {:ok, socket}
  end

  attr :id, :string, required: true
  attr :show, :boolean, default: false
  attr :on_cancel, JS, default: %JS{}

  def render(assigns) do
    ~H"""
    <div
      id={@id}
      phx-mounted={@show && show_modal(@id)}
      phx-remove={hide_modal(@id)}
      data-cancel={JS.exec(@on_cancel, "phx-remove")}
      class="relative z-50 hidden"
      phx-hook="CommandPalette"
      data-show-modal={show_modal(@id)}
    >
      <div
        id={"#{@id}-bg"}
        class="bg-zinc-50/70 fixed inset-0 backdrop-blur-md transition-opacity supports-[backdrop-filter]:!bg-navy-200/60 dark:supports-[backdrop-filter]:!bg-navy-200/20"
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
        <div class="pt-[20svh] flex min-h-full justify-center">
          <div class="w-full max-w-3xl px-4 lg:px-0">
            <.focus_wrap
              id={"#{@id}-container"}
              phx-window-keydown={JS.exec("data-cancel", to: "##{@id}")}
              phx-key="escape"
              phx-click-away={JS.exec("data-cancel", to: "##{@id}")}
              class="ring-zinc-700/10 bg-white/60 rounded-2xl ring-1 transition dark:bg-navy-900/60"
            >
              <div
                id={"#{@id}-content"}
                data-file={__ENV__.file}
                data-line={__ENV__.line}
                phx-hook={Application.fetch_env!(:derpy_tools, :show_inspector?) && "SourceInspector"}
              >
                <.form
                  for={@form}
                  class="bg-slate-50/80 relative rounded-t-2xl dark:bg-navy-900/80"
                  phx-change="search"
                  phx-submit="search"
                  phx-target={@myself}
                  id="command-palette-search"
                >
                  <.input
                    id="command-palette-search-field"
                    field={@form[:query]}
                    name="query"
                    type="text"
                    class="text-navy-900 h-12 w-full rounded-b-none border-0 border-b border-slate-200 ring-0 focus:ring-0 dark:border-navy-500 dark:text-white sm:text-sm"
                    placeholder="Search..."
                    phx-debounce="100"
                    autocomplete="off"
                  >
                    <:icon>
                      <.icon class="hero-magnifying-glass h-5 w-5 text-gray-500" />
                    </:icon>
                    <:shortcut>
                      <kbd class="w-fit font-semibold">ESC</kbd>
                    </:shortcut>
                  </.input>
                </.form>
                <div
                  :if={@form.source.valid?}
                  id={"#{@id}-results"}
                  class="overscroll-contain max-h-[calc(60svh-100px)] transform divide-y divide-slate-200 divide-opacity-20 overflow-auto rounded-xl dark:divide-navy-500"
                >
                  <div :if={@search_result.show_hints?}>
                    Shortcuts:
                    Ctrl + d - Dark/Light
                    Cmd + k - Command Palette
                  </div>
                  <div
                    :if={@search_result.total_hits == 0 && !@search_result.show_hints?}
                    class="px-6 py-14 text-center sm:px-14"
                  >
                    <p class="text-navy-800 text-sm dark:text-gray-200">
                      🚧 Can't find anything with that query. Please try again. 🚧
                    </p>
                  </div>
                  <ul
                    :if={
                      @search_result.blog_posts && @search_result.blog_posts["estimatedTotalHits"] > 0
                    }
                    class="max-h-96 overflow-y-auto p-2 text-sm text-gray-400"
                    id="blog-post-results"
                  >
                    <li
                      :for={%{"_formatted" => post} <- @search_result.blog_posts["hits"]}
                      class="group flex cursor-default select-none items-center rounded-md"
                    >
                      <.link
                        href={"/blog/#{post["slug"]}"}
                        class="flex h-full w-full items-center justify-start rounded-lg px-3 py-2 text-gray-600 group-aria-selected:text-navy-900 group-aria-selected:bg-white hover:slate-50 hover:bg-white group-hover:text-navy-900 dark:text-slate-200 dark:group-aria-selected:bg-gray-900 dark:group-aria-selected:text-white dark:hover:bg-gray-900 dark:group-hover:text-white"
                      >
                        <img
                          src={
                            "local:///images/#{post["banner"]}"
                            |> Imgproxy.new()
                            |> Imgproxy.resize(64, 64, type: "fill")
                            |> to_string()
                          }
                          class="aspect-square flex-initial rounded-md shadow dark:shadow-gray-800"
                          alt={post["abbr"]}
                          width="32px"
                          height="32px"
                        />
                        <span class="ml-3 flex w-full flex-auto items-center justify-between truncate">
                          <span class="flex flex-col truncate">
                            <span class="truncate">
                              <%= raw(post["title"]) %>
                            </span>
                            <span class="truncate text-xs text-gray-400 group-aria-selected:text-navy-500 group-hover:text-navy-500 dark:group-aria-selected:text-gray-300 dark:group-hover:text-gray-300">
                              <%= raw(post["description"]) %>
                            </span>
                          </span>
                          <span class="hidden text-gray-400 group-aria-selected:text-navy-500 group-aria-selected:block group-hover:text-navy-500 group-hover:block dark:group-aria-selected:text-gray-300 dark:group-hover:text-gray-300">
                            Jump to
                          </span>
                        </span>
                      </.link>
                    </li>
                  </ul>
                  <ul
                    :if={
                      @search_result.blog_authors &&
                        @search_result.blog_authors["estimatedTotalHits"] > 0
                    }
                    class="max-h-96 overflow-y-auto p-2 text-sm text-gray-400"
                  >
                    <li
                      :for={%{"_formatted" => author} <- @search_result.blog_authors["hits"]}
                      class="group flex cursor-default select-none items-center rounded-md"
                    >
                      <.link
                        href={"/authors/#{author["slug"]}"}
                        class="flex h-full w-full items-center justify-start rounded-lg px-3 py-2 text-gray-600 group-aria-selected:text-navy-900 group-aria-selected:bg-white hover:slate-50 hover:bg-white group-hover:text-navy-900 dark:text-slate-200 dark:group-aria-selected:bg-gray-900 dark:group-aria-selected:text-white dark:hover:bg-gray-900 dark:group-hover:text-white"
                      >
                        <img
                          src={
                            "local:///images/avatar/#{author["avatar"]}"
                            |> Imgproxy.new()
                            |> Imgproxy.resize(64, 64)
                            |> to_string()
                          }
                          class="aspect-square rounded-full"
                          alt={author["name"]}
                          width="32px"
                          height="32px"
                        />
                        <span class="ml-3 flex w-full items-center justify-between">
                          <span class="flex flex-col">
                            <span><%= raw(author["name"]) %></span>
                            <span class="text-xs text-gray-400 group-aria-selected:text-navy-500 group-hover:text-navy-500 dark:group-aria-selected:text-gray-300 dark:group-hover:text-gray-300">
                              <%= raw(author["alias"]) %>
                            </span>
                          </span>
                          <span class="hidden text-gray-400 group-aria-selected:text-navy-500 group-aria-selected:block group-hover:text-navy-500 group-hover:block dark:group-aria-selected:text-gray-300 dark:group-hover:text-gray-300">
                            Jump to
                          </span>
                        </span>
                      </.link>
                    </li>
                  </ul>
                  <ul
                    :if={
                      @search_result.blog_tags && @search_result.blog_tags["estimatedTotalHits"] > 0
                    }
                    class="max-h-96 overflow-y-auto p-2 text-sm text-gray-400"
                  >
                    <li
                      :for={%{"_formatted" => tag} <- @search_result.blog_tags["hits"]}
                      class="group flex cursor-default select-none items-center rounded-md"
                    >
                      <.link
                        href={"/tags/#{tag["slug"]}"}
                        class="flex h-full w-full items-center rounded-lg px-3 py-2 text-gray-600 group-aria-selected:text-navy-900 group-aria-selected:bg-white hover:slate-50 hover:bg-white group-hover:text-navy-900 dark:text-slate-200 dark:group-aria-selected:bg-gray-900 dark:group-aria-selected:text-white dark:hover:bg-gray-900 dark:group-hover:text-white"
                      >
                        <svg width="12" height="12" fill="none" aria-hidden="true">
                          <path
                            d="M3.75 1v10M8.25 1v10M1 3.75h10M1 8.25h10"
                            stroke="currentColor"
                            stroke-width="1.5"
                            stroke-linecap="round"
                          >
                          </path>
                        </svg>
                        <span class="ml-1 flex w-full justify-between">
                          <span><%= raw(tag["label"]) %></span>
                          <span class="hidden text-gray-400 group-aria-selected:text-navy-500 group-aria-selected:block group-hover:text-navy-500 group-hover:block dark:group-aria-selected:text-gray-300 dark:group-hover:text-gray-300">
                            Jump to
                          </span>
                        </span>
                      </.link>
                    </li>
                  </ul>
                  <ul
                    :if={@search_result.routes && @search_result.routes["estimatedTotalHits"] > 0}
                    class="max-h-96 overflow-y-auto p-2 text-sm text-gray-400"
                  >
                    <li
                      :for={%{"_formatted" => route} <- @search_result.routes["hits"]}
                      class="group flex cursor-default select-none items-center rounded-md"
                    >
                      <.link
                        :if={route["type"] == "internal"}
                        href={route["slug"]}
                        method={route["method"]}
                        class="flex h-full w-full items-center rounded-lg px-3 py-2 text-gray-600 group-aria-selected:text-navy-900 group-aria-selected:bg-white hover:slate-50 hover:bg-white group-hover:text-navy-900 dark:text-slate-200 dark:group-aria-selected:bg-gray-900 dark:group-aria-selected:text-white dark:hover:bg-gray-900 dark:group-hover:text-white"
                      >
                        <i :if={route["method"] == "get"} class="hero-link-mini"></i>
                        <i
                          :if={route["method"] == "delete"}
                          class="hero-arrow-right-on-rectangle-mini"
                        >
                        </i>
                        <span class="ml-1 flex w-full justify-between">
                          <span><%= raw(route["name"]) %></span>
                          <span class="hidden text-gray-400 group-aria-selected:text-navy-500 group-aria-selected:block group-hover:text-navy-500 group-hover:block dark:group-aria-selected:text-gray-300 dark:group-hover:text-gray-300">
                            <%= if route["method"] == "get", do: "Jump to", else: "Jump out" %>
                          </span>
                        </span>
                      </.link>
                      <a
                        :if={route["type"] == "external"}
                        href={route["slug"]}
                        method={route["method"]}
                        target="_blank"
                        class="flex h-full w-full items-center rounded-lg px-3 py-2 text-gray-600 group-aria-selected:text-navy-900 group-aria-selected:bg-white hover:slate-50 hover:bg-white group-hover:text-navy-900 dark:text-slate-200 dark:group-aria-selected:bg-gray-900 dark:group-aria-selected:text-white dark:hover:bg-gray-900 dark:group-hover:text-white"
                      >
                        <i class="hero-arrow-top-right-on-square-mini" />
                        <span class="ml-1 flex w-full justify-between">
                          <span><%= raw(route["name"]) %></span>
                          <span class="hidden text-gray-400 group-aria-selected:text-navy-500 group-aria-selected:block group-hover:text-navy-500 group-hover:block dark:group-aria-selected:text-gray-300 dark:group-hover:text-gray-300">
                            Jump to
                          </span>
                        </span>
                      </a>
                    </li>
                  </ul>
                </div>
                <div class="text-navy-900 bg-slate-50/80 relative flex flex-wrap items-center rounded-b-2xl border-t border-slate-200 px-4 py-2.5 text-xs dark:border-navy-500 dark:bg-navy-900/80 dark:text-slate-400">
                  Type <kbd class="mx-1">#</kbd>
                  <span class="sm:hidden">for tags,</span><span class="hidden sm:inline">to search for tags,</span>
                  <kbd class="mx-1">&gt;</kbd>
                  for blog posts, <kbd class="mx-1">@</kbd>
                  for users, <kbd class="mx-1">$</kbd>
                  for tools, <kbd class="mx-1">/</kbd>
                  for routes, and <kbd class="mx-1">?</kbd>
                  for tips.
                  <span class="text-navy-700 absolute -bottom-6 left-0 flex w-full justify-between px-2 text-xs dark:text-slate-200">
                    <span>
                      Powered by
                      <a
                        href="https://www.meilisearch.com"
                        target="_blank"
                        class="font-semibold text-pink-500"
                      >
                        Meilisearch
                      </a>
                    </span>
                    <span :if={
                      !@search_result.show_hints? &&
                        @form.source.valid? &&
                        @search_result.total_hits != 0
                    }>
                      Found
                      <span class="text-pink-500 dark:text-green-400">
                        <%= @search_result.total_hits %>
                      </span>
                      results in
                      <span class="text-pink-500 dark:text-green-400">
                        <%= @search_result.processing_time %> ms
                      </span>
                    </span>
                  </span>
                </div>
              </div>
            </.focus_wrap>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("search", %{"query" => query}, socket) do
    command_palette_input = %{query: query}

    case CommandPaletteSchema.update(command_palette_input) do
      {:ok, %{id: _, query: query}} ->
        changeset =
          CommandPaletteSchema.change_command_palette(
            %CommandPaletteSchema{},
            command_palette_input
          )

        socket =
          socket
          |> assign(
            search_result: Meilisearch.search(query),
            form: to_form(changeset)
          )
          |> push_event("search-results-ready", command_palette_input)

        {:noreply, socket}

      {:error, changeset} ->
        socket =
          socket
          |> assign(
            form: to_form(changeset),
            search_result: Meilisearch.get_non_empty_search_result()
          )
          |> push_event("search-results-ready", command_palette_input)

        {:noreply, socket}
    end
  end
end
