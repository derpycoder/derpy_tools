defmodule DerpyToolsWeb.BlogPosts do
  use Phoenix.Component

  embed_templates "posts/**/*"
  embed_templates "sections/**/*"

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
    <ul class={[
      "space-y-1 font-inter font-medium list-none not-prose sticky top-[var(--header-height)]",
      @class
    ]}>
      <li :for={{header, id, title} <- @headers} class="not-prose">
        <a
          key={id}
          href={"##{id}"}
          tabindex="0"
          class={[
            "flex cursor-pointer items-center space-x-1.5 rounded px-2 py-1 tracking-wide outline-none transition-all hover:bg-slate-100 hover:text-slate-800 focus:bg-slate-100 focus:text-slate-800 dark:hover:bg-navy-600 dark:hover:text-navy-100 dark:focus:bg-navy-600 dark:focus:text-navy-100",
            case header do
              "h2" -> ""
              "h3" -> "pl-8"
              "h4" -> "pl-16"
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

  def header(assigns)

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
  def left_nav(assigns)

  attr :class, :string, default: nil
  def right_nav(assigns)

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
