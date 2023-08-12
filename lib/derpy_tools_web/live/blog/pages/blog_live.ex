defmodule DerpyToolsWeb.BlogLive do
  use DerpyToolsWeb, :live_view

  def render(assigns) do
    ~H"""
    All the blog posts
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
