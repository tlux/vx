defmodule Vx.String.Format do
  defstruct [:regex]

  @type t :: %__MODULE__{
          regex: Regex.t()
        }

  defimpl Vx.Validatable do
    def validate(schema, value) do
      if Regex.match?(schema.regex, value) do
        []
      else
        [Vx.Error.new(schema, value, "does not match the expected format")]
      end
    end
  end
end
