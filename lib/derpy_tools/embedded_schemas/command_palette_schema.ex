defmodule DerpyTools.CommandPaletteSchema do
  use Ecto.Schema
  import Ecto.Changeset
  alias DerpyTools.CommandPaletteSchema

  embedded_schema do
    field :query, :string
  end

  @doc false
  def changeset(%CommandPaletteSchema{} = command_palette_schema, attrs) do
    command_palette_schema
    |> cast(attrs, [:query])
    |> validate_required([:query])
  end

  def change_command_palette_schema(
        %CommandPaletteSchema{} = command_palette_schema,
        attrs \\ %{}
      ) do
    changeset(command_palette_schema, attrs)
  end
end
