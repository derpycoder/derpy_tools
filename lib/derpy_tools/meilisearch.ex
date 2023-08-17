defmodule DerpyTools.Meilisearch do
  alias DerpyTools.Meilisearch.BlogIndex

  def init do
    BlogIndex.create()
    BlogIndex.configure()
    BlogIndex.upload()
  end
end
