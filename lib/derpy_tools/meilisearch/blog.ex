defmodule DerpyTools.Meilisearch.Blog do
  @default_search_result %{
    blog_posts: nil,
    blog_tags: nil,
    blog_authors: nil
  }

  def get_default_search_result(), do: @default_search_result

  def search(""), do: @default_search_result

  def search(">" <> query) do
    result =
      Req.new(
        base_url: "http://localhost:7700",
        auth: {:bearer, Application.fetch_env!(:derpy_tools, :meili_master_key)}
      )
      |> Req.post!(
        url: "/indexes/blog-posts/search",
        json: %{
          attributesToHighlight: ~w(title description),
          highlightPreTag: "<span class=\"text-pink-500\">",
          highlightPostTag: "</span>",
          showRankingScore: true,
          q: query
        }
      )

    %{@default_search_result | blog_posts: result.body}
  end

  def search("#" <> query) do
    result =
      Req.new(
        base_url: "http://localhost:7700",
        auth: {:bearer, Application.fetch_env!(:derpy_tools, :meili_master_key)}
      )
      |> Req.post!(
        url: "/indexes/blog-tags/search",
        json: %{
          attributesToHighlight: ~w(label),
          highlightPreTag: "<span class=\"text-pink-500\">",
          highlightPostTag: "</span>",
          showRankingScore: true,
          q: query
        }
      )

    %{@default_search_result | blog_tags: result.body}
  end

  def search("@" <> query) do
    result =
      Req.new(
        base_url: "http://localhost:7700",
        auth: {:bearer, Application.fetch_env!(:derpy_tools, :meili_master_key)}
      )
      |> Req.post!(
        url: "/indexes/blog-authors/search",
        json: %{
          attributesToHighlight: ~w(name alias),
          highlightPreTag: "<span class=\"text-pink-500\">",
          highlightPostTag: "</span>",
          showRankingScore: true,
          q: query
        }
      )

    %{@default_search_result | blog_authors: result.body}
  end

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
              showRankingScore: true
            },
            %{
              indexUid: "blog-tags",
              q: query,
              attributesToHighlight: ~w(label),
              highlightPreTag: "<span class=\"text-pink-500\">",
              highlightPostTag: "</span>",
              showRankingScore: true
            },
            %{
              indexUid: "blog-authors",
              q: query,
              attributesToHighlight: ~w(name alias),
              highlightPreTag: "<span class=\"text-pink-500\">",
              highlightPostTag: "</span>",
              showRankingScore: true
            }
          ]
        }
      )

    [blog_posts, blog_tags, blog_authors] = result.body["results"]

    %{
      @default_search_result
      | blog_posts: blog_posts,
        blog_tags: blog_tags,
        blog_authors: blog_authors
    }
  end
end
