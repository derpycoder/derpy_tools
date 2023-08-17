defmodule DerpyTools.Meilisearch.Routes do
  @default_search_result %{
    routes: nil
  }

  def get_default_search_result(), do: @default_search_result

  def search(""), do: @default_search_result

  def search("/" <> query) do
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

    %{@default_search_result | routes: result.body}
  end

  def search(query) do
    result =
      Req.new(
        base_url: "http://localhost:7700",
        auth: {:bearer, Application.fetch_env!(:derpy_tools, :meili_master_key)}
      )
      |> Req.post!(
        url: "/indexes/routes/search",
        json: %{
          attributesToHighlight: ~w(name),
          highlightPreTag: "<span class=\"text-pink-500\">",
          highlightPostTag: "</span>",
          q: query
        }
      )

    %{@default_search_result | routes: result.body}
  end
end
