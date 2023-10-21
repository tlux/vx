defmodule Vx.Tuple do
  alias Vx.Schema

  @type t :: Schema.t(:tuple)

  @spec t() :: t
  def t, do: Schema.new(:tuple, &is_tuple/1)

  @spec shape(t, tuple) :: t
  def shape(%Schema{name: :tuple} = schema \\ t(), structure)
      when is_tuple(structure) do
    expected_size = tuple_size(structure)

    Schema.validate(
      schema,
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

      case Schema.eval(schema_or_value, value) do
        :ok -> {:cont, :ok}
        error -> {:halt, error}
      end
    end)
  end

  defp check_tuple_shape(_, _, _), do: :error

  @spec size(t, non_neg_integer) :: t
  def size(%Schema{name: :tuple} = schema \\ t(), count)
      when is_integer(count) and count >= 0 do
    Schema.validate(
      schema,
      :size,
      fn tuple -> tuple_size(tuple) == count end,
      %{count: count}
    )
  end
end
