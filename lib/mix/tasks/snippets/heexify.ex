defmodule Mix.Tasks.Snippets.Heexify do
  @moduledoc """
  Visit: https://swapoff.org/chroma/playground/ to decide on lexer & theme.

  Snip files should have the following structure:
  1. filename.lexer.theme.snip
  2. filename.lexer.theme.(0,5).snip (With optional copyable lines for bash scripts)

  e.g. caddyfile.caddy.catppuccin-macchiato.snip

  Use: chroma --list to see all the themes & lexers.
  """
  require Logger
  @template Path.join(["assets", "code_snippet_template.html.heex"])
  @snippets_directory Path.join(["assets", "snippets"])
  @destination_directory Path.join(["lib", "derpy_tools_web", "components", "_snippets"])

  def run(_args) do
    @snippets_directory
    |> Path.join("**/*.snip")
    |> Path.wildcard()
    |> Enum.each(fn path ->
      [filename, lexer, theme, lines] = path |> extract_options()

      destination_sub_directory =
        path
        |> Path.relative_to(@snippets_directory)
        |> Path.dirname()

      target_snippet_file =
        if destination_sub_directory,
          do:
            Path.join([@destination_directory, destination_sub_directory, "#{filename}.html.heex"]),
          else: Path.join([@destination_directory, "#{filename}.html.heex"])

      File.rm_rf!(target_snippet_file)

      id =
        "i" <> (:crypto.strong_rand_bytes(7) |> Base.url_encode64() |> binary_part(0, 7))

      css =
        case System.cmd("chroma", [
               "--lexer=#{lexer}",
               "--formatter=html",
               "--style=#{theme}",
               "--html-styles",
               path
             ]) do
          {css, 0} ->
            css
            |> String.replace("chroma", id)
            |> String.replace(~r"\/\*.*\*\/", "")

          _ ->
            nil
        end

      html =
        case System.cmd("chroma", [
               "--lexer=#{lexer}",
               "--formatter=html",
               "--style=#{theme}",
               "--html-only",
               path
             ]) do
          {html, 0} ->
            html
            |> String.replace("<pre class=\"chroma\">", "<pre class=\"#{id}\">")
            |> String.replace(
              ~r/<span class="cl"><span class="k">([\$❯])<\/span>/u,
              "<span class=\"cl\"><span class=\"select-none\">\\1<\/span>"
            )

          _ ->
            nil
        end

      Mix.Generator.copy_template(
        @template,
        target_snippet_file,
        %{
          id: id,
          css: css,
          html: html,
          lines: lines
        },
        force: true
      )
    end)
  end

  defp extract_options(path) do
    path
    |> Path.basename()
    |> Path.rootname()
    |> String.split(".")
    |> options()
  end

  defp options([filename, lexer, theme] = list) when length(list) == 3,
    do: [filename, lexer, theme, nil]

  defp options([filename, lexer, theme, lines] = list) when length(list) == 4,
    do: [filename, lexer, theme, lines |> String.replace(~r/[\(\)]/, "")]
end
