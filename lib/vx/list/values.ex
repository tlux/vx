defmodule Vx.List.Values do
  @moduledoc false

  @enforce_keys [:schema]
  defstruct [:schema]

  defimpl Vx.Validatable do
    def validate(%{schema: schema}, list) do
      list
      |> Stream.with_index()
      |> Enum.flat_map(fn {value, index} ->
        schema
        |> Vx.errors_on(value)
        |> Enum.map(&Vx.Error.prepend_path(&1, index))
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
