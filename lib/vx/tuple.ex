defmodule Vx.Tuple do
  use Vx.Type

  @spec t() :: t
  def t, do: init(&is_tuple/1)

  @spec shape(t, tuple) :: t
  def shape(%__MODULE__{} = type \\ t(), structure)
      when is_tuple(structure) do
    expected_size = tuple_size(structure)

    validate(
      type,
      :shape,
      &check_tuple_shape(&1, structure, expected_size),
      %{structure: structure}
    )
  end

  defp check_tuple_shape(tuple, structure, expected_size)
       when tuple_size(tuple) == expected_size do
    Enum.reduce_while(0..(expected_size - 1), :ok, fn index, _ ->
      schema_or_value = elem(structure, index)
      value = elem(tuple, index)

      case Vx.Validatable.validate(schema_or_value, value) do
        :ok -> {:cont, :ok}
        error -> {:halt, error}
      end
    end)
  end

  defp check_tuple_shape(_, _, _), do: :error

  @spec size(t, non_neg_integer) :: t
  def size(%__MODULE__{} = type \\ t(), count)
      when is_integer(count) and count >= 0 do
    validate(
      type,
      :size,
      fn tuple -> tuple_size(tuple) == count end,
      %{count: count}
    )
  end
end
