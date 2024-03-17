defmodule Vx.Union do
  @moduledoc """
  The Union type is a special type that allows you to combine multiple types
  into a single one. It checks whether any of the combined types matches the
  validated value.
  """

  use Vx.Type

  @spec t(nonempty_list(Vx.t())) :: t
  def t([_ | _] = types) do
    new(&validate_value(&1, types), %{types: types}, "no type matched")
  end

  defp validate_value(value, types) do
    Enum.reduce_while(types, :ok, fn type, _ ->
      case Vx.Validatable.validate(type, value) do
        :ok -> {:halt, :ok}
        error -> {:cont, error}
      end
    end)
  end
end
