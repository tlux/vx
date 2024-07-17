defmodule Vx.Number.LessThan do
  @moduledoc false

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

  defimpl Vx.Printable do
    def print(%{value: value}) do
      "< #{value}"
    end
  end
end
