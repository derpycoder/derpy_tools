defmodule DerpyTools.Meilisearch.Blog do
  alias DerpyTools.Meilisearch.Global

  def search(:posts, query) do
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

    %{Global.get_default_search_result() | blog_posts: result.body}
  end

  def search(:tags, query) do
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

    %{Global.get_default_search_result() | blog_tags: result.body}
  end

  def search(:authors, query) do
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

    %{Global.get_default_search_result() | blog_authors: result.body}
  end
end
