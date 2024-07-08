defmodule Vx.String.NonEmpty do
  defstruct []

  @type t :: %__MODULE__{}

  defimpl Vx.Validatable do
    def validate(schema, value) do
      if value == "" do
        [Vx.Error.new(schema, value, "must not be empty")]
      else
        []
      end
    end
  end
end
