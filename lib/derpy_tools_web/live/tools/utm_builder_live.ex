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
    <div class="p-28 flex items-center justify-center">
      <div class="relative w-[25svw]">
        <.inspector :if={Mix.env() == :dev} file={__ENV__.file} line={__ENV__.line} />
        <.form
          for={@form}
          phx-change="validate"
          phx-submit="generate-utm"
          phx-window-keyup={JS.dispatch("phx:focus", to: "#url")}
          phx-key="/"
          class="card mt-5 rounded-lg p-5 lg:p-7"
        >
          <.input id="url" field={@form[:url]} phx-debounce="1000" autofocus label="URL:" />
          <.input field={@form[:utm_source]} phx-debounce="blur" label="Source:" class="mt-4" />
          <.input field={@form[:utm_medium]} phx-debounce="blur" label="Medium:" class="mt-4" />
          <.input field={@form[:utm_campaign]} phx-debounce="blur" label="Campaign:" class="mt-4" />
          <.input field={@form[:utm_content]} phx-debounce="blur" label="Content:" class="mt-4" />
          <.input field={@form[:utm_term]} phx-debounce="blur" label="Term" class="mt-4" />
          <.button class="btn" phx-disable-with="Concatenating..." type="submit">
            <.icon class="hero-arrow-path w-5.5 h-5.5 mr-2" phx-update="ignore" /> Generate
          </.button>
        </.form>

        <div :if={@output} id="utm-url" class="card mt-5 rounded-lg p-5 lg:p-7">
          <%= @output %>
          <.button
            class="btn"
            phx-click={JS.dispatch("phx:copy", to: "#utm-url") |> JS.push("copied_notification")}
          >
            <.icon class="hero-clipboard w-5.5 h-5.5 mr-2" /> Copy to Clipboard
          </.button>
        </div>

        <%!-- <a id="utm-clipboard" data-content={@output} phx-hook="Clipboard">
          Copy Link
        </a> --%>
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
          |> URI.encode_query()

        result =
          result.url
          |> URI.parse()
          |> URI.append_query(query)
          |> URI.to_string()

        socket =
          socket
          |> assign(form: to_form(changeset), output: result)

        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def handle_event("copied_notification", _, socket) do
    {:noreply, socket |> put_flash(:info, "Copied!")}
  end
end