defmodule DerpyToolsWeb.IconComponents do
  @moduledoc """
  Icon taken from:
  https://icon-sets.iconify.design

  Why this way?
  https://cloudfour.com/thinks/svg-icon-stress-test/#:~:text=Image%20element%20with%20data%20URI,-Because%20SVGs%20are&text=This%20may%20be%20used%20to,or%20loading%20a%20separate%20file).&text=Across%20all%20browsers%20and%20regardless,and%20with%20the%20least%20deviation.

  Generated using:
  https://yoksel.github.io/url-encoder/
  """
  use Phoenix.Component

  embed_templates "icons/**/*"
end
