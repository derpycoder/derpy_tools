defmodule DerpyTools.Posts do
  @posts [
    %{
      slug: "taskfile-a-sensible-makefile-and-shell-script-alternative",
      id: "taskfile",
      title: "Taskfile: A Sensible Makefile and Shell Script Alternative",
      tags: ~w(BestOfTheBest CLI),
      description: """
      Taskfile is here to make your life easier and cheatsheets obsolete. It's a simple, and easy alternative to writing your shell scripts manually, or maintaining a Makefile.
      """,
      authors: [%{name: "Derpy Coder", slug: "derpycoder"}, %{name: "John Doe", slug: "john"}],
      # DateTime.utc_now()
      created: ~D[2023-01-27],
      body: :taskfile_a_sensible_makefile_and_shell_script_alternative
    }
  ]

  def fetch_posts() do
    @posts
  end

  def fetch_post_by_slug(post_slug) do
    @posts
    |> Enum.find(fn %{slug: slug} -> slug == post_slug end)
  end
end
