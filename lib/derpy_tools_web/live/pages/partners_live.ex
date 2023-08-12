defmodule DerpyToolsWeb.PartnersLive do
  use DerpyToolsWeb, :live_view

  def render(assigns) do
    ~H"""
    Listing of all partner affiliate programs.
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
