defmodule DerpyTools.MetadataSchema do
  @moduledoc """
  Using a changeset to validate user entered data.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias DerpyTools.MetadataSchema

  embedded_schema do
    field :url, :string
  end

  @doc false
  def changeset(%MetadataSchema{} = metadata, attrs) do
    metadata
    |> cast(attrs, [:url])
    |> validate_required([:url])
    |> validate_url(:url, message: "URL must be valid")
  end

  def update(attrs) do
    %MetadataSchema{}
    |> MetadataSchema.changeset(attrs)
    |> apply_action(:update)
  end

  def change_metadata(%MetadataSchema{} = metadata, attrs \\ %{}) do
    MetadataSchema.changeset(metadata, attrs)
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
