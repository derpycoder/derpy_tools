defmodule DerpyToolsWeb.TermsAndConditionsLive do
  use DerpyToolsWeb, :live_view

  def render(assigns) do
    ~H"""
    Terms and Conditions
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
