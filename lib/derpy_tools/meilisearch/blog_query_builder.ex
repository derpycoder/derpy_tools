defmodule DerpyTools.Meilisearch.BlogQueryBuilder do
  alias DerpyTools.Meilisearch

  @default_search_result Meilisearch.get_default_search_result()

  @pre_tag Meilisearch.get_pre_tag()
  @post_tag Meilisearch.get_post_tag()

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
          highlightPreTag: @pre_tag,
          highlightPostTag: @post_tag,
          showRankingScore: true,
          q: query
        }
      )

    %{@default_search_result | blog_posts: result.body}
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
          highlightPreTag: @pre_tag,
          highlightPostTag: @post_tag,
          showRankingScore: true,
          q: query
        }
      )

    %{@default_search_result | blog_tags: result.body}
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
          highlightPreTag: @pre_tag,
          highlightPostTag: @post_tag,
          showRankingScore: true,
          q: query
        }
      )

    %{@default_search_result | blog_authors: result.body}
  end
end