defmodule Vx.Union do
  use Vx.Type

  @spec t(nonempty_list(Vx.Validatable.t())) :: t
  def t([types]), do: types

  def t([_ | _] = types) do
    init(&validate_value(&1, types), %{types: types})
  end

  defp validate_value(value, types) do
    Enum.reduce_while(types, :ok, fn type, _ ->
      case Vx.Validatable.validate(type, value) do
        :ok -> {:halt, :ok}
        {:error, error} -> {:cont, error}
      end
    end)
  end
end
