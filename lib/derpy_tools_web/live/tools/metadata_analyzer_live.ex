defmodule DerpyToolsWeb.MetadataParams do
  alias DerpyToolsWeb.MetadataParams
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field(:url, :string)
  end

  def changeset(utm_params, attrs) do
    utm_params
    |> cast(attrs, [:url])
    |> validate_required([:url])
    |> validate_url(:url, message: "URL must be valid")
  end

  def update(attrs) do
    %MetadataParams{}
    |> MetadataParams.changeset(attrs)
    |> apply_action(:update)
  end

  def change_metadata(%MetadataParams{} = utm_params, attrs \\ %{}) do
    MetadataParams.changeset(utm_params, attrs)
  end

  defp validate_url(changeset, field, opts) when is_atom(field) do
    validate_change(changeset, field, fn _, url ->
      uri = URI.parse(url)

      with :ok <- check_empty(uri),
           :ok <- check_schema(uri),
           :ok <- check_host(uri) do
        []
      else
        :error ->
          [{field, {Keyword.get(opts, :message, "Must be valid URL"), [validation: :url]}}]
      end
    end)
  end

  defp check_empty(uri) do
    values = uri |> Map.from_struct() |> Enum.map(fn {_key, val} -> blank?(val) end)

    if Enum.member?(values, false), do: :ok, else: :error
  end

  defp check_schema(%URI{scheme: scheme}) do
    if blank?(scheme), do: :error, else: :ok
  end

  defp check_host(%URI{host: host}) do
    if blank?(host), do: :error, else: :ok
  end

  @compile {:inline, blank?: 1}
  def blank?(""), do: true
  def blank?([]), do: true
  def blank?(nil), do: true
  def blank?({}), do: true
  def blank?(%{} = map) when map_size(map) == 0, do: true
  def blank?(_), do: false
end

defmodule FetchExtraMetadata do
  @doc """
  Prints request and response headers.

  ## Request Options

    * `:print_headers` - if `true`, prints the headers. Defaults to `false`.
    * `:fetch_redirects` - if `true`, gets the metadata related to redirects, like final url, redirects, redirection_trail. Defaults to `false`.
  """
  def attach(%Req.Request{} = request, options \\ []) do
    request
    |> Req.Request.register_options([:fetch_redirects, :print_headers])
    |> Req.Request.merge_options(options)
    |> Req.Request.append_request_steps(print_headers: &print_request_headers/1)
    |> Req.Request.prepend_response_steps(print_headers: &print_response_headers/1)
    |> Req.Request.prepend_response_steps(fetch_redirects: &fetch_redirects/1)
  end

  defp fetch_redirects({%{options: %{fetch_redirects: true}} = request, response}) do
    private =
      request.private
      |> Map.update(
        :trail,
        [{response.status, URI.to_string(request.url)}],
        fn val ->
          [{response.status, URI.to_string(request.url)} | val]
        end
      )

    request = %{request | private: private}

    private =
      response.private
      |> Map.put_new(:redirects, %{
        uri: request.url,
        url: URI.to_string(request.url |> Map.replace(:query, nil)),
        count: Map.get(request.private, :req_redirect_count, 0),
        trail: Map.get(request.private, :trail, [])
      })

    response = %{response | private: private}

    {request, response}
  end

  defp fetch_redirects({%{options: _} = request, response}),
    do: {request, response}

  defp print_request_headers(%{options: %{print_headers: true}} = request) do
    print_headers("> ", request.headers)

    request
  end

  defp print_request_headers(%{options: _} = request), do: request

  defp print_response_headers({%{options: %{print_headers: true}} = request, response}) do
    print_headers("< ", response.headers)
    {request, response}
  end

  defp print_response_headers({%{options: _} = request, response}), do: {request, response}

  defp print_headers(prefix, headers) do
    for {name, value} <- headers do
      IO.puts([prefix, name, ": ", value])
    end
  end
end

defmodule DerpyToolsWeb.MetadataAnalyzerLive do
  @moduledoc """
  URL with multiple redirects:
  http://derpytools.com/4-privacy-focused-alternatives-to-google-analytics-for-your-blog
  http://derpytools.com/hostsfile-mkcert-caddy-achieving-development-production-parity-has-never-been-easier

  Normal URLs:
  https://www.derpytools.com
  https://www.derpytools.com/croc-easily-send-files-across-computers-with-this-modern-alternative-to-magic-wormhole/
  https://derpycoder.github.io/dont-let-him-poo/

  JSON LD:
  https://www.similarweb.com/top-websites/food-and-drink/cooking-and-recipes/
  https://www.wix.com/blog/how-to-start-a-blog

  Fragment:
  https://cloudfour.com/thinks/svg-icon-stress-test/#:~:text=Image%20element%20with%20data%20URI,-Because%20SVGs%20are&text=This%20may%20be%20used%20to,or%20loading%20a%20separate%20file).&text=Across%20all%20browsers%20and%20regardless,and%20with%20the%20least%20deviation.

  TODO:
  content-security-policy: upgrade-insecure-requests; (HTTP - HTTPS)
  """
  use DerpyToolsWeb, :live_view

  alias DerpyToolsWeb.MetadataParams

  def mount(_params, _session, socket) do
    changeset = MetadataParams.change_metadata(%MetadataParams{})

    socket =
      socket
      |> assign(
        form: to_form(changeset),
        output: nil,
        loading: false
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="p-28 flex items-center justify-center">
      <div class="items-center justify-center w-[65svw] sm:w-[55svw] md:w-[45svw] lg:w-[35svw] xl:w-[25svw]">
        <nav class="flex card rounded-lg px-5 py-3" aria-label="Breadcrumb">
          <ol role="list" class="flex items-center space-x-4">
            <li>
              <div>
                <.link navigate={~p"/"} class="text-gray-400 hover:text-gray-500">
                  <svg
                    class="h-5 w-5 flex-shrink-0"
                    viewBox="0 0 20 20"
                    fill="currentColor"
                    aria-hidden="true"
                  >
                    <path
                      fill-rule="evenodd"
                      d="M9.293 2.293a1 1 0 011.414 0l7 7A1 1 0 0117 11h-1v6a1 1 0 01-1 1h-2a1 1 0 01-1-1v-3a1 1 0 00-1-1H9a1 1 0 00-1 1v3a1 1 0 01-1 1H5a1 1 0 01-1-1v-6H3a1 1 0 01-.707-1.707l7-7z"
                      clip-rule="evenodd"
                    />
                  </svg>
                  <span class="sr-only">Home</span>
                </.link>
              </div>
            </li>
            <li>
              <div class="flex items-center">
                <svg
                  class="h-5 w-5 flex-shrink-0 text-gray-400"
                  viewBox="0 0 20 20"
                  fill="currentColor"
                  aria-hidden="true"
                >
                  <path
                    fill-rule="evenodd"
                    d="M7.21 14.77a.75.75 0 01.02-1.06L11.168 10 7.23 6.29a.75.75 0 111.04-1.08l4.5 4.25a.75.75 0 010 1.08l-4.5 4.25a.75.75 0 01-1.06-.02z"
                    clip-rule="evenodd"
                  />
                </svg>
                <span class="ml-4 text-sm font-medium text-gray-500 hover:text-gray-700 cursor-default">
                  Metadata Analyzer
                </span>
              </div>
            </li>
          </ol>
        </nav>
        <.inspector :if={Mix.env() == :dev} file={__ENV__.file} line={__ENV__.line} />
        <.form
          for={@form}
          phx-change="validate"
          phx-submit="save"
          phx-window-keyup={JS.dispatch("phx:focus", to: "#url")}
          phx-key="/"
          class="card mt-5 rounded-lg p-5 lg:p-7"
        >
          <.input
            field={@form[:url]}
            phx-debounce="1000"
            id="url"
            autofocus
            label="URL:"
            placeholder="Enter your URL"
            readonly={@loading}
          >
            <:icon>
              <.icon class="hero-link" />
            </:icon>
          </.input>
          <.button class="mt-5 disabled:bg-primary/80" disabled={@loading} phx-disable-with="Loading...">
            <span :if={@loading}>
              Loading...
            </span>
            <span :if={!@loading} class="phx-submit-loading:hidden">
              Check Metadata
            </span>
          </.button>
        </.form>
        <div :if={@loading || @output} class="overflow-scroll h-96 card mt-5 rounded-lg">
          <.loading_indicator visible={@loading} class="h-96" />
          <pre :if={@output} class="p-5 lg:p-7">
    <%= inspect(@output, pretty: true) %>
          </pre>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("validate", %{"metadata_params" => params}, socket) do
    changeset =
      %MetadataParams{}
      |> MetadataParams.change_metadata(params)
      |> Map.put(:action, :validate)

    socket = socket |> assign(form: to_form(changeset))

    {:noreply, socket}
  end

  def handle_event("save", %{"metadata_params" => params}, socket) do
    case MetadataParams.update(params) do
      {:ok, %{id: _, url: url}} ->
        changeset = MetadataParams.change_metadata(%MetadataParams{}, params)

        send(self(), {:analyze_metadata, url})
        socket = assign(socket, output: nil, loading: true, form: to_form(changeset))
        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def handle_info({:analyze_metadata, url}, socket) do
    res =
      Req.new()
      |> FetchExtraMetadata.attach(fetch_redirects: true)
      |> Req.get!(url: url)

    {:ok, parsed_doc} = res.body |> Floki.parse_document()
    {"head", _, head} = parsed_doc |> Floki.find("head") |> Enum.at(0)

    socket =
      socket
      |> assign(
        output: %{
          metas: fetch_meta(head),
          redirects: res.private.redirects,
          misc: fetch_misc(head)
        },
        loading: false
      )
      |> put_flash(:info, "Done!")

    {:noreply, socket}
  end

  def fetch_meta(head) do
    head
    |> Enum.filter(&is_tuple/1)
    |> Enum.filter(fn each -> Tuple.to_list(each) |> Enum.count() == 3 end)
    |> Enum.filter(fn {name, _, _} -> String.downcase(name) == "meta" end)
    |> Enum.map(fn {"meta", meta, _} -> meta end)
    |> Enum.filter(fn each -> Enum.count(each) == 2 end)
    |> Enum.map(fn
      [{k1, v1} | [{"content", v2}]] ->
        case k1 do
          "name" -> {v1, v2}
          "property" -> {v1, v2}
          "rel" -> {v1, v2}
          _ -> nil
        end

      _ ->
        nil
    end)
    |> Enum.reject(&is_nil/1)
    |> Enum.into(%{}, fn row -> row end)
  end

  def fetch_misc(head) do
    head =
      head
      |> Enum.filter(&is_tuple/1)
      |> Enum.filter(fn each -> Tuple.to_list(each) |> Enum.count() == 3 end)
      |> Enum.filter(fn {name, _, _} -> String.downcase(name) != "meta" end)

    %{
      title: fetch_title(head),
      json_ld: fetch_json_ld(head)
    }
  end

  def fetch_title(head) do
    case Enum.find(head, fn
           {"title", _, _} -> true
           {_, _, _} -> false
         end) do
      {"title", _, [title]} -> title
      nil -> nil
    end
  end

  def fetch_json_ld(head) do
    # Maybe available in body:
    # https://psprices.com/region-in/game/5048716/kinduo-ps4-ps5
    # https://www.apple.com
    head
    |> Enum.filter(fn
      {"script", arr, _} ->
        Enum.into(arr, %{}, & &1) |> Map.get("type") == "application/ld+json"

      {_, _, _} ->
        false
    end)
    |> Enum.map(fn
      {"script", _, [json]} ->
        case Jason.decode(json) do
          {:ok, map} -> map
          {:error, _} -> nil
        end
    end)
  end
end
