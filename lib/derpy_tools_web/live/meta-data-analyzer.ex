defmodule DerpyToolsWeb.MetaDataAnalyzer do
  alias DerpyToolsWeb.MetaDataAnalyzer
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :url, :string
  end

  def changeset(utm_params, attrs) do
    utm_params
    |> cast(attrs, [:url])
    |> validate_required([:url])
    |> validate_url(:url, message: "URL must be valid")
  end

  def update(attrs) do
    %MetaDataAnalyzer{}
    |> MetaDataAnalyzer.changeset(attrs)
    |> apply_action(:update)
  end

  def change_meta_data(%MetaDataAnalyzer{} = utm_params, attrs \\ %{}) do
    MetaDataAnalyzer.changeset(utm_params, attrs)
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

defmodule FetchLocations do
  @doc """
  Prints request and response headers.

  ## Request Options

    * `:get_location_header` - if `true`, gets the location header. Defaults to `false`.
  """
  def attach(%Req.Request{} = request, options \\ []) do
    request
    |> Req.Request.register_options([:get_location_header])
    |> Req.Request.merge_options(options)
    |> Req.Request.prepend_response_steps(get_location_header: &get_location_header/1)
  end

  defp get_location_header({request, response}) do
    response =
      if request.options[:get_location_header] do
        Map.put_new(response, :location, request.url)
      else
        response
      end

    {request, response}
  end
end

defmodule DerpyToolsWeb.MetaDataAnalyzerLive do
  @moduledoc """
  URL with multiple redirects: http://www.superuser.com/q/1471861/
  """
  use DerpyToolsWeb, :live_view

  alias DerpyToolsWeb.MetaDataAnalyzer

  def mount(_params, _session, socket) do
    changeset = MetaDataAnalyzer.change_meta_data(%MetaDataAnalyzer{})

    socket =
      socket
      |> assign(
        form: to_form(changeset),
        meta_data: nil
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <.form for={@form} phx-change="validate" phx-submit="save">
        <label for="url">URL</label>
        <.input field={@form[:url]} phx-debounce="1000" />
        <.button class="mt-5" phx-disable-with="Loading...">
          Fetch MetaData
        </.button>
      </.form>
      <pre>
    <%= inspect(@meta_data, pretty: true) %>
    </pre>
    </div>
    """
  end

  def handle_event("validate", %{"meta_data_analyzer" => params}, socket) do
    changeset =
      %MetaDataAnalyzer{}
      |> MetaDataAnalyzer.change_meta_data(params)
      |> Map.put(:action, :validate)

    socket = socket |> assign(form: to_form(changeset))

    {:noreply, socket}
  end

  def handle_event("save", %{"meta_data_analyzer" => params}, socket) do
    case MetaDataAnalyzer.update(params) do
      {:ok, %{id: _, url: url}} ->
        changeset = MetaDataAnalyzer.change_meta_data(%MetaDataAnalyzer{}, params)

        socket =
          socket
          |> assign(form: to_form(changeset), meta_data: fetch_meta_data(url))
          |> put_flash(:info, "Yay!")

        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def fetch_meta_data(url) do
    req = Req.new() |> FetchLocations.attach()
    res = Req.get!(req, url: url, get_location_header: true)
    location = Map.get(res, :location)

    {:ok, parsed_doc} = res.body |> Floki.parse_document()
    {"head", _, head} = parsed_doc |> Floki.find("head") |> Enum.at(0)

    head
    |> Enum.filter(&is_tuple/1)
    |> Enum.filter(fn each -> Tuple.to_list(each) |> Enum.count() == 3 end)
    |> Enum.filter(fn {name, _, _} -> String.downcase(name) == "meta" end)
    |> Enum.map(fn {"meta", meta, _} -> meta end)
    |> Enum.filter(fn each -> each |> Enum.count() == 2 end)
    |> Enum.map(fn [{k1, v1} | [{"content", v2}]] ->
      case k1 do
        "name" -> {v1, v2}
        "property" -> {v1, v2}
        "rel" -> {v1, v2}
        _ -> nil
      end
    end)
    |> Enum.into(%{}, fn row -> row end)
    |> Map.put_new("uri", location)
    |> Map.put_new("url", location |> URI.to_string())
  end
end
