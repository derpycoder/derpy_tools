defmodule DerpyTools.Routes.Naming do
  @moduledoc """
  Must be kept above the Routes module, so that the title_case function can be invoked from Module Attribute!
  """
  def title_case(title) do
    title
    |> String.trim()
    |> String.split(" ")
    |> Enum.map(fn word ->
      case word |> String.downcase() do
        "" ->
          "Home Page"

        "utm" ->
          "UTM"

        "users" ->
          nil

        word ->
          Phoenix.Naming.humanize(word)
      end
    end)
    |> Enum.join(" ")
    |> String.trim()
  end
end

defmodule DerpyTools.Routes do
  @moduledoc """
  Fetches all the Routes and transforms them for ingestion by Meilisearch.
  """
  @slugs DerpyToolsWeb.Router.__routes__()
         |> Enum.map(fn route -> {route.path, route.verb} end)
         |> Enum.filter(fn
           {path, verb} when verb in ~w(get delete)a -> !(path =~ ":")
           {_, _} -> false
         end)
         |> Enum.map(fn {path, _} -> path end)

  @names @slugs
         |> Enum.map(fn path ->
           path
           |> String.replace(~r"/|_|\-", " ")
           |> DerpyTools.Routes.Naming.title_case()
         end)

  @dynamic_routes Enum.zip(@names, @slugs)
                  |> Enum.map(fn {name, slug} -> %{name: name, slug: slug} end)

  @static_routes [
    %{
      name: "Health",
      slug: "/health",
      type: "json"
    },
    %{
      name: "Stats",
      slug: "/stats",
      type: "json"
    },
    %{
      name: "Version",
      slug: "/version",
      type: "json"
    },
    %{
      name: "Release",
      slug: "/release",
      type: "json"
    }
  ]

  @routes @dynamic_routes ++ @static_routes

  def fetch_routes, do: @routes
end
