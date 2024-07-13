defmodule Vx.Map.Values do
  @moduledoc """
  A constraint that verifies the values of a map.
  """

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

  defimpl Vx.Humanizable do
    def humanize(%{schema: schema}) do
      Vx.Humanizable.humanize(schema) <> " values"
    end
  end
end
