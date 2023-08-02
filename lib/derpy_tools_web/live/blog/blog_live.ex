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
          |> push_navigate(to: "/404")

        post ->
          socket
          |> assign(post: post, page_title: post.title)
      end

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <article phx-hook="LozadObserver" id="article">
      <header>
        <a href="https://www.derpytools.com/tag/best-of-the-best/">
          <%= inspect(@post.tags) %>
        </a>

        <h1>
          <%= @post.title %>
        </h1>

        <aside>
          <div>
            <%!-- Use Author Image Carousel --%>
            <a href="/author/derpycoder/">
              <img
                src={
                  "local:///images/profile/profile-pic.webp"
                  |> Imgproxy.new()
                  |> Imgproxy.resize(100, 100)
                  |> to_string()
                }
                alt="Derpy Coder"
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

          <span>|</span>

          <time datetime={@post.created}>
            <%= Timex.format!(@post.created, "{Mshort}, {D} {YYYY}") %>
          </time>
          <%= Timex.Format.DateTime.Formatters.Relative.format!(@post.created, "{relative}") %>
        </aside>

        <p>
          Taskfile is here to make your life easier and cheatsheets obsolete. It&#x27;s a simple, and easy alternative to writing your shell scripts manually, or maintaining a Makefile.
        </p>

        <figure>
          <img
            srcset={"#{"local:///images/taskfile-in-action.png" |> Imgproxy.new() |> Imgproxy.resize(300, 300) |> to_string()} 300w,
                          #{"local:///images/taskfile-in-action.png" |> Imgproxy.new() |> Imgproxy.resize(720, 720) |> to_string()} 720w,
                          #{"local:///images/taskfile-in-action.png" |> Imgproxy.new() |> Imgproxy.resize(960, 960) |> to_string()} 960w,
                          #{"local:///images/taskfile-in-action.png" |> Imgproxy.new() |> Imgproxy.resize(1200, 1200) |> to_string()} 1200w,
                          #{"local:///images/taskfile-in-action.png" |> Imgproxy.new() |> Imgproxy.resize(2000, 2000) |> to_string()} 2000w"}
            sizes="(max-width: 1200px) 100vw, 1200px"
            alt="Taskfile in Action"
          />
          <figcaption>
            Taskfile in Action
          </figcaption>
        </figure>
      </header>
      <%= apply(DerpyToolsWeb.Posts, @post.body, [assigns]) %>
    </article>
    """
  end
end
