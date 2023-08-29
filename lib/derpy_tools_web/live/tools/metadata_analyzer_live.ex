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

  Misc Links:
  https://github.com/schollz/croc
  """
  use DerpyToolsWeb, :live_view

  alias DerpyTools.MetadataSchema
  alias DerpyTools.FetchExtraMetadata

  def mount(_params, _session, socket) do
    changeset = MetadataSchema.change_metadata(%MetadataSchema{})

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
    <div class="mt-10 flex items-center justify-center p-10">
      <div
        id="metadata-analyzer"
        data-file={__ENV__.file}
        data-line={__ENV__.line}
        phx-hook={Application.fetch_env!(:derpy_tools, :show_inspector?) && "SourceInspector"}
        class="w-[65svw] relative items-center justify-center sm:w-[55svw] md:w-[45svw] lg:w-[65svw] xl:w-[55svw]"
      >
        <nav class="card flex rounded-lg px-5 py-3" aria-label="Breadcrumb">
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
                  class="h-5 w-5 flex-shrink-0 text-gray-400 dark:text-slate-100"
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
                <span class="ml-4 cursor-default text-sm font-medium text-gray-500 hover:text-gray-700 dark:text-slate-100">
                  Metadata Analyzer
                </span>
              </div>
            </li>
          </ol>
        </nav>
        <.form
          for={@form}
          phx-change="validate"
          phx-submit="save"
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
            phx-hook="PrimaryInput"
          >
            <:icon>
              <.icon class="hero-link" />
            </:icon>
            <:hint>
              The full URL of the page to which the traffic is sent, including the protocol (https).
            </:hint>
            <:shortcut>
              <kbd class="pt-2 text-lg font-bold">/</kbd>
            </:shortcut>
          </.input>
          <.button
            class="mt-5 disabled:bg-primary/80"
            disabled={@loading}
            phx-disable-with="Loading..."
          >
            <span :if={@loading}>
              Loading...
            </span>
            <span :if={!@loading} class="phx-submit-loading:hidden">
              <.icon class="hero-arrow-path w-5.5 h-5.5 mr-2" /> Check Metadata
            </span>
          </.button>
        </.form>
        <div :if={@loading || @output} class="card mt-5 h-96 overflow-scroll rounded-lg">
          <.loading_indicator visible={@loading} class="h-96" />
          <pre :if={@output} class="p-5 lg:p-7">
    <%= inspect(@output, pretty: true) %>
          </pre>
        </div>
        <h2 :if={@output} class="card mt-5 rounded-lg px-5 py-3">
          Redirects (<%= @output.redirects.count %>)
        </h2>
        <div :if={@output} class="card mt-5 overflow-scroll rounded-lg px-5 py-3">
          <div>
            Fetched URL: <%= @form.params["url"] %>
          </div>
          <div>Canonical URL: <%= @output.redirects.url %></div>
          <div :for={{code, url} <- @output.redirects.trail |> Enum.reverse()}>
            <span><%= code %></span>
            <span><%= url %></span>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("validate", %{"metadata_schema" => metadata}, socket) do
    changeset =
      %MetadataSchema{}
      |> MetadataSchema.change_metadata(metadata)
      |> Map.put(:action, :validate)

    socket = socket |> assign(form: to_form(changeset))

    {:noreply, socket}
  end

  def handle_event("save", %{"metadata_schema" => metadata}, socket) do
    case MetadataSchema.update(metadata) do
      {:ok, %{id: _, url: url}} ->
        changeset = MetadataSchema.change_metadata(%MetadataSchema{}, metadata)

        send(self(), {:analyze_metadata, url})
        socket = assign(socket, output: nil, loading: true, form: to_form(changeset))
        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset), output: nil)}
    end
  end

  def handle_info({:analyze_metadata, url}, socket) do
    # Req.new(range: "bytes=100-200")
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
    |> Enum.filter(&match?({name, _, _} when name == "meta", &1))
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
      |> Enum.filter(&match?({name, _, _} when name != "meta", &1))

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
