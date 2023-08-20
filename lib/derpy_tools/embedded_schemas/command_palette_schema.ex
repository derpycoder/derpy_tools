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
    |> validate_format(:query, ~r"^[A-Za-z0-9 #>@$/? ,:!]+$",
      message: "special characters except the ones listed below are not allowed"
    )
    |> validate_word_length(:query, message: "keep your query within 10 words")
    |> validate_length(:query, max: 100, message: "keep your query short")
  end

  def change_command_palette(%CommandPaletteSchema{} = command_palette_schema, attrs \\ %{}) do
    CommandPaletteSchema.changeset(command_palette_schema, attrs)
  end

  def update(attrs) do
    %CommandPaletteSchema{}
    |> CommandPaletteSchema.changeset(attrs)
    |> apply_action(:update)
  end

  defp validate_word_length(changeset, field, opts) when is_atom(field) do
    validate_change(changeset, field, fn _, query ->
      word_count =
        query
        |> String.replace(~r"[^A-Za-z0-9 ]", "")
        |> String.split()
        |> length()

      if word_count <= 10 do
        []
      else
        [
          {field,
           {
             Keyword.get(opts, :message, "keep your query within 10 words"),
             [validation: :query]
           }}
        ]
      end
    end)
  end
end
