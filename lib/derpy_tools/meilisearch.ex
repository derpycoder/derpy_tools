defmodule DerpyTools.Meilisearch do
  alias DerpyTools.Meilisearch.{BlogIndex, BlogQueryBuilder}
  alias DerpyTools.Meilisearch.{RoutesIndex, RoutesQueryBuilder}

  @default_search_result %{
    blog_posts: nil,
    blog_tags: nil,
    blog_authors: nil,
    routes: nil,
    total_hits: nil,
    processing_time: nil,
    show_hints?: false
  }

  @pre_tag "<span class=\"text-pink-500\">"
  @post_tag "</span>"

  def get_default_search_result, do: @default_search_result
  def get_non_empty_search_result, do: search(" ")

  def get_pre_tag, do: @pre_tag
  def get_post_tag, do: @post_tag

  def init do
    BlogIndex.init()
    RoutesIndex.init()
  end

  def search(""), do: search(" ")

  def search(">" <> query), do: BlogQueryBuilder.search(:posts, query)
  def search("#" <> query), do: BlogQueryBuilder.search(:tags, query)
  def search("@" <> query), do: BlogQueryBuilder.search(:authors, query)

  def search("/" <> query), do: RoutesQueryBuilder.search(:routes, query)

  def search("?" <> _query), do: %{@default_search_result | show_hints?: true}

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
              highlightPreTag: @pre_tag,
              highlightPostTag: @post_tag,
              showRankingScore: true,
              limit: 4,
              offset: 0
            },
            %{
              indexUid: "blog-tags",
              q: query,
              attributesToHighlight: ~w(label),
              highlightPreTag: @pre_tag,
              highlightPostTag: @post_tag,
              showRankingScore: true,
              limit: 6,
              offset: 0
            },
            %{
              indexUid: "blog-authors",
              q: query,
              attributesToHighlight: ~w(name alias),
              highlightPreTag: @pre_tag,
              highlightPostTag: @post_tag,
              showRankingScore: true,
              limit: 2,
              offset: 0
            },
            %{
              indexUid: "routes",
              q: query,
              attributesToHighlight: ~w(name),
              highlightPreTag: @pre_tag,
              highlightPostTag: @post_tag,
              limit: 8,
              offset: 0
            }
          ]
        }
      )

    [blog_posts, blog_tags, blog_authors, routes] = result.body["results"]

    {total_hits, processing_time} =
      result.body["results"]
      |> Enum.reduce({0, 0}, fn
        result, {total_hits, processing_time} ->
          total_hits = total_hits + result["estimatedTotalHits"]
          processing_time = max(processing_time, result["processingTimeMs"])
          {total_hits, processing_time}
      end)

    %{
      blog_posts: blog_posts,
      blog_tags: blog_tags,
      blog_authors: blog_authors,
      routes: routes,
      total_hits: total_hits,
      processing_time: processing_time,
      show_hints?: false
    }
  end
end
