defmodule Mix.Tasks.Snippets.Heexify do
  @moduledoc """
  https://swapoff.org/chroma/playground/
  """
  require Logger
  @snippets Path.join(["assets", "snippets", "**/*.snip"])
  @internal_destination Path.join(["lib", "derpy_tools_web", "components", "snippets"])

  def run(_args) do
    @snippets
    |> Path.wildcard()
    |> Enum.map(fn path ->
      [filename, lexer, theme] =
        path
        |> String.replace(@snippets <> "/", "")
        |> String.split(".")
        |> Enum.take(3)

      random_name =
        "sn-" <> (:crypto.strong_rand_bytes(10) |> Base.url_encode64() |> binary_part(0, 8))

      pre =
        case System.cmd("chroma", [
               "--lexer=#{lexer}",
               "--formatter=html",
               "--style=#{theme}",
               #  "--html-prefix=#{random_name}-",
               #  "--html-lines",
               #  "--html-linkable-lines",
               "--html-only",
               path
             ]) do
          {snippet, 0} -> snippet
          _ -> nil
        end

      style =
        case System.cmd("chroma", [
               "--lexer=#{lexer}",
               "--formatter=html",
               "--style=#{theme}",
               #  "--html-prefix=#{random_name}-",
               #  "--html-lines",
               #  "--html-linkable-lines",
               "--html-styles",
               path
             ]) do
          {style, 0} -> style
          _ -> nil
        end

      {filename, style, pre, random_name}
    end)
    |> Enum.each(fn {filename, style, pre, random_name} ->
      style = style |> String.replace("chroma", random_name)

      style = style |> String.replace(~r"\/\*.*\*\/", "")

      pre = pre |> String.replace("<pre class=\"chroma\">", "<pre class=\"#{random_name}\">")

      filename = filename |> String.replace(Path.join(["assets", "snippets"]), "")

      # unless File.exists?(Path.join(@internal_destination, "#{filename}.html.heex")) do
      Mix.Generator.copy_template(
        "assets/snippet.html.heex",
        Path.join(@internal_destination, "#{filename}.html.heex"),
        %{
          style: style,
          body: pre,
          name: random_name
        },
        force: true
      )

      # else
      #   Logger.info("Skipping: #{filename}")
      # end

      Mix.Task.run("format")
    end)
  end
end
