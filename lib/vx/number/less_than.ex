defmodule Vx.Number.LessThan do
  @moduledoc """
  A constraint that verifies a number is less than another number.
  """

  @enforce_keys [:value]
  defstruct [:value]

  @type t :: %__MODULE__{value: number}

  defimpl Vx.Validatable do
    def validate(schema, value) do
      if value < schema.value do
        :ok
      else
        {:error, "must be less than #{schema.value}"}
      end
    end
  end

  defimpl Vx.Humanizable do
    def humanize(%{value: value}) do
      "< #{value}"
    end
  end
end
