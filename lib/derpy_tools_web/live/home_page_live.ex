defmodule DerpyToolsWeb.HomePageLive do
  use DerpyToolsWeb, :live_view

  def render(assigns) do
    ~H"""
    <ol class="ml-10 mt-12 list-decimal text-md">
      <li>
        <.link
          navigate={~p"/utm-builder"}
          class="underline text-blue-600 hover:text-blue-800 visited:text-purple-600"
        >
          UTM Builder
        </.link>
      </li>
      <li>
        <.link
          navigate={~p"/metadata-analyzer"}
          class="underline text-blue-600 hover:text-blue-800 visited:text-purple-600"
        >
          Meta Data Analyzer (To see if images will load in Twitter, Insta)
        </.link>
      </li>
      <li></li>
    </ol>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
