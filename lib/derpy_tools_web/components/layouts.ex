defmodule DerpyToolsWeb.Layouts do
  @moduledoc """
  Embeds layouts.
  """
  use DerpyToolsWeb, :html

  embed_templates "layouts/*"
end
