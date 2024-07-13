defmodule Vx.List.Values do
  @moduledoc """
  A constraint that verifies the values of a list.
  """

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

  defimpl Vx.Humanizable do
    def humanize(%{schema: schema}) do
      Vx.Humanizable.humanize(schema) <> " values"
    end
  end
end
