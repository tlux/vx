defmodule Vx.Union do
  @moduledoc """
  The Union type is a special type that allows you to combine multiple types
  into a single one. It checks whether any of the combined types matches the
  validated value.
  """

  use Vx.Type

  @spec t(nonempty_list(Vx.t())) :: t
  def t([inputs]), do: inputs

  def t([_ | _] = inputs) do
    init(&validate_value(&1, inputs), %{inputs: inputs})
  end

  defp validate_value(value, inputs) do
    Enum.reduce_while(inputs, :ok, fn input, _ ->
      case Vx.Validatable.validate(input, value) do
        :ok -> {:halt, :ok}
        {:error, error} -> {:cont, error}
      end
    end)
  end
end
