defmodule DerpyToolsWeb.ContactUsLive do
  use DerpyToolsWeb, :live_view

  def render(assigns) do
    ~H"""
    Contact US page
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
