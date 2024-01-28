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
  def t([_ | _] = types) do
    new(&validate_value(&1, types), %{types: types})
  end

  defp validate_value(value, types) do
    Enum.reduce_while(types, :ok, fn type, _ ->
      case Vx.Validatable.validate(type, value) do
        :ok -> {:cont, :ok}
        {:error, error} -> {:halt, error}
      end
    end)
  end
end
