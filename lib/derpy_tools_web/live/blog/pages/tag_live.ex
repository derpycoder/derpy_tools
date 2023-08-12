defmodule DerpyToolsWeb.TagLive do
  use DerpyToolsWeb, :live_view

  def render(assigns) do
    ~H"""
    Tag details listed here as well as all the posts belonging to a certain tag.
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
