defmodule DerpyToolsWeb.SupportLive do
  use DerpyToolsWeb, :live_view

  def render(assigns) do
    ~H"""
    Support Page
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
