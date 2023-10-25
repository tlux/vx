defmodule Vx.ValidationError do
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
      "Invalid #{inspect(error.validator.type)}" <>
        rule_message(error.validator) <>
        " (was #{inspect(error.value)})"

    if error.inner do
      "#{msg}\n#{indent(Exception.message(error.inner))}"
    else
      msg
    end
  end

  defp rule_message(%{name: nil}), do: ""

  defp rule_message(%{name: name, message: nil}) do
    ": #{name} validation failed"
  end

  defp rule_message(%{message: message}) do
    ": #{message}"
  end

  defp indent(str) do
    str
    |> String.split("\n")
    |> Enum.map_join("\n", &"  #{&1}")
  end
end
