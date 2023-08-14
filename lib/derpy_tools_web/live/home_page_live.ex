defmodule DerpyToolsWeb.HomePageLive do
  use DerpyToolsWeb, :live_view

  embed_templates "sections/**/*"

  alias DerpyToolsWeb.CommandPalleteComponent

  def mount(_params, _session, socket) do
    {:ok, socket |> assign(page_title: "Home Page")}
  end

  def render(assigns) do
    ~H"""
    <%!-- <div class="flex justify-center" id="auto-redirect" phx-hook="AutoRedirect"> --%>
    <div class="flex flex-col items-center justify-center">
      <.tools_listing />

      <%!-- <.modal id="confirm-modal" show={true}>
        This is a modal.
      </.modal> --%>

      <.live_component module={CommandPalleteComponent} id="command-pallete" show={true}>
        This is command pallete.
      </.live_component>

      <.blog_teaser />
    </div>
    """
  end
end
