defmodule DerpyTools.Posts do
  @moduledoc """
  Static metadata related to all the blog posts. Perhaps later, it can be moved the database.
  """

  # UUIDv7.generate()

  @posts [
    %{
      uid: "0189feaf-e0c3-7404-953b-96f9e23ca4f6",
      slug:
        "croc-easily-send-files-across-computers-with-this-modern-alternative-to-magic-wormhole",
      title:
        "CROC: Easily Send Files Across Computers with this Modern Alternative to Magic Wormhole",
      short: "CROC: Easily Send Files Across",
      banner: "send-wallpapers-using-croc.png",
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
      release_date: ~D[2023-04-12],
      body: :croc_easily_send_files_across_computers,
      star_rating: 4.5
    },
    %{
      uid: "0189feaf-febb-71b7-8942-619e4fa0d716",
      slug: "multipass-instant-ubuntu-virtual-machines-on-your-computer",
      title: "Multipass: Instant Ubuntu Virtual Machines on your Computer",
      short: "Multipass: Instant Ubuntu VMs",
      banner: "remote-ubuntu-desktop.png",
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
      Multipass is the easiest way to instantly stand up Ubuntu Virtual Machines on your computer, It brings the convenience and ease of using Homebrew to Virtual Machines.
      """,
      authors: [%{name: "Derpy Coder", slug: "derpycoder"}, %{name: "John Doe", slug: "john"}],
      # DateTime.utc_now()
      release_date: ~D[2023-03-14],
      body: :multipass_instant_ubuntu_virtual_machine,
      star_rating: 4.5
    },
    %{
      uid: "0189feb0-2342-7bc2-959d-d66a1a92319e",
      slug:
        "5-ways-to-embed-code-snippets-compared-github-gists-vs-prismjs-vs-screenshots-vs-codepen-vs-chroma",
      title:
        "5 Ways to Embed Code Snippets Compared: GitHub Gists vs PrismJS vs Screenshots vs Codepen vs Chroma",
      short: "5 Ways to Embed Code Snippets Compared",
      banner: "code-snippet-embed.png",
      description: """
        I am sure you have the same problem as I did when I started writing my blogs. How do I get the best-looking code snippet possible? How to embed it efficiently? How to make the copy button work? Well, I got all the answers.
        5 Ways to Embed Code Snippets Compared: GitHub Gists vs PrismJS vs Screenshots vs Codepen vs Chroma
      """,
      tags: [
        %{
          slug: "blogging-tools",
          label: "Blogging Tools"
        }
      ],
      authors: [%{name: "Derpy Coder", slug: "derpycoder"}, %{name: "John Doe", slug: "john"}],
      poster: "https://www.derpytools.com/content/images/size/w1200/2023/01/banner.webp",
      release_date: ~D[2023-01-27],
      body: :ways_to_embed_code_snippets,
      star_rating: 4
    },
    %{
      uid: "0189feaf-8cef-767d-94d9-b29bdb0a3458",
      slug: "taskfile-a-sensible-makefile-and-shell-script-alternative",
      title: "Taskfile: A Sensible Makefile and Shell Script Alternative",
      short: "Taskfile: A Sensible Makefile Alternative",
      banner: "taskfile-in-action.png",
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
      release_date: ~D[2023-01-27],
      body: :taskfile_a_sensible_makefile_and_shell_script_alternative,
      star_rating: 5
    }
  ]

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

  def fetch_prev_and_next_posts(post_slug) do
    @posts
    |> Enum.find_index(fn post -> post.slug == post_slug end)
    |> fetch_prev_or_next_posts()
  end

  def fetch_prev_or_next_posts(post_index) when post_index > 0 do
    {Enum.at(@posts, post_index + 1), Enum.at(@posts, post_index - 1)}
  end

  def fetch_prev_or_next_posts(_post_index), do: {Enum.at(@posts, 1), nil}

  def fetch_recent_posts() do
  end

  def fetch_tags() do
  end
end
