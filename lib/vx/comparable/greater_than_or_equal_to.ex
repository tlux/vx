defmodule Vx.Comparable.GreaterThanOrEqualTo do
  @moduledoc false

  @enforce_keys [:comparable, :value]
  defstruct [:comparable, :value]

  @type t :: %__MODULE__{comparable: module, value: any}

  defimpl Vx.Validatable do
    def validate(%{comparable: comparable, value: value}, actual_value) do
      if comparable.compare(actual_value, value) in [:gt, :eq] do
        :ok
      else
        {:error, "must be greater than or equal to #{inspect(value)}"}
      end
    end
  end

  defimpl Vx.Humanizable do
    def humanize(%{value: value}) do
      ">= #{value}"
    end
  end
end
