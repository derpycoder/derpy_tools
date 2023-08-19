defmodule DerpyTools.Meilisearch.RoutesQueryBuilder do
  alias DerpyTools.Meilisearch

  @default_search_result Meilisearch.get_default_search_result()

  @pre_tag Meilisearch.get_pre_tag()
  @post_tag Meilisearch.get_post_tag()

  def search(:routes, query) do
    result =
      Req.new(
        base_url: "http://localhost:7700",
        auth: {:bearer, Application.fetch_env!(:derpy_tools, :meili_master_key)}
      )
      |> Req.post!(
        url: "/indexes/routes/search",
        json: %{
          attributesToHighlight: ["name"],
          highlightPreTag: @pre_tag,
          highlightPostTag: @post_tag,
          q: query
        }
      )

    %{
      @default_search_result
      | routes: result.body,
        total_hits: result.body["estimatedTotalHits"],
        processing_time: result.body["processingTimeMs"]
    }
  end
end
