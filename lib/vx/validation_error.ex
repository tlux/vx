defmodule Vx.ValidationError do
  @moduledoc """
  An error that is returned or raised when the validation against a type fails.
  It returns information about the failed validator, the value and (optionally)
  an inner error that caused the validation to fail.
  """

  alias Vx.Validator

  defexception [:validator, :value, :inner]

  @opaque t :: %__MODULE__{
            validator: Validator.t(),
            value: any,
            inner: Exception.t() | nil
          }

  @doc false
  @spec new(Validator.t(), any, Exception.t() | nil) :: t
  def new(validator, value, inner \\ nil) do
    %__MODULE__{validator: validator, value: value, inner: inner}
  end

  @impl true
  def message(error) do
    msg = message(error.validator, error.value)

    if error.inner do
      "#{msg}\n#{indent(Exception.message(error.inner))}"
    else
      msg
    end
  end

  defp message(%Validator{module: module, name: nil, message: nil}, _value) do
    "invalid #{inspect(module)}"
  end

  defp message(%Validator{module: module, name: name, message: nil}, _value) do
    "invalid #{inspect(module)}: rule #{inspect(name)} failed"
  end

  defp message(%Validator{message: message}, value) do
    expand_message(message, value)
  end

  defp expand_message(message, value) when is_function(message, 1) do
    message.(value)
  end

  defp expand_message(message, _value) when is_binary(message) do
    message
  end

  defp indent(str) do
    str
    |> String.split("\n")
    |> Enum.map_join("\n", &"  #{&1}")
  end
end
