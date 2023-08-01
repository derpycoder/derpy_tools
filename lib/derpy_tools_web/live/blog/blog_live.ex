defmodule DerpyToolsWeb.BlogLive do
  require Phoenix.LiveViewTest
  use DerpyToolsWeb, :live_view

  alias DerpyTools.Posts

  def mount(%{"post_slug" => post_slug}, _session, socket) do
    IO.inspect(post_slug, label: "post_slug")

    socket =
      case Posts.fetch_post_by_slug(post_slug) do
        nil ->
          socket
          |> push_navigate(to: "/blog/#{post_slug}/404")

        post ->
          socket
          |> assign(post: post)
      end

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <%!-- <Elixir.DerpyToolsWeb.Posts.taskfile_live /> --%>
    <%= apply(DerpyToolsWeb.Posts, @post.body, [assigns]) %>
    <%!-- <%= apply(DerpyToolsWeb.Posts, :taskfile, [assigns]) %> --%>
    <%!-- <%= DerpyToolsWeb.Posts.taskfile_live(assigns) %> --%>
    <%!-- <.live_component
      module={DerpyToolsWeb.Posts.taskfile_live(assigns)}
      id="mew"
      assigns={assigns}
    /> --%>
    """
  end
end
