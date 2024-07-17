defmodule Vx.Map.Values do
  @moduledoc false

  @enforce_keys [:schema]
  defstruct [:schema]

  defimpl Vx.Validatable do
    def validate(%{schema: schema}, map) do
      map
      |> Enum.flat_map(fn {key, value} ->
        schema
        |> Vx.errors_on(value)
        |> Enum.map(&Vx.Error.prepend_path(&1, key))
      end)
      |> then(fn
        [] -> :ok
        errors -> {:error, errors}
      end)
    end
  end

  defimpl Vx.Printable do
    def print(%{schema: schema}) do
      Vx.Printable.print(schema) <> " values"
    end
  end
end
