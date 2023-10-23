defmodule Vx.Intersect do
  use Vx.Type

  @spec t(nonempty_list(Vx.t())) :: t
  def t([inputs]), do: inputs

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
