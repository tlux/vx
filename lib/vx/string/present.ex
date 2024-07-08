defmodule Vx.String.Present do
  defstruct []

  @type t :: %__MODULE__{}

  defimpl Vx.Validatable do
    def validate(schema, value) do
      if String.trim(value) == "" do
        [Vx.Error.new(schema, value, "must be present")]
      else
        []
      end
    end
  end
end
