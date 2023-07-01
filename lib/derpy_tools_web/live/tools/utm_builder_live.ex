defmodule DerpyTools.UtmParams do
  alias DerpyTools.UtmParams
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field(:url, :string)
    field(:utm_source, :string)
    field(:utm_medium, :string)
    field(:utm_campaign, :string)
    field(:utm_content, :string)
    field(:utm_term, :string)
  end

  def changeset(utm_params, attrs) do
    utm_params
    |> cast(attrs, [:url, :utm_source, :utm_medium, :utm_campaign, :utm_content, :utm_term])
    |> validate_required([:url])
    |> validate_url(:url, message: "URL must be valid")
    |> validate_length(:utm_source, min: 2, max: 10, message: "at least 2")
    |> validate_length(:utm_campaign, min: 2, max: 10)
    |> validate_length(:utm_medium, min: 2, max: 10)
    |> validate_length(:utm_content, min: 2, max: 10)
    |> validate_length(:utm_term, min: 2, max: 10)
  end

  def update(attrs) do
    %UtmParams{}
    |> UtmParams.changeset(attrs)
    |> apply_action(:update)
  end

  def change_utm_params(%UtmParams{} = utm_params, attrs \\ %{}) do
    UtmParams.changeset(utm_params, attrs)
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

defmodule DerpyToolsWeb.UtmBuilderLive do
  use DerpyToolsWeb, :live_view

  alias DerpyTools.UtmParams

  def mount(_params, _session, socket) do
    changeset = UtmParams.change_utm_params(%UtmParams{})

    socket = assign(socket, form: to_form(changeset), output: nil)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="p-10 flex items-center justify-center">
      <div class="relative w-[65svw] sm:w-[55svw] md:w-[45svw] lg:w-[35svw] xl:w-[25svw]">
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
                <span class="ml-4 text-sm font-medium text-gray-500 hover:text-gray-700 cursor-default dark:text-slate-100">
                  UTM Builder
                </span>
              </div>
            </li>
          </ol>
        </nav>

        <.inspector :if={Mix.env() == :dev} file={__ENV__.file} line={__ENV__.line} />
        <.form
          for={@form}
          phx-change="validate"
          phx-submit="generate-utm"
          class="card mt-5 rounded-lg p-5 lg:p-7"
        >
          <.input
            id="url"
            field={@form[:url]}
            phx-debounce="1000"
            autofocus
            label="URL:"
            class="relative"
            phx-hook="PrimaryInput"
          >
            <:icon>
              <.icon class="hero-link" />
            </:icon>
            <:hint>
              The full URL of the page to which the traffic is sent, including the protocol (https).
            </:hint>
            <:shortcut>
              <kbd class="text-[16px] font-bold">/</kbd>
            </:shortcut>
          </.input>
          <.input field={@form[:utm_source]} phx-debounce="blur" label="Source:" class="mt-4">
            <:hint>The source for the campaign, such as social media, Twitter.</:hint>
          </.input>
          <.input field={@form[:utm_medium]} phx-debounce="blur" label="Medium:" class="mt-4">
            <:hint>The medium of the campaign, such as email, mobile.</:hint>
          </.input>
          <.input field={@form[:utm_campaign]} phx-debounce="blur" label="Campaign:" class="mt-4">
            <:hint>The name of the campaign, such as Summer Sale, Promo Code.</:hint>
          </.input>
          <.input field={@form[:utm_content]} phx-debounce="blur" label="Content:" class="mt-4">
            <:hint>Used for more accurate tracking or A/B testing, such as header, footer.</:hint>
          </.input>
          <.input field={@form[:utm_term]} phx-debounce="blur" label="Term" class="mt-4">
            <:hint>Used for (paid) search terms, such as shoe store, privacy analytics.</:hint>
          </.input>
          <.button class="btn" phx-disable-with="Concatenating...">
            <.icon class="hero-arrow-path w-5.5 h-5.5 mr-2" /> Generate
          </.button>
        </.form>

        <div
          :if={@output}
          class="card mt-5 rounded-lg p-5 lg:p-7"
          phx-hook="ScrollIntoView"
          id="output"
        >
          <input
            id="utm-url"
            type="text"
            value={@output}
            class="w-full form-input transition-colors duration-300 peer rounded-lg border bg-transparent px-9 py-2 text-ellipsis placeholder:text-slate-400/70 hover:z-10 autofill:!text-black autofill:!bg-yellow-300 border-slate-300 hover:ring-slate-400 focus:z-10 focus:ring-primary dark:ring-navy-450 dark:hover:ring-navy-400 dark:focus:ring-accent"
            readonly
            autofocus
          />
          <span class="pointer-events-none absolute top-[38px] r-0 flex w-10 items-center justify-center peer-focus:text-primary dark:text-navy-300 dark:peer-focus:text-accent text-slate-400">
            <.icon class="hero-link" />
          </span>
          <button class="copy-btn" id="copy-utm-url" phx-hook="Clipboard" data-target="utm-url">
            <span class="tooltip">Copied!</span>
            <svg
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="1.5"
              viewBox="0 0 32 32"
              width="32"
              height="32"
              class="stroke-primary"
            >
              <path d="M12.998 10.75h-1.25a2 2 0 0 0-2 2v8.5a2 2 0 0 0 2 2h8.5a2 2 0 0 0 2-2v-8.5a2 2 0 0 0-2-2h-1.25" />
              <path d="M17.997 12.25h-4a1 1 0 0 1-1-1v-1.5a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v1.5a1 1 0 0 1-1 1Zm-4.249 4h4.5m-4.5 3h4.5" />
              <path d="M15.998 6V4M19.997 6l1-1M11.998 6l-1-1" class="highlight" />
            </svg>
          </button>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("validate", %{"utm_params" => params}, socket) do
    changeset =
      %UtmParams{}
      |> UtmParams.change_utm_params(params)
      |> Map.put(:action, :validate)

    socket = assign(socket, form: to_form(changeset))
    {:noreply, socket}
  end

  def handle_event("generate-utm", %{"utm_params" => params}, socket) do
    case UtmParams.update(params) do
      {:ok, result} ->
        changeset = UtmParams.change_utm_params(%UtmParams{}, params)

        query =
          params
          |> Map.delete("url")
          |> Enum.filter(fn {_, v} -> v != "" end)
          |> Enum.into(%{}, fn {k, v} -> {k, v} end)

        result =
          result.url
          |> URI.parse()
          |> Map.get_and_update(
            :query,
            fn
              q when is_nil(q) ->
                {nil, query |> URI.encode_query()}

              q ->
                {q,
                 q
                 |> URI.decode_query()
                 |> Map.merge(query, fn _k, _v1, v2 -> v2 end)
                 |> URI.encode_query()}
            end
          )
          |> then(fn {_, result} -> URI.to_string(result) end)

        socket =
          socket
          |> assign(form: to_form(changeset), output: result)
          |> put_flash(:info, "Done, scroll down to see the final URL!")

        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def handle_event("copied_notification", _, socket) do
    {:noreply, socket |> put_flash(:info, "Copied!")}
  end
end
