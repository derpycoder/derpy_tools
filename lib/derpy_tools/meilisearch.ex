defmodule DerpyTools.Meilisearch do
  alias DerpyTools.Meilisearch.BlogIndex
  alias DerpyTools.Meilisearch.RoutesIndex

  def init do
    BlogIndex.init()
    RoutesIndex.init()
  end
end
