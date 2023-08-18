defmodule DerpyToolsWeb.BlogPosts do
  @moduledoc """
  Embeds templates from posts & sections for easy access and defines most of the structural element of a blog.
  Contains helpers to make a blog function.
  """
  use Phoenix.Component
  use Pathex

  alias Phoenix.LiveView.JS
  alias DerpyTools.DataStore.Posts

  @wpm 225

  embed_templates "posts/**/*"
  embed_templates "sections/**/*"

  attr :headers, :list

  def table_of_contents(assigns) do
    ~H"""
    <div
      id="table-of-contents"
      class="sticky top-[calc(var(--header-height))] py-1 xl:pr-5"
      data-file={__ENV__.file}
      data-line={__ENV__.line}
      phx-hook={Application.fetch_env!(:derpy_tools, :show_inspector?) && "SourceInspector"}
    >
      <h5
        id="toc"
        class="mb-5 text-sm font-semibold leading-6 text-slate-900 dark:text-slate-100"
        phx-hook="TableOfContents"
      >
        On this page
      </h5>
      <a
        href="#"
        class="block pb-1 font-medium hover:text-slate-900 dark:text-slate-400 dark:hover:text-slate-300"
      >
        <i class="hero-chevron-up w-5.5 h-5.5 text-slate-500 dark:text-navy-100" /> Top
      </a>

      <.nested_header
        headers={@headers}
        class="max-h-[calc(100svh-(var(--header-height)))] overflow-auto"
      />
    </div>
    """
  end

  attr :id, :string, default: nil
  attr :headers, :list
  attr :class, :string, default: nil
  attr :parent, :list, default: []

  def nested_header(assigns) do
    ~H"""
    <ul id={@id} class={["space-y-1 font-inter font-medium list-none not-prose", @class]}>
      <li
        :for={%{header: header, id: id, title: title, children: children} <- @headers}
        class="not-prose"
      >
        <a
          id={"#{id}-link"}
          key={id}
          href={"##{id}"}
          tabindex="0"
          data-parent={@parent |> Enum.join(">")}
          class={[
            "block py-1 hover:text-slate-900 dark:text-slate-400 dark:hover:text-slate-300 truncate",
            case header do
              "h2" -> "font-semibold"
              "h3" -> "font-medium"
              "h4" -> "font-normal"
              "h5" -> "font-normal text-xs"
            end
          ]}
          phx-click={JS.toggle(to: "##{id}-container")}
        >
          <i :if={header in ~w{h3 h4 h5}} class="hero-chevron-right-mini" />
          <span><%= title %></span>
        </a>

        <.nested_header
          :if={children}
          id={"#{id}-container"}
          headers={children |> Enum.reverse()}
          class="hidden pl-4"
          parent={[id, @parent |> Enum.join(">")]}
        />
      </li>
    </ul>
    """
  end

  attr :post, :map
  attr :class, :string, default: nil

  def header(assigns)

  attr :class, :string, default: nil
  attr :banner, :string

  def banner(assigns)

  attr :post, :map
  attr :style_nonce, :string
  attr :class, :string, default: nil

  def body(assigns) do
    ~H"""
    <div class={@class}>
      <%= apply(__MODULE__, @post.body, [assigns]) %>
      <.footer_nav post={@post} />
    </div>
    """
  end

  attr :class, :string, default: nil
  attr :post, :map

  def footer_nav(assigns) do
    {prev, next} = Posts.fetch_prev_and_next_posts(assigns.post.slug)

    assigns = assign(assigns, prev: prev, next: next)

    ~H"""
    <div class="inset-0 my-10 flex items-center" aria-hidden="true">
      <div class="border-navy-300 w-full border-t"></div>
    </div>

    <nav
      class={["not-prose text-sm w-full", @class]}
      id="footer-nav"
      data-file={__ENV__.file}
      data-line={__ENV__.line}
      phx-hook={Application.fetch_env!(:derpy_tools, :show_inspector?) && "SourceInspector"}
    >
      <a
        :if={@prev}
        href={"/blog/#{@prev.slug}"}
        title={@prev.title}
        class="mb-3 flex flex-col items-start"
      >
        <svg
          xmlns="http://www.w3.org/2000/svg"
          fill="currentColor"
          width="24"
          height="24"
          viewbox="0 0 24 24"
        >
          <path
            fill-rule="evenodd"
            d="M11.03 3.97a.75.75 0 0 1 0 1.06l-6.22 6.22H21a.75.75 0 0 1 0 1.5H4.81l6.22 6.22a.75.75 0 1 1-1.06 1.06l-7.5-7.5a.75.75 0 0 1 0-1.06l7.5-7.5a.75.75 0 0 1 1.06 0z"
            clip-rule="evenodd"
          />
        </svg>
        <div class="text-xs font-normal">Previous post</div>
        <div class="font-semibold">
          <%= @prev.abbr %>
        </div>
      </a>
      <a
        :if={@next}
        href={"/blog/#{@next.slug}"}
        title={@next.title}
        class="flex flex-col items-end text-right"
      >
        <div class="text-xs font-normal">Next post</div>
        <div class="font-semibold">
          <%= @next.abbr %>
        </div>
        <svg
          xmlns="http://www.w3.org/2000/svg"
          fill="currentColor"
          width="24"
          height="24"
          viewbox="0 0 24 24"
        >
          <path
            fill-rule="evenodd"
            d="M12.97 3.97a.75.75 0 0 1 1.06 0l7.5 7.5a.75.75 0 0 1 0 1.06l-7.5 7.5a.75.75 0 1 1-1.06-1.06l6.22-6.22H3a.75.75 0 0 1 0-1.5h16.19l-6.22-6.22a.75.75 0 0 1 0-1.06z"
            clip-rule="evenodd"
          />
        </svg>
      </a>
    </nav>

    <div class="relative my-10 block xl:hidden">
      <div class="absolute inset-0 flex items-center" aria-hidden="true">
        <div class="border-navy-300 w-full border-t"></div>
      </div>
      <div class="relative flex justify-start">
        <span class="bg-slate-50 pr-3 text-base font-semibold uppercase leading-6 dark:bg-navy-900">
          Read Next
        </span>
      </div>
    </div>
    """
  end

  attr :post, :map
  attr :class, :string, default: nil

  def left_nav(assigns) do
    parsed_blog =
      __MODULE__
      |> apply(assigns.post.body, [assigns])
      |> parse_blog()

    assigns =
      assigns
      |> assign(
        headers: extract_headers(parsed_blog),
        reading_time: reading_time(parsed_blog)
      )

    ~H"""
    <aside class={["flex flex-col", @class]}>
      <div
        class="mb-10 py-1 pr-5"
        id="authors"
        data-file={__ENV__.file}
        data-line={__ENV__.line}
        phx-hook={Application.fetch_env!(:derpy_tools, :show_inspector?) && "SourceInspector"}
      >
        <div>
          <%!-- Use Author Image Carousel --%>
          <a :for={author <- @post.authors} href={"/author/#{author.slug}"}>
            <img
              data-src={
                "local:///images/avatar/#{author.avatar}"
                |> Imgproxy.new()
                |> Imgproxy.resize(128, 128)
                |> to_string()
              }
              class="lozad aspect-square w-[64px] rounded-full"
              alt={author.name}
              id={author.slug}
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
        <time datetime={@post.release_date}>
          <%= Timex.format!(@post.release_date, "{Mshort}, {D} {YYYY}") %>
        </time>
        <br />
        <%= Timex.Format.DateTime.Formatters.Relative.format!(@post.release_date, "{relative}") %> |
        <span><%= @reading_time %> read</span>
        <br />
        <span><%= @post.star_rating %> / 5</span>
      </div>
      <.table_of_contents headers={@headers} />
    </aside>
    """
  end

  attr :post, :map
  attr :class, :string, default: nil

  def right_nav(assigns) do
    parsed_blog =
      __MODULE__
      |> apply(assigns.post.body, [assigns])
      |> parse_blog()

    assigns =
      assigns
      |> assign(reading_time: reading_time(parsed_blog))

    related_posts =
      Posts.fetch_posts_by_tag(
        Pathex.get(
          assigns,
          path(:post / :tags / 0 / :slug)
        ),
        Pathex.get(assigns, path(:post / :slug))
      )

    assigns = assign(assigns, related_posts: related_posts)

    ~H"""
    <div
      class={["py-1 xl:px-5", @class]}
      id="recent-articles"
      data-file={__ENV__.file}
      data-line={__ENV__.line}
      phx-hook={Application.fetch_env!(:derpy_tools, :show_inspector?) && "SourceInspector"}
    >
      <h5
        id="toc"
        class="mb-5 text-sm font-semibold leading-6 text-slate-900 dark:text-slate-100"
        phx-hook="TableOfContents"
      >
        Related Articles
      </h5>
      <ul>
        <li
          :for={post <- @related_posts}
          class="mb-5 flex items-center border-b-2 border-dashed pb-5 dark:border-b-navy-400"
        >
          <img
            src={
              "local:///images/#{post.banner}"
              |> Imgproxy.new()
              |> Imgproxy.resize(128, 128, type: "fill")
              |> to_string()
            }
            class="w-[64px] aspect-square flex-initial rounded-md shadow dark:shadow-gray-800"
            alt={post.title}
          />

          <div class="ml-3 flex-initial truncate">
            <a class="font-semibold hover:text-indigo-600" href={post.slug} alt={post.title}>
              <%= post.abbr %>
            </a>
            <p class="text-sm text-slate-400">
              <%= Timex.Format.DateTime.Formatters.Relative.format!(post.release_date, "{relative}") %> | <%= @reading_time %> read
            </p>
            <span><%= post.star_rating %></span>
          </div>
        </li>
      </ul>
    </div>
    """
  end

  defp parse_blog(function_component) do
    function_component.static
    |> Floki.parse_fragment!()
    |> Floki.find("article")
  end

  defp extract_headers([parsed_blog]) do
    parsed_blog
    |> Floki.children()
    |> Enum.filter(&match?({name, _, _} when name in ~w(h2 h3 h4 h5), &1))
    |> Enum.map(fn
      {header, meta, [{"a", _, [title | _]} | _rest]} ->
        {_, id} = Enum.find(meta, &match?({"id", _}, &1))
        {header, id, title |> String.trim()}

      {header, meta, [title | _rest]} ->
        {_, id} = Enum.find(meta, &match?({"id", _}, &1))
        {header, id, title |> String.trim()}
    end)
    |> Enum.reduce([], fn
      {"h2", id, title}, acc ->
        [%{header: "h2", id: id, title: title, children: []} | acc]

      {"h3", id, title}, acc ->
        children = path(0 / :children)

        Pathex.set!(acc, children, [
          %{header: "h3", id: id, title: title, children: []} | Pathex.get(acc, children)
        ])

      {"h4", id, title}, acc ->
        children = path(0 / :children / 0 / :children)

        Pathex.set!(acc, children, [
          %{header: "h4", id: id, title: title, children: []} | Pathex.get(acc, children)
        ])

      {"h5", id, title}, acc ->
        children = path(0 / :children / 0 / :children / 0 / :children)

        Pathex.set!(acc, children, [
          %{header: "h5", id: id, title: title, children: nil} | Pathex.get(acc, children)
        ])
    end)
    |> Enum.reverse()
  end

  defp reading_time(parsed_blog) do
    parsed_blog
    |> Floki.text()
    |> String.replace(~r/@|#|\$|%|&|\^|:|_|!|,/u, " ")
    |> String.split()
    |> Enum.count()
    |> div(@wpm)
    |> Timex.Duration.from_minutes()
    |> Timex.Format.Duration.Formatter.format(:humanized)
  end

  defp source_set(url, sizes) do
    sizes
    |> Enum.map_join(",\n\t", fn size ->
      img_url =
        "local:///images/#{url}"
        |> Imgproxy.new()
        |> Imgproxy.resize(size, size)
        |> to_string()

      "#{img_url} #{size}w"
    end)
  end
end
