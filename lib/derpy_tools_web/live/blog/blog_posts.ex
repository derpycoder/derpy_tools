defmodule DerpyToolsWeb.BlogPosts do
  use Phoenix.Component
  alias Phoenix.LiveView.JS

  @wpm 225

  embed_templates "posts/**/*"
  embed_templates "sections/**/*"

  attr :headers, :list

  def table_of_contents(assigns) do
    ~H"""
    <div
      id="table-of-contents"
      class="sticky top-[calc(var(--header-height))] px-5 py-1"
      data-file={__ENV__.file}
      data-line={__ENV__.line}
      phx-hook={Application.fetch_env!(:derpy_tools, :show_inspector?) && "SourceInspector"}
    >
      <h5
        id="toc"
        class="text-slate-900 font-semibold mb-2 text-sm leading-6 dark:text-slate-100"
        phx-hook="TableOfContents"
      >
        On this page
      </h5>
      <a
        href="#"
        class="block py-1 font-medium hover:text-slate-900 dark:text-slate-400 dark:hover:text-slate-300"
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
          data-parent={@parent |> Enum.reject(fn p -> p == "" end) |> Enum.join(">")}
          class={[
            "block py-1 hover:text-slate-900 dark:text-slate-400 dark:hover:text-slate-300",
            case header do
              "h2" -> "font-semibold"
              "h3" -> "font-medium"
              "h4" -> "font-normal"
            end
          ]}
          phx-click={JS.toggle(to: "##{id}-container")}
        >
          <i :if={header in ~w{h3 h4}} class="hero-chevron-right-mini" />
          <span><%= title %></span>
        </a>

        <.nested_header
          :if={children}
          id={"#{id}-container"}
          headers={children |> Enum.reverse()}
          class="pl-4 hidden"
          parent={[id, @parent]}
        />
      </li>
    </ul>
    """
  end

  attr :post, :map
  attr :class, :string, default: nil

  def header(assigns)

  attr :class, :string, default: nil

  def banner(assigns)

  attr :post, :map
  attr :style_nonce, :string
  attr :class, :string, default: nil

  def body(assigns) do
    ~H"""
    <div class={@class}>
      <%= apply(__MODULE__, @post.body, [assigns]) %>
      <.footer />
    </div>
    """
  end

  attr :class, :string, default: nil
  def footer(assigns)

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
        class="mb-10 py-1 px-5"
        id="authors"
        data-file={__ENV__.file}
        data-line={__ENV__.line}
        phx-hook={Application.fetch_env!(:derpy_tools, :show_inspector?) && "SourceInspector"}
      >
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
        <span><%= @reading_time %></span>
      </div>
      <.table_of_contents headers={@headers} />
    </aside>
    """
  end

  attr :class, :string, default: nil
  def right_nav(assigns)

  defp parse_blog(function_component) do
    function_component.static
    |> Floki.parse_fragment!()
    |> Floki.find("article")
  end

  defp extract_headers(parsed_blog) do
    parsed_blog
    |> Enum.at(0)
    |> Floki.children()
    |> Enum.filter(&is_tuple/1)
    |> Enum.filter(fn each -> Tuple.to_list(each) |> Enum.count() == 3 end)
    |> Enum.filter(fn {name, _, _} -> name in ~w(h2 h3 h4) end)
    |> Enum.map(fn
      {header, meta, [{"a", _, [title | _]} | _rest]} ->
        {
          header,
          meta |> Enum.find(&(elem(&1, 0) == "id")) |> elem(1),
          title |> String.replace(~r"\n\s+", "")
        }

      {header, meta, [title | _rest]} ->
        {
          header,
          meta |> Enum.find(&(elem(&1, 0) == "id")) |> elem(1),
          title |> String.replace(~r"\n\s+", "")
        }
    end)
    |> Enum.reduce([], fn
      {"h2", id, title}, acc ->
        [%{header: "h2", id: id, title: title, children: []} | acc]

      {"h3", id, title}, [head | tail] ->
        [
          %{
            head
            | children: [%{header: "h3", id: id, title: title, children: []} | head.children]
          }
          | tail
        ]

      {"h4", id, title}, [head | tail] ->
        [child_head | child_tail] = head.children

        [
          %{
            head
            | children: [
                %{
                  child_head
                  | children: [
                      %{header: "h4", id: id, title: title, children: nil} | child_head.children
                    ]
                }
                | child_tail
              ]
          }
          | tail
        ]
    end)
    |> Enum.reverse()
  end

  defp reading_time(parsed_blog) do
    parsed_blog
    |> Floki.text()
    |> String.replace(~r/@|#|\$|%|&|\^|:|_|!|,/u, " ")
    |> String.split()
    |> Enum.count()
    |> Integer.floor_div(@wpm)
    |> Timex.Duration.from_minutes()
    |> Timex.Format.Duration.Formatter.format(:humanized)
  end
end
