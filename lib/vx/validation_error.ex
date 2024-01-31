defmodule Vx.ValidationError do
  @moduledoc """
  An error that is returned or raised when the validation against a type fails.
  It returns information about the failed validator, the value and (optionally)
  an inner error that caused the validation to fail.
  """

  defexception [:validator, :value, :inner]

  @opaque t :: %__MODULE__{
            validator: Vx.Validator.t(),
            value: any,
            inner: Exception.t() | nil
          }

  @doc false
  @spec new(Vx.Validator.t(), any, Exception.t() | nil) :: t
  def new(validator, value, inner \\ nil) do
    %__MODULE__{validator: validator, value: value, inner: inner}
  end

  @impl true
  def message(error) do
    msg =
      "Invalid " <>
        rule_message(error.validator, error.value)

    if error.inner do
      "#{msg}\n#{indent(Exception.message(error.inner))}"
    else
      msg
    end
  end

  defp rule_message(%{name: nil}, value), do: " (was #{inspect(value)})"

  defp rule_message(%{name: name, message: nil}, value) do
    ": #{name} validation failed (was #{inspect(value)})"
  end

  defp rule_message(%{message: message}, value) when is_function(message, 1) do
    ": #{message.(value)}"
  end

  defp rule_message(%{message: message}, value) when is_binary(message) do
    ": #{message} (was #{inspect(value)})"
  end

  defp indent(str) do
    str
    |> String.split("\n")
    |> Enum.map_join("\n", &"  #{&1}")
  end
end
