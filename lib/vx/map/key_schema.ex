defmodule Vx.Map.KeySchema do
  @enforce_keys [:schema]
  defstruct [:schema]

  defimpl Vx.Validatable do
    def validate(%{schema: schema}, map) do
      Enum.flat_map(map, fn {key, _} ->
        schema
        |> Vx.Validatable.validate(key)
        |> Enum.map(fn error ->
          Vx.Error.prepend_path(error, key)
        end)
      end)
    end
  end
end
