defmodule DerpyToolsWeb.TagsLive do
  use DerpyToolsWeb, :live_view

  def render(assigns) do
    ~H"""
    Listing of all the tags
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
