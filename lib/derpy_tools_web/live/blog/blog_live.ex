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
    <section phx-hook="LozadObserver" id="blog-post" class="w-full flex flex-col items-center">
      <BlogPosts.header
        post={@post}
        class="w-full prose prose-gray sm:prose-sm md:prose-md lg:prose-lg prose-img:rounded-xl prose-a:text-blue-600 prose-a:no-underline dark:prose-invert"
      />
      <BlogPosts.banner />
      <div class="flex justify-around flex-col xl:flex-row">
        <BlogPosts.left_nav post={@post} class="basis-1/4 flex-none" />
        <BlogPosts.body
          post={@post}
          style_nonce={@style_nonce}
          class="basis-2/4 flex-none prose prose-gray sm:prose-sm md:prose-md lg:prose-lg prose-img:rounded-xl prose-a:text-blue-600 prose-a:no-underline dark:prose-invert"
        />
        <BlogPosts.right_nav class="basis-1/4 flex-none" />
      </div>
    </section>
    """
  end
end
