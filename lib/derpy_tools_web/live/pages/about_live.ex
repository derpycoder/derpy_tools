defmodule DerpyToolsWeb.AboutLive do
  use DerpyToolsWeb, :live_view

  def render(assigns) do
    ~H"""
    About Page
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
