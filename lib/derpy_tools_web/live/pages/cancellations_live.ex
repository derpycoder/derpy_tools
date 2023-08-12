defmodule DerpyToolsWeb.CancellationLive do
  use DerpyToolsWeb, :live_view

  def render(assigns) do
    ~H"""
    Cancellation
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
