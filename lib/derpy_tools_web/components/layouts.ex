defmodule DerpyToolsWeb.Layouts do
  @moduledoc """
  Embeds layouts.
  """
  use DerpyToolsWeb, :html

  alias DerpyToolsWeb.CommandPaletteComponent

  embed_templates "layouts/*"
end
