defmodule DerpyToolsWeb.HomePageLive do
  use DerpyToolsWeb, :live_view

  embed_templates "sections/**/*"

  def mount(_params, _session, socket) do
    {:ok, socket |> assign(page_title: "Home Page")}
  end

  def render(assigns) do
    ~H"""
    <%!-- <div class="flex justify-center" id="auto-redirect" phx-hook="AutoRedirect"> --%>
    <div class="flex flex-col items-center justify-center">
      <.tools_listing />

      <.blog_teaser />
    </div>
    """
  end
end
