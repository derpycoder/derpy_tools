defmodule DerpyToolsWeb.BlogLive do
  require Phoenix.LiveViewTest
  use DerpyToolsWeb, :live_view
  use Pathex

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
    <section phx-hook="LozadObserver" id="blog-post" class="w-full grid grid-cols-blog py-18 gap-y-10">
      <BlogPosts.header
        post={@post}
        class="col-span-main w-full prose prose-gray sm:prose-sm md:prose-md lg:prose-lg prose-img:rounded-xl prose-a:text-blue-600 prose-a:no-underline dark:prose-invert"
      />

      <%!-- <BlogPosts.banner class="col-span-full" /> --%>
      <BlogPosts.banner class="col-span-wide" banner={@post.banner} />

      <BlogPosts.left_nav post={@post} class="col-span-main xl:col-span-wide-main" />
      <BlogPosts.body
        post={@post}
        style_nonce={@style_nonce}
        class="col-span-main prose prose-gray sm:prose-sm md:prose-md lg:prose-lg prose-img:rounded-xl prose-a:text-blue-600 prose-a:no-underline dark:prose-invert"
      />
      <BlogPosts.right_nav
        class="col-span-main xl:col-span-main-wide sticky top-[calc(var(--header-height))] max-h-[calc(100svh-(var(--header-height))-200px)]"
        post={@post}
      />
    </section>
    """
  end
end
