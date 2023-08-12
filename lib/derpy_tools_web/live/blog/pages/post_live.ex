defmodule DerpyToolsWeb.PostLive do
  require Phoenix.LiveViewTest
  use DerpyToolsWeb, :live_view
  use Pathex

  alias DerpyTools.Posts
  alias DerpyToolsWeb.{BlogPosts}

  def mount(%{"post_slug" => post_slug}, _session, socket) do
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
    <section phx-hook="LozadObserver" id="blog-post" class="grid-cols-blog py-18 grid w-full gap-y-10">
      <BlogPosts.header
        post={@post}
        class="col-span-main prose prose-gray w-full prose-a:text-blue-600 prose-a:no-underline prose-img:rounded-xl dark:prose-invert sm:prose-sm md:prose-md lg:prose-lg"
      />

      <%!-- <BlogPosts.banner class="col-span-full" /> --%>
      <BlogPosts.banner class="col-span-wide" banner={@post.banner} />

      <BlogPosts.left_nav post={@post} class="col-span-main w-0 min-w-full xl:col-span-wide-main" />
      <BlogPosts.body
        post={@post}
        style_nonce={@style_nonce}
        class="col-span-main prose prose-gray w-0 min-w-full prose-a:text-blue-600 prose-a:no-underline prose-img:rounded-xl dark:prose-invert sm:prose-sm md:prose-md lg:prose-lg"
      />
      <BlogPosts.right_nav
        class="col-span-main xl:col-span-main-wide w-0 min-w-full sticky top-[calc(var(--header-height))] max-h-[calc(100svh-(var(--header-height))-200px)]"
        post={@post}
      />
    </section>
    """
  end
end
