defmodule Vx.Union do
  use Vx.Type

  @spec t(nonempty_list(Vx.t())) :: t
  def t([inputs]), do: inputs

  def t([_ | _] = inputs) do
    init(&validate_value(&1, inputs), %{inputs: inputs})
  end

  defp validate_value(value, inputs) do
    Enum.reduce_while(inputs, :ok, fn type, _ ->
      case Vx.Validatable.validate(type, value) do
        :ok -> {:halt, :ok}
        {:error, error} -> {:cont, error}
      end
    end)
  end
end
