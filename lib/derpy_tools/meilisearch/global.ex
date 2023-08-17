defmodule DerpyTools.Meilisearch.Global do
  @default_search_result %{
    blog_posts: nil,
    blog_tags: nil,
    blog_authors: nil,
    routes: nil
  }

  def get_default_search_result(), do: @default_search_result

  def search(""), do: @default_search_result

  def search(query) do
    blog_result = DerpyTools.Meilisearch.Blog.search(query)
    routes_result = DerpyTools.Meilisearch.Routes.search(query)

    %{
      blog_posts: blog_result.blog_posts,
      blog_tags: blog_result.blog_tags,
      blog_authors: blog_result.blog_authors,
      routes: routes_result.routes
    }
  end
end
