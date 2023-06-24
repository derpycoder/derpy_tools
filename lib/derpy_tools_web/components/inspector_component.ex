defmodule DerpyToolsWeb.InspectorComponent do
  @moduledoc """
  Useful component for development.
  Can be embedded into other components, which will allow developers to open
  the source code of the component directly from browser.
  """
  use DerpyToolsWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="absolute -top-10 flex justify-end w-full">
      <%!-- To link directly to the storybook page! --%>
      <button class="rounded-tl-lg rounded-bl-lg p-2 bg-slate-100 m-0" title="Show in Catalog">
        <Heroicons.eye solid class="h-3 w-3 text-gray-500" />
      </button>
      <button
        phx-click="inspect-source"
        class="-ml-1 rounded-tr-lg rounded-br-lg p-2 bg-slate-100 m-0 border-l border-slate-200"
        title="Open in VS Code"
        phx-target={@myself}
      >
        <Heroicons.code_bracket solid class="h-3 w-3 text-gray-500" />
      </button>
    </div>
    """
  end

  def handle_event("inspect-source", _params, socket) do
    %{file: file, line: line} = socket.assigns
    System.cmd("code", ["--goto", "#{file}:#{line}"])

    {:noreply, socket}
  end
end
