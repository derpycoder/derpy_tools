defmodule DerpyToolsWeb.AuthorsLive do
  use DerpyToolsWeb, :live_view

  def render(assigns) do
    ~H"""
    All authors listed here
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
