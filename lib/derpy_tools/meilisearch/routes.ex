defmodule DerpyTools.Meilisearch.Routes do
  alias DerpyTools.Meilisearch.Global

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
          highlightPreTag: "<span class=\"text-pink-500\">",
          highlightPostTag: "</span>",
          q: query
        }
      )

    %{Global.get_default_search_result() | routes: result.body}
  end
end
