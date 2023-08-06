defmodule DerpyToolsWeb.BlogPosts do
  use Phoenix.Component

  embed_templates "posts/*"

  attr :post, :map
  attr :class, :string, default: nil

  def table_of_contents(assigns) do
    headers =
      __MODULE__
      |> apply(assigns.post.body, [assigns])
      |> extract_headers()

    assigns =
      assigns
      |> assign(headers: headers)

    ~H"""
    <ul class={["space-y-1 font-inter font-medium list-none not-prose", @class]}>
      <li :for={{header, id, title} <- @headers} class="not-prose">
        <a
          key={id}
          href={"##{id}"}
          tabindex="0"
          class={[
            "flex cursor-pointer items-center space-x-1.5 rounded px-2 py-1 tracking-wide outline-none transition-all hover:bg-slate-100 hover:text-slate-800 focus:bg-slate-100 focus:text-slate-800 dark:hover:bg-navy-600 dark:hover:text-navy-100 dark:focus:bg-navy-600 dark:focus:text-navy-100",
            case header do
              "h2" -> "pl-4"
              "h3" -> "pl-16"
              "h4" -> "pl-24"
            end
          ]}
        >
          <span><%= title %></span>
        </a>
      </li>
    </ul>
    """
  end

  attr :post, :map
  attr :class, :string, default: nil

  def header(assigns) do
    ~H"""
    <header class={@class}>
      <a href="https://www.derpytools.com/tag/best-of-the-best/">
        <%= inspect(@post.tags) %>
      </a>

      <h1>
        <%= @post.title %>
      </h1>

      <p>
        Taskfile is here to make your life easier and cheatsheets obsolete. It&#x27;s a simple, and easy alternative to writing your shell scripts manually, or maintaining a Makefile.
      </p>
    </header>
    """
  end

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

  def footer(assigns) do
    ~H"""
    <nav>
      <a
        href="https://www.derpytools.com/porkbun-probably-the-best-domain-registrar-i-have-ever-used/"
        title="Porkbun: Probably the Best Domain Registrar I have Ever Used"
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
        <div>Previous post</div>
        <div>
          Porkbun: Probably the Best Domain Registrar I have Ever Used
        </div>
      </a>
      <a
        href="https://www.derpytools.com/5-ways-to-embed-code-snippets-compared-github-gists-vs-prismjs-vs-screenshots-vs-codepen-vs-chroma/"
        title="5 Ways to Embed Code Snippets Compared: GitHub Gists vs PrismJS vs Screenshots vs Codepen vs Chroma"
      >
        <div>Next post</div>
        <div>
          5 Ways to Embed Code Snippets Compared: GitHub Gists vs PrismJS vs Screenshots vs Codepen vs Chroma
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
    """
  end

  defp extract_headers(function_component) do
    function_component.static
    |> Floki.parse_fragment!()
    |> Floki.find("article")
    |> Enum.at(0)
    |> Floki.children()
    |> Enum.filter(&is_tuple/1)
    |> Enum.filter(fn each -> Tuple.to_list(each) |> Enum.count() == 3 end)
    |> Enum.filter(fn {name, _, _} -> name in ~w(h2 h3 h4) end)
    |> Enum.map(fn {header, meta, [title]} ->
      {
        header,
        meta |> Enum.find(&(elem(&1, 0) == "id")) |> elem(1),
        title |> String.replace(~r"\n\s+", "")
      }
    end)
  end
end

# |> Enum.reduce([], fn
#   {"h2", id, title}, acc ->
#     [%{id: id, title: title, children: []} | acc]

#   {"h3", id, title}, [head | tail] ->
#     [%{head | children: [%{id: id, title: title, children: []} | head.children]} | tail]

#   {"h4", id, title}, [head | tail] ->
#     [child_head | child_tail] = head.children

#     [
#       %{
#         head
#         | children: [
#             %{
#               child_head
#               | children: [%{id: id, title: title, children: nil} | child_head.children]
#             }
#             | child_tail
#           ]
#       }
#       | tail
#     ]
# end)
