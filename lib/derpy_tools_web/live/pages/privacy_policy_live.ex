defmodule DerpyToolsWeb.PrivacyPolicyLive do
  use DerpyToolsWeb, :live_view

  def render(assigns) do
    ~H"""
    Privacy Policy
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
