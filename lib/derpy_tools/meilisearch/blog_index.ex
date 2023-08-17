defmodule DerpyTools.Meilisearch.BlogIndex do
  alias DerpyTools.Posts

  def create() do
    meilisearch =
      Req.new(
        base_url: "http://localhost:7700",
        auth: {:bearer, Application.fetch_env!(:derpy_tools, :meili_master_key)}
      )

    Req.post!(meilisearch,
      url: "/indexes",
      json: %{
        uid: "blog-posts",
        primaryKey: "uid"
      }
    )

    Req.post!(meilisearch,
      url: "/indexes",
      json: %{
        uid: "blog-authors",
        primaryKey: "uid"
      }
    )

    Req.post!(meilisearch,
      url: "/indexes",
      json: %{
        uid: "blog-tags",
        primaryKey: "uid"
      }
    )
  end

  def configure() do
    meilisearch =
      Req.new(
        base_url: "http://localhost:7700",
        auth: {:bearer, Application.fetch_env!(:derpy_tools, :meili_master_key)}
      )

    Req.patch!(meilisearch,
      url: "/indexes/blog-authors/settings",
      json: %{
        displayedAttributes: [
          "slug",
          "name",
          "alias",
          "avatar"
        ],
        distinctAttribute: "slug",
        filterableAttributes: [
          "name",
          "alias"
        ],
        searchableAttributes: [
          "name",
          "alias"
        ],
        sortableAttributes: [
          "name",
          "alias"
        ]
      }
    )

    Req.patch!(meilisearch,
      url: "/indexes/blog-posts/settings",
      json: %{
        displayedAttributes: [
          "slug",
          "title",
          "banner",
          "description",
          "tags",
          "release_date"
        ],
        distinctAttribute: "slug",
        filterableAttributes: [
          "tags",
          "release_date"
        ],
        rankingRules: [
          "words",
          "typo",
          "proximity",
          "attribute",
          "sort",
          "exactness",
          "release_date:desc"
        ],
        searchableAttributes: [
          "title",
          "description"
        ],
        sortableAttributes: [
          "release_date"
        ],
        stopWords: ~w(for to and or is in the),
        synonyms: %{
          "cli" => ["Command Line Tools", "Command Line Interface"],
          "Command Line Tools" => ["cli"],
          "computer" => [
            "pc",
            "laptop"
          ],
          "pc" => [
            "computer",
            "laptop"
          ],
          "laptop" => [
            "pc",
            "computer"
          ]
        }
      }
    )

    Req.patch!(meilisearch,
      url: "/indexes/blog-tags/settings",
      json: %{
        displayedAttributes: [
          "slug",
          "label"
        ],
        distinctAttribute: "slug",
        filterableAttributes: [
          "label"
        ],
        searchableAttributes: [
          "label"
        ],
        sortableAttributes: [
          "label"
        ],
        synonyms: %{
          "cli" => ["Command Line Tools", "Command Line Interface"],
          "Command Line Interface" => ["cli"]
        }
      }
    )
  end

  def upload() do
    meilisearch =
      Req.new(
        base_url: "http://localhost:7700",
        auth: {:bearer, Application.fetch_env!(:derpy_tools, :meili_master_key)}
      )

    Req.post!(meilisearch,
      url: "/indexes/blog-authors/documents?primaryKey=uid",
      json:
        Posts.fetch_authors()
        |> Enum.map(fn author ->
          %{
            uid: author.uid,
            slug: author.slug,
            name: author.name,
            alias: author.alias,
            avatar: author.avatar
          }
        end)
    )

    Req.post!(meilisearch,
      url: "/indexes/blog-posts/documents?primaryKey=uid",
      json:
        Posts.fetch_posts()
        |> Enum.map(fn post ->
          %{
            uid: post.uid,
            slug: post.slug,
            title: post.title,
            banner: post.banner,
            description: post.description,
            tags: post.tags |> Enum.map(fn tag -> tag.label end),
            release_date: post.release_date |> Timex.to_unix()
          }
        end)
    )

    Req.post!(meilisearch,
      url: "/indexes/blog-tags/documents?primaryKey=uid",
      json:
        Posts.fetch_tags()
        |> Enum.map(fn tag ->
          %{
            uid: tag.uid,
            slug: tag.slug,
            label: tag.label
          }
        end)
    )
  end
end
