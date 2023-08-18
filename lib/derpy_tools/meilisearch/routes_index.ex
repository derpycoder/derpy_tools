defmodule DerpyTools.Meilisearch.RoutesIndex do
  alias DerpyTools.DataStore.Routes
  def init() do
    create()
    configure()
    upload()
  end

  def create() do
    meilisearch =
      Req.new(
        base_url: "http://localhost:7700",
        auth: {:bearer, Application.fetch_env!(:derpy_tools, :meili_master_key)}
      )

    Req.post!(meilisearch,
      url: "/indexes",
      json: %{
        uid: "routes",
        primaryKey: "id"
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
      url: "/indexes/routes/settings",
      json: %{
        displayedAttributes: ~w(slug name type method),
        distinctAttribute: "slug",
        filterableAttributes: ~w(name type),
        searchableAttributes: ~w(name),
        sortableAttributes: ~w(name)
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
      url: "/indexes/routes/documents?primaryKey=id",
      json: Routes.fetch_routes()
    )
  end
end
