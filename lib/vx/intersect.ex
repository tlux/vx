defmodule Vx.Intersect do
  @moduledoc """
  The Intersect type is a special type that allows you to combine multiple types
  into a single one. It checks whether all of the combined types match the
  validated value.
  """

  use Vx.Type

  @doc """
  Creates a type that allows you to combine multiple types into one.
  """
  @spec t(nonempty_list(Vx.t())) :: t
  def t([input]), do: input

  def t([_ | _] = inputs) do
    init(&validate_value(&1, inputs), %{inputs: inputs})
  end

  defp validate_value(value, inputs) do
    Enum.reduce_while(inputs, :ok, fn input, _ ->
      case Vx.Validatable.validate(input, value) do
        :ok -> {:cont, :ok}
        {:error, error} -> {:halt, error}
      end
    end)
  end
end
