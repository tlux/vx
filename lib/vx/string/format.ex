defmodule Vx.String.Format do
  @moduledoc false

  @enforce_keys [:regex]
  defstruct [:regex]

  @type t :: %__MODULE__{regex: Regex.t()}

  defimpl Vx.Validatable do
    def validate(schema, value) do
      if Regex.match?(schema.regex, value) do
        :ok
      else
        {:error, "does not match the expected format"}
      end
    end
  end
end
