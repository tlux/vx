defmodule Vx.Comparable.LessThan do
  @moduledoc false

  @enforce_keys [:comparable, :value]
  defstruct [:comparable, :value]

  @type t :: %__MODULE__{comparable: module, value: any}

  defimpl Vx.Validatable do
    def validate(%{comparable: comparable, value: value}, actual_value) do
      if comparable.compare(actual_value, value) == :lt do
        :ok
      else
        {:error, "must be less than #{inspect(value)}"}
      end
    end
  end

  defimpl Vx.Printable do
    def print(%{value: value}) do
      "< #{value}"
    end
  end
end
