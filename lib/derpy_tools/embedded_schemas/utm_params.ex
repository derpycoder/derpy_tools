defmodule DerpyTools.UtmParams do
  @moduledoc """
  UTM URL Builder, initially written by hand, later learnt about phx.gen.embedded
  `mix phx.gen.embedded UtmParams url:string utm_source:string utm_medium:string utm_campaign:string  utm_content:string utm_term:string`
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias DerpyTools.UtmParams

  embedded_schema do
    field :url, :string
    field :utm_source, :string
    field :utm_medium, :string
    field :utm_campaign, :string
    field :utm_content, :string
    field :utm_term, :string
  end

  @doc false
  def changeset(%UtmParams{} = utm_params, attrs) do
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
