defmodule DerpyToolsWeb.BlogLive do
  require Phoenix.LiveViewTest
  use DerpyToolsWeb, :live_view

  alias DerpyTools.Posts
  alias DerpyToolsWeb.{BlogPosts}

  def mount(%{"post_slug" => post_slug}, _session, socket) do
    IO.inspect(post_slug, label: "post_slug")

    socket =
      case Posts.fetch_post_by_slug(post_slug) do
        nil ->
          socket
          |> push_navigate(to: "/404")

        post ->
          socket
          |> assign(post: post, page_title: post.title)
      end

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <section phx-hook="LozadObserver" id="blog-post">
      <BlogPosts.table_of_contents post={@post} />
      <BlogPosts.header post={@post} />
      <BlogPosts.body post={@post} style_nonce={@style_nonce} />
      <BlogPosts.footer />
    </section>
    """
  end
end
