defmodule DerpyTools.DataStore.Posts do
  @moduledoc """
  Static metadata related to all the blog posts. Perhaps later, it can be moved the database.
  """

  # UUIDv7.generate()

  @tags %{
    "best-of-the-best" => %{
      uid: "018a022d-05ff-7c26-8a72-4cba3263bbec",
      slug: "best-of-the-best",
      label: "Best Of The Best",
      description: """
      I have curated the best of the best tools, that I discovered after trying out as many alternatives as humanly possible, for your kind perusal. Let's discover what the world has to offer together.
      """,
      banner:
        "https://images.unsplash.com/photo-1614036417651-efe5912149d8?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxMTc3M3wwfDF8c2VhcmNofDR8fHRyb3BoeXxlbnwwfHx8fDE2NzU4NDcwMTQ&ixlib=rb-4.0.3&q=80&w=2000"
    },
    "cli" => %{
      uid: "018a022d-0ecb-7b0d-96db-1e2dfcdae571",
      slug: "cli",
      label: "Command Line Tools",
      description: """
      Here's a list of awesome command line tools, that I discovered, that just blows all the GUI out of the water when it comes to performance and automation. Let's automate everything together.
      """,
      banner:
        "https://images.unsplash.com/photo-1518432031352-d6fc5c10da5a?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxMTc3M3wwfDF8c2VhcmNofDJ8fGxpbnV4fGVufDB8fHx8MTY3NTg0ODU1NA&ixlib=rb-4.0.3&q=80&w=2000"
    },
    "blogging-tools" => %{
      uid: "018a022d-114c-7617-97e0-1519eff00395",
      slug: "blogging-tools",
      label: "Blogging Tools",
      description: """
      I have collated a list of tools, after a ton of research, to aid your blogging journey, and some tricks and tips to go along with it. Let's blog and grow together.
      """,
      banner:
        "https://images.unsplash.com/photo-1535982330050-f1c2fb79ff78?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxMTc3M3wwfDF8c2VhcmNofDg4fHxtYWNib29rfGVufDB8fHx8MTY3NTg0NzY3Mw&ixlib=rb-4.0.3&q=80&w=2000"
    },
    "cheat-sheets" => %{
      uid: "018a0233-20b3-79b9-ba10-28f126087cb8",
      slug: "cheat-sheets",
      label: "Cheat Sheets",
      description: """
      Collection of cool tips and tricks in one place for all topics, ranging from front-end web development to backend, to Linux tooling. Hope they act as a reminder when we forget.
      """,
      banner:
        "https://images.unsplash.com/photo-1516031190212-da133013de50?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxMTc3M3wwfDF8c2VhcmNofDE3fHxsaXN0fGVufDB8fHx8MTY4MDg0NDA0Mw&ixlib=rb-4.0.3&q=80&w=2000"
    },
    "comparisons" => %{
      uid: "018a0233-e18f-7f71-8af5-c7b1f8944b10",
      slug: "comparisons",
      label: "Comparisons",
      description: """
      I compare as many tools as I can, putting in significant time, to discover their pros and cons, which I then present in a succinct and visual manner. Let's discover all the alternatives together.
      """,
      banner:
        "https://images.unsplash.com/photo-1657310217253-176cd053e07e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxMTc3M3wxfDF8c2VhcmNofDF8fGNvbG9yc3xlbnwwfHx8fDE2NzU4NDgxMDk&ixlib=rb-4.0.3&q=80&w=2000"
    },
    "frontend-tools" => %{
      uid: "018a0235-47d6-72eb-8476-e04db653e051",
      slug: "frontend-tools",
      label: "Frontend Tools",
      description: """
      Here's a list of curated JavaScript-based tools, that I discovered during my personal escapades, which make web development easier. Let's create and use them together.
      """,
      banner:
        "https://images.unsplash.com/photo-1543966888-7c1dc482a810?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxMTc3M3wwfDF8c2VhcmNofDE2fHxqYXZhc2NyaXB0fGVufDB8fHx8MTY3NTg0OTQxOA&ixlib=rb-4.0.3&q=80&w=2000"
    },
    "software-as-a-service" => %{
      uid: "018a023a-70e1-7936-b52f-d97c18dfb8e1",
      slug: "software-as-a-service",
      label: "Software as a Service",
      description: """
      Here's a collection of Software as a Service, that I find useful and maybe even use day to day, for you to checkout. Let's discover new ones together.
      """,
      banner:
        "https://images.unsplash.com/photo-1551288049-bebda4e38f71?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxMTc3M3wwfDF8c2VhcmNofDJ8fGFuYWx5dGljc3xlbnwwfHx8fDE2NzU4NDg3MjQ&ixlib=rb-4.0.3&q=80&w=2000"
    }
  }

  @authors %{
    "derpycoder" => %{
      uid: "018a0295-77ec-7000-a297-cfa33c5ce8a4",
      slug: "derpycoder",
      name: "Abhijit Kar",
      alias: "Derpy Coder",
      email: "abhijit@derpytools.com",
      website: "https://derpytools.com",
      twitter: "https://twitter.com/DerpyCoder",
      bio: "Software Engineer | Tech Enthusiast | Tinkerer | Blogger",
      avatar: "derpycoder.png"
    }
  }

  @posts_map %{
    "croc-easily-send-files-across-computers-with-this-modern-alternative-to-magic-wormhole" => %{
      uid: "0189feaf-e0c3-7404-953b-96f9e23ca4f6",
      slug:
        "croc-easily-send-files-across-computers-with-this-modern-alternative-to-magic-wormhole",
      title:
        "CROC: Easily Send Files Across Computers with this Modern Alternative to Magic Wormhole",
      abbr: "CROC: Easily Send Files Across",
      banner: "send-wallpapers-using-croc.png",
      tags: [@tags["best-of-the-best"]],
      description: """
      After fumbling with countless flimsy pairing and WiFi file-sharing apps, I discovered a CLI tool that will let us send files across computers with ease. Comes in handy when sharing files with systems that are not in the vicinity, like Web Servers or your friend's computer.
      """,
      authors: [@authors["derpycoder"]],
      # DateTime.utc_now()
      release_date: ~D[2023-04-12],
      body: :croc_easily_send_files_across_computers,
      star_rating: 4.5
    },
    "multipass-instant-ubuntu-virtual-machines-on-your-computer" => %{
      uid: "0189feaf-febb-71b7-8942-619e4fa0d716",
      slug: "multipass-instant-ubuntu-virtual-machines-on-your-computer",
      title: "Multipass: Instant Ubuntu Virtual Machines on your Computer",
      abbr: "Multipass: Instant Ubuntu VMs",
      banner: "remote-ubuntu-desktop.png",
      tags: [@tags["best-of-the-best"], @tags["cli"]],
      description: """
      Multipass is the easiest way to instantly stand up Ubuntu Virtual Machines on your computer, It brings the convenience and ease of using Homebrew to Virtual Machines.
      """,
      authors: [@authors["derpycoder"]],
      # DateTime.utc_now()
      release_date: ~D[2023-03-14],
      body: :multipass_instant_ubuntu_virtual_machine,
      star_rating: 4.5
    },
    "5-ways-to-embed-code-snippets-compared-github-gists-vs-prismjs-vs-screenshots-vs-codepen-vs-chroma" =>
      %{
        uid: "0189feb0-2342-7bc2-959d-d66a1a92319e",
        slug:
          "5-ways-to-embed-code-snippets-compared-github-gists-vs-prismjs-vs-screenshots-vs-codepen-vs-chroma",
        title:
          "5 Ways to Embed Code Snippets Compared: GitHub Gists vs PrismJS vs Screenshots vs Codepen vs Chroma",
        abbr: "5 Ways to Embed Code Snippets Compared",
        banner: "code-snippet-embed.png",
        description: """
          I am sure you have the same problem as I did when I started writing my blogs. How do I get the best-looking code snippet possible? How to embed it efficiently? How to make the copy button work? Well, I got all the answers.
        """,
        tags: [@tags["blogging-tools"]],
        authors: [@authors["derpycoder"]],
        release_date: ~D[2023-01-27],
        body: :ways_to_embed_code_snippets,
        star_rating: 4
      },
    "taskfile-a-sensible-makefile-and-shell-script-alternative" => %{
      uid: "0189feaf-8cef-767d-94d9-b29bdb0a3458",
      slug: "taskfile-a-sensible-makefile-and-shell-script-alternative",
      title: "Taskfile: A Sensible Makefile and Shell Script Alternative",
      abbr: "Taskfile: A Sensible Makefile Alternative",
      banner: "taskfile-in-action.png",
      tags: [@tags["best-of-the-best"], @tags["cli"]],
      description: """
      Taskfile is here to make your life easier and cheatsheets obsolete. It's a simple, and easy alternative to writing your shell scripts manually, or maintaining a Makefile.
      """,
      authors: [@authors["derpycoder"]],
      # DateTime.utc_now()
      release_date: ~D[2023-01-27],
      body: :taskfile_a_sensible_makefile_and_shell_script_alternative,
      star_rating: 5
    }
  }

  @posts @posts_map |> Map.values()

  def fetch_posts, do: @posts
  def fetch_tags, do: @tags |> Map.values()
  def fetch_authors, do: @authors |> Map.values()

  def fetch_post_by_slug(post_slug), do: @posts_map[post_slug]

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
end
