defmodule Vx.Number.NonFractional do
  defstruct []

  @type t :: %__MODULE__{}

  defimpl Vx.Validatable do
    def validate(schema, value) do
      if trunc(value) == value do
        []
      else
        [Vx.Error.new(schema, value, "must not be a fractional number")]
      end
    end
  end
end
