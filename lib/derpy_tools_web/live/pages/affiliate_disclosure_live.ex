defmodule DerpyToolsWeb.AffiliateDisclosureLive do
  use DerpyToolsWeb, :live_view

  def render(assigns) do
    ~H"""
    Affiliate Disclosure
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
