defmodule DerpyTools.Posts do
  @star_ratings %{
    1.0 => "★",
    1.5 => "★☆",
    2.0 => "★★",
    2.5 => "★★☆",
    3.0 => "★★★",
    3.5 => "★★★☆",
    4.0 => "★★★★",
    4.5 => "★★★★☆",
    5.0 => "★★★★★"
  }
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
      body: :taskfile_a_sensible_makefile_and_shell_script_alternative,
      star_rating: @star_ratings[4.5]
    }
  ]

  # TODO: bottom nav, side nav, tag cloud, tag page, author page, main blog page, recent articles.

  def fetch_posts() do
    @posts
  end

  def fetch_post_by_slug(post_slug) do
    @posts
    |> Enum.find(fn %{slug: slug} -> slug == post_slug end)
  end
end
