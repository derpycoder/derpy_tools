defmodule DerpyTools.Meilisearch.Global do
  alias DerpyTools.Meilisearch.Blog
  alias DerpyTools.Meilisearch.Routes

  @default_search_result %{
    blog_posts: nil,
    blog_tags: nil,
    blog_authors: nil,
    routes: nil
  }

  def get_default_search_result(), do: @default_search_result
  def get_non_empty_search_result(), do: search(" ")

  def search(""), do: search(" ")

  def search(">" <> query), do: Blog.search(:posts, query)
  def search("#" <> query), do: Blog.search(:tags, query)
  def search("@" <> query), do: Blog.search(:authors, query)

  def search("/" <> query), do: Routes.search(:routes, query)

  def search(query) do
    result =
      Req.new(
        base_url: "http://localhost:7700",
        auth: {:bearer, Application.fetch_env!(:derpy_tools, :meili_master_key)}
      )
      |> Req.post!(
        url: "/multi-search",
        json: %{
          queries: [
            %{
              indexUid: "blog-posts",
              q: query,
              attributesToHighlight: ~w(title description),
              highlightPreTag: "<span class=\"text-pink-500\">",
              highlightPostTag: "</span>",
              showRankingScore: true,
              limit: 4,
              offset: 0
            },
            %{
              indexUid: "blog-tags",
              q: query,
              attributesToHighlight: ~w(label),
              highlightPreTag: "<span class=\"text-pink-500\">",
              highlightPostTag: "</span>",
              showRankingScore: true,
              limit: 6,
              offset: 0
            },
            %{
              indexUid: "blog-authors",
              q: query,
              attributesToHighlight: ~w(name alias),
              highlightPreTag: "<span class=\"text-pink-500\">",
              highlightPostTag: "</span>",
              showRankingScore: true,
              limit: 2,
              offset: 0
            },
            %{
              indexUid: "routes",
              q: query,
              attributesToHighlight: ~w(name),
              highlightPreTag: "<span class=\"text-pink-500\">",
              highlightPostTag: "</span>",
              limit: 8,
              offset: 0
            }
          ]
        }
      )

    [blog_posts, blog_tags, blog_authors, routes] = result.body["results"]

    %{
      @default_search_result
      | blog_posts: blog_posts,
        blog_tags: blog_tags,
        blog_authors: blog_authors,
        routes: routes
    }
  end
end
