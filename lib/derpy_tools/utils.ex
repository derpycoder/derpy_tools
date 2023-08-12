defmodule DerpyTools.Utils do
  @moduledoc """
  Common utils for use across projects.
  """
  def sponge_bob_text(text) do
    text
    |> String.graphemes()
    |> Enum.map(fn ch ->
      case Enum.random(["upcase", "downcase"]) do
        "upcase" -> String.upcase(ch)
        "downcase" -> String.downcase(ch)
      end
    end)
    |> Enum.into("")
  end
end
