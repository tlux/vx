defmodule Vx.Union do
  use Vx.Type

  @spec t([Vx.Validatable.t()]) :: t
  def t(types) when is_list(types) do
    init(&validate_value(&1, types))
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
