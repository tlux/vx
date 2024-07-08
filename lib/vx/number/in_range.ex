defmodule Vx.Number.InRange do
  @enforce_keys [:range]
  defstruct [:range]

  @type t :: %__MODULE__{range: Range.t()}

  defimpl Vx.Validatable do
    def validate(%{range: range} = schema, value) do
      if value in range do
        []
      else
        [Vx.Error.new(schema, value, "must be in range #{inspect(range)}")]
      end
    end
  end
end
