defmodule Vx.List.ValueSchema do
  @enforce_keys [:schema]
  defstruct [:schema]

  defimpl Vx.Validatable do
    def validate(%{schema: schema}, list) do
      list
      |> Stream.with_index()
      |> Enum.flat_map(fn {value, index} ->
        schema
        |> Vx.Validatable.validate(value)
        |> Enum.map(fn error ->
          Vx.Error.prepend_path(error, index)
        end)
      end)
    end
  end
end
