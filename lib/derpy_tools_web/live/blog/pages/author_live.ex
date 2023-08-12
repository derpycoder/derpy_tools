defmodule DerpyToolsWeb.AuthorLive do
  use DerpyToolsWeb, :live_view

  def render(assigns) do
    ~H"""
    Author Details Here
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
