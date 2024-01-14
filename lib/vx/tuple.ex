defmodule Vx.Tuple do
  @moduledoc """
  The Tuple type provides validators for tuples.
  """

  use Vx.Type

  @doc """
  Checks whether a value is a tuple.
  """
  @spec t() :: t
  def t, do: init(&is_tuple/1)

  @doc """
  Checks whether a value is a tuple of the given size and types.
  """
  @spec shape(t, tuple) :: t
  def shape(%__MODULE__{} = type \\ t(), shape) when is_tuple(shape) do
    expected_size = tuple_size(shape)

    add_validator(
      type,
      :shape,
      &check_tuple_shape(&1, shape, expected_size),
      %{shape: shape}
    )
  end

  defp check_tuple_shape(tuple, shape, expected_size)
       when tuple_size(tuple) == expected_size do
    Enum.reduce_while(0..(expected_size - 1), :ok, fn index, _ ->
      schema_or_value = elem(shape, index)
      value = elem(tuple, index)

      case Vx.Validatable.validate(schema_or_value, value) do
        :ok -> {:cont, :ok}
        error -> {:halt, error}
      end
    end)
  end

  defp check_tuple_shape(_, _, _), do: :error

  @doc """
  Checks whether a value is a tuple of the given size.
  """
  @spec size(t, non_neg_integer) :: t
  def size(%__MODULE__{} = type \\ t(), count)
      when is_integer(count) and count >= 0 do
    add_validator(
      type,
      :size,
      fn tuple -> tuple_size(tuple) == count end,
      %{count: count}
    )
  end
end
