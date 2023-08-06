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
      <figure class="not-prose">
        <img
          data-srcset={"#{"local:///images/taskfile-in-action.png" |> Imgproxy.new() |> Imgproxy.resize(300, 300) |> to_string()} 300w,
                          #{"local:///images/taskfile-in-action.png" |> Imgproxy.new() |> Imgproxy.resize(720, 720) |> to_string()} 720w,
                          #{"local:///images/taskfile-in-action.png" |> Imgproxy.new() |> Imgproxy.resize(960, 960) |> to_string()} 960w,
                          #{"local:///images/taskfile-in-action.png" |> Imgproxy.new() |> Imgproxy.resize(1200, 1200) |> to_string()} 1200w,
                          #{"local:///images/taskfile-in-action.png" |> Imgproxy.new() |> Imgproxy.resize(2000, 2000) |> to_string()} 2000w"}
          sizes="(max-width: 1200px) 100vw, 1200px"
          class="lozad"
          alt="Taskfile in Action"
          id="taskfile-in-action"
          phx-update="ignore"
        />
        <figcaption>
          Taskfile in Action
        </figcaption>
      </figure>
      <div class="flex justify-around">
        <div class="basis-1/4 flex-none">
          <aside>
            <div>
              <%!-- Use Author Image Carousel --%>
              <a href="/author/derpycoder/">
                <img
                  data-src={
                    "local:///images/profile/profile-pic.webp"
                    |> Imgproxy.new()
                    |> Imgproxy.resize(100, 100)
                    |> to_string()
                  }
                  class="lozad rounded-full aspect-square w-[64px]"
                  alt="Derpy Coder"
                  id="author"
                  phx-update="ignore"
                />
              </a>
            </div>

            <.intersperse :let={author} enum={@post.authors}>
              <:separator>
                <span>·</span>
              </:separator>
              <a href={"/author/#{author.slug}/"}>
                <%= author.name %>
              </a>
            </.intersperse>
            <br />
            <time datetime={@post.created}>
              <%= Timex.format!(@post.created, "{Mshort}, {D} {YYYY}") %>
            </time>
            <%= Timex.Format.DateTime.Formatters.Relative.format!(@post.created, "{relative}") %>
          </aside>
          <BlogPosts.table_of_contents post={@post} />
        </div>
        <BlogPosts.body
          post={@post}
          style_nonce={@style_nonce}
          class="basis-2/4 flex-none prose prose-gray sm:prose-sm md:prose-md lg:prose-lg prose-img:rounded-xl prose-a:text-blue-600 prose-a:no-underline dark:prose-invert"
        />
        <div class="basis-1/4 flex-none">
          Tag Cloud
        </div>
      </div>
    </section>
    """
  end
end
