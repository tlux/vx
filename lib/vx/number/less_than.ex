defmodule Vx.Number.LessThan do
  @enforce_keys [:value]
  defstruct [:value]

  @type t :: %__MODULE__{value: number}

  defimpl Vx.Validatable do
    def validate(schema, value) do
      if value < schema.value do
        []
      else
        [Vx.Error.new(schema, value, "must be less than #{schema.value}")]
      end
    end
  end
end
