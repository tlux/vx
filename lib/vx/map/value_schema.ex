defmodule Vx.Map.ValueSchema do
  @enforce_keys [:schema]
  defstruct [:schema]

  defimpl Vx.Validatable do
    def validate(%{schema: schema}, map) do
      Enum.flat_map(map, fn {key, value} ->
        schema
        |> Vx.Validatable.validate(value)
        |> Enum.map(fn error ->
          Vx.Error.prepend_path(error, key)
        end)
      end)
    end
  end
end
