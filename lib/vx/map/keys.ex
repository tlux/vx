defmodule Vx.Map.Keys do
  @moduledoc false

  @enforce_keys [:schema]
  defstruct [:schema]

  @type t :: %__MODULE__{schema: Vx.t()}

  defimpl Vx.Validatable do
    def validate(%{schema: schema}, map) do
      map
      |> Enum.flat_map(fn {key, _} ->
        schema
        |> Vx.errors_on(key)
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
      Vx.Humanizable.humanize(schema) <> " keys"
    end
  end
end
