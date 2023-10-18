defmodule Vx.TypeError do
  defexception [:schema_type, :validator_type, :value, :inner]

  @type t :: %__MODULE__{
          schema_type: Vx.Schema.schema_type(),
          validator_type: Vx.Validator.validator_type() | nil,
          value: any,
          inner: Exception.t() | nil
        }

  @spec new(
          Vx.Schema.schema_type(),
          Vx.Validator.validator_type(),
          any,
          Exception.t() | nil
        ) :: t
  def new(schema_type, validator_type \\ nil, value, inner \\ nil) do
    %__MODULE__{
      schema_type: schema_type,
      validator_type: validator_type,
      value: value,
      inner: inner
    }
  end

  def message(error) do
    msg = "Type error (#{inspect(error.schema_type)}): #{inspect(error.value)}"

    msg_with_validator =
      case error.validator_type do
        nil -> msg
        _ -> "#{msg} (validator: #{error.validator_type})"
      end

    case error.inner do
      nil -> msg_with_validator
      inner -> "#{msg_with_validator}\n#{indent(Exception.message(inner))}"
    end
  end

  defp indent(str) do
    str
    |> String.split("\n")
    |> Enum.map_join("\n", &"  #{&1}")
  end

  @spec wrap(t, any) :: t
  @doc false
  def wrap(%__MODULE__{} = error, inner), do: %__MODULE__{error | inner: inner}
end
