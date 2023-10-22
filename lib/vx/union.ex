defmodule Vx.Union do
  use Vx.Type

  @spec t(nonempty_list(Vx.Validatable.t())) :: t
  def t([inner]), do: inner

  def t([_ | _] = inner) do
    init(&validate_value(&1, inner), %{inner: inner})
  end

  defp validate_value(value, inner) do
    Enum.reduce_while(inner, :ok, fn type_or_value, _ ->
      case Vx.Validatable.validate(type_or_value, value) do
        :ok -> {:halt, :ok}
        {:error, error} -> {:cont, error}
      end
    end)
  end
end
