defmodule DerpyToolsWeb.ToolsLive do
  use DerpyToolsWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    Tools
    """
  end
end
