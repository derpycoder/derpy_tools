defmodule DerpyToolsWeb.HomePageLive do
  use DerpyToolsWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="card mt-12">
      <div class="border-b border-slate-200 p-4 dark:border-navy-500 sm:px-5">
        <h2 class="font-medium tracking-wide text-slate-700 line-clamp-1 dark:text-navy-100 lg:text-base">
          <.icon class="hero-link mr-2" />
          URL Beaver
        </h2>
      </div>
      <div class="p-4 sm:px-5">
        <ul class="space-y-1.5 font-inter font-medium">
          <li>
            <.link
          navigate={~p"/utm-builder"}
          class="flex rounded-lg bg-slate-150 bg-gradient-to-r from-purple-500 to-purple-600 px-4 py-2.5 tracking-wide text-white outline-none transition-all"
        >
          UTM Builder
        </.link>
          </li>
          <li>
            <.link
          navigate={~p"/metadata-analyzer"}
          class="flex rounded-lg px-4 py-2.5 tracking-wide outline-none transition-all hover:bg-slate-100 hover:text-slate-800 focus:bg-slate-100 focus:text-slate-800 dark:hover:bg-navy-600 dark:hover:text-navy-100 dark:focus:bg-navy-600 dark:focus:text-navy-100"
        >
          Meta Data Analyzer
        </.link>
          </li>
        </ul>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
