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
          |> assign(post: post)
      end

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <article>
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
                src="https://www.derpytools.com/content/images/2023/01/profile-pic.webp"
                alt="Derpy Coder"
              />
            </a>
          </div>

          <.intersperse :let={author} enum={@post.authors}>
            <:separator>
              <span>•</span>
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
            srcset="https://images.unsplash.com/photo-1581007871115-f14bc016e0a4?crop&#x3D;entropy&amp;cs&#x3D;tinysrgb&amp;fit&#x3D;max&amp;fm&#x3D;jpg&amp;ixid&#x3D;MnwxMTc3M3wwfDF8c2VhcmNofDl8fHBvc3QlMjBpdHxlbnwwfHx8fDE2NzQ4Mzc1MDM&amp;ixlib&#x3D;rb-4.0.3&amp;q&#x3D;80&amp;w&#x3D;300 300w,
                    https://images.unsplash.com/photo-1581007871115-f14bc016e0a4?crop&#x3D;entropy&amp;cs&#x3D;tinysrgb&amp;fit&#x3D;max&amp;fm&#x3D;jpg&amp;ixid&#x3D;MnwxMTc3M3wwfDF8c2VhcmNofDl8fHBvc3QlMjBpdHxlbnwwfHx8fDE2NzQ4Mzc1MDM&amp;ixlib&#x3D;rb-4.0.3&amp;q&#x3D;80&amp;w&#x3D;720 720w,
                    https://images.unsplash.com/photo-1581007871115-f14bc016e0a4?crop&#x3D;entropy&amp;cs&#x3D;tinysrgb&amp;fit&#x3D;max&amp;fm&#x3D;jpg&amp;ixid&#x3D;MnwxMTc3M3wwfDF8c2VhcmNofDl8fHBvc3QlMjBpdHxlbnwwfHx8fDE2NzQ4Mzc1MDM&amp;ixlib&#x3D;rb-4.0.3&amp;q&#x3D;80&amp;w&#x3D;960 960w,
                    https://images.unsplash.com/photo-1581007871115-f14bc016e0a4?crop&#x3D;entropy&amp;cs&#x3D;tinysrgb&amp;fit&#x3D;max&amp;fm&#x3D;jpg&amp;ixid&#x3D;MnwxMTc3M3wwfDF8c2VhcmNofDl8fHBvc3QlMjBpdHxlbnwwfHx8fDE2NzQ4Mzc1MDM&amp;ixlib&#x3D;rb-4.0.3&amp;q&#x3D;80&amp;w&#x3D;1200 1200w,
                    https://images.unsplash.com/photo-1581007871115-f14bc016e0a4?crop&#x3D;entropy&amp;cs&#x3D;tinysrgb&amp;fit&#x3D;max&amp;fm&#x3D;jpg&amp;ixid&#x3D;MnwxMTc3M3wwfDF8c2VhcmNofDl8fHBvc3QlMjBpdHxlbnwwfHx8fDE2NzQ4Mzc1MDM&amp;ixlib&#x3D;rb-4.0.3&amp;q&#x3D;80&amp;w&#x3D;2000 2000w"
            sizes="(max-width: 1200px) 100vw, 1200px"
            src="https://images.unsplash.com/photo-1581007871115-f14bc016e0a4?crop&#x3D;entropy&amp;cs&#x3D;tinysrgb&amp;fit&#x3D;max&amp;fm&#x3D;jpg&amp;ixid&#x3D;MnwxMTc3M3wwfDF8c2VhcmNofDl8fHBvc3QlMjBpdHxlbnwwfHx8fDE2NzQ4Mzc1MDM&amp;ixlib&#x3D;rb-4.0.3&amp;q&#x3D;80&amp;w&#x3D;1200"
            alt="Taskfile: A Sensible Makefile and Shell Script Alternative"
          />
          <figcaption>
            Photo by
            <a href="https://unsplash.com/fr/@mindspacestudio?utm_source=ghost&utm_medium=referral&utm_campaign=api-credit">
              Mindspace Studio
            </a>
            /
            <a href="https://unsplash.com/?utm_source=ghost&utm_medium=referral&utm_campaign=api-credit">
              Unsplash
            </a>
          </figcaption>
        </figure>
      </header>
      <%= apply(DerpyToolsWeb.Posts, @post.body, [assigns]) %>
    </article>
    """
  end
end
