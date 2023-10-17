defmodule Vx.TypeError do
  defexception [:type, :validator, :value, :inner]

  @type t :: %__MODULE__{
          type: atom,
          validator: atom | nil,
          value: any,
          inner: Exception.t() | nil
        }

  @spec new(atom, atom, any, Exception.t() | nil) :: t
  def new(type, validator \\ nil, value, inner \\ nil) do
    %__MODULE__{type: type, validator: validator, value: value, inner: inner}
  end

  def message(error) do
    msg = "Type error (#{error.type}): #{inspect(error.value)}"

    msg_with_validator =
      case error.validator do
        nil -> msg
        _ -> "#{msg} (validator: #{error.validator})"
      end

    case error.inner do
      nil -> msg_with_validator
      inner -> "#{msg_with_validator}\n#{indent(Exception.message(inner))}"
    end
  end

  defp indent(str) do
    str
    |> String.split("\n")
    |> Enum.map(&"  #{&1}")
    |> Enum.join("\n")
  end

  @doc false
  def wrap(%__MODULE__{} = error, inner), do: %__MODULE__{error | inner: inner}
end
