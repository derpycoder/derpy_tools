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
      tags: [
        %{
          slug: "best-of-the-best",
          label: "Best Of The Best"
        },
        %{
          slug: "cli",
          label: "Command Line Tools"
        }
      ],
      description: """
      Taskfile is here to make your life easier and cheatsheets obsolete. It's a simple, and easy alternative to writing your shell scripts manually, or maintaining a Makefile.
      """,
      authors: [%{name: "Derpy Coder", slug: "derpycoder"}, %{name: "John Doe", slug: "john"}],
      # DateTime.utc_now()
      created: ~D[2023-01-27],
      body: :taskfile_a_sensible_makefile_and_shell_script_alternative,
      star_rating: @star_ratings[4.5]
    },
    %{
      slug:
        "croc-easily-send-files-across-computers-with-this-modern-alternative-to-magic-wormhole",
      id: "croc",
      title:
        "CROC: Easily Send Files Across Computers with this Modern Alternative to Magic Wormhole",
      tags: [
        %{
          slug: "best-of-the-best",
          label: "Best Of The Best"
        }
      ],
      description: """
      After fumbling with countless flimsy pairing and WiFi file-sharing apps, I discovered a CLI tool that will let us send files across computers with ease. Comes in handy when sharing files with systems that are not in the vicinity, like Web Servers or your friend's computer.
      """,
      authors: [%{name: "Derpy Coder", slug: "derpycoder"}, %{name: "John Doe", slug: "john"}],
      # DateTime.utc_now()
      created: ~D[2023-04-12],
      body: :croc_easily_send_files_across_computers,
      star_rating: @star_ratings[4.5]
    },
    %{
      slug: "multipass-instant-ubuntu-virtual-machines-on-your-computer",
      id: "multipass",
      title: "Multipass: Instant Ubuntu Virtual Machines on your Computer",
      tags: [
        %{
          slug: "cli",
          label: "Command Line Tools"
        }
      ],
      description: """
      Multipass is the easiest way to instantly stand up Ubuntu Virtual Machines on your computer, It brings the convenience and ease of using Homebrew to Virtual Machines.
      """,
      authors: [%{name: "Derpy Coder", slug: "derpycoder"}, %{name: "John Doe", slug: "john"}],
      # DateTime.utc_now()
      created: ~D[2023-03-14],
      body: :multipass_instant_ubuntu_virtual_machine,
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

  def fetch_posts_by_tag(tag_slug, post_slug) do
    @posts
    |> Enum.filter(fn %{tags: t_tags, slug: t_post_slug} ->
      t_tags
      |> Enum.any?(fn %{slug: slug} -> slug == tag_slug && t_post_slug != post_slug end)
    end)
  end

  def fetch_recent_posts() do
  end

  def fetch_tags() do
  end
end
