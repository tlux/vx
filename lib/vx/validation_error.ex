defmodule Vx.ValidationError do
  defexception [:validator, :value, :inner]

  @type t :: %__MODULE__{
          validator: Vx.Validator.t(),
          value: any,
          inner: Exception.t() | nil
        }

  @spec new(
          Vx.Validator.t(),
          any,
          Exception.t() | nil
        ) :: t
  def new(validator, value, inner \\ nil) do
    %__MODULE__{validator: validator, value: value, inner: inner}
  end

  @impl true
  def message(error) do
    msg =
      "Type error (#{inspect(error.validator.schema_name)}/" <>
        "#{inspect(error.validator.name)}): #{inspect(error.value)}"

    if error.inner do
      "#{msg}\n#{indent(Exception.message(error.inner))}"
    else
      msg
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
