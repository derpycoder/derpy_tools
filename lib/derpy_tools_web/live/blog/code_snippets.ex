defmodule DerpyToolsWeb.CodeSnippets do
  use Phoenix.Component

  embed_templates "code_snippets/**/*"

  attr :snippet, :atom
  attr :style_nonce, :string

  def render(assigns) do
    ~H"""
    <%= apply(__MODULE__, @snippet, [assigns]) %>
    """
  end
end
