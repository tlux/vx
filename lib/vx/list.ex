defmodule Vx.List do
  @moduledoc """
  The List type provides validators for lists.
  """

  use Vx.Type

  @doc """
  Checks whether a value is a list.
  """
  @spec t() :: t
  def t, do: new(&is_list/1, %{}, "must be a list")

  @doc """
  Checks whether a value is a list containing only elements of the specified
  type or types. When a list of types is given, it will be treated as a union.
  """
  @spec t(Vx.t() | [Vx.t()]) :: t
  def t(types) when is_list(types) do
    types
    |> Vx.Union.t()
    |> t()
  end

  def t(type) do
    new(
      &check_member_type(&1, type),
      %{of: type},
      "must be a typed list"
    )
  end

  defp check_member_type(values, type) when is_list(values) do
    Enum.reduce_while(values, :ok, fn value, _ ->
      case Vx.Validatable.validate(type, value) do
        :ok -> {:cont, :ok}
        error -> {:halt, error}
      end
    end)
  end

  defp check_member_type(_, _), do: :error

  @doc """
  Checks whether a value is a non-empty list.
  """
  @spec non_empty(t) :: t
  def non_empty(%__MODULE__{} = type \\ t()) do
    add_rule(
      type,
      :non_empty,
      fn
        [] -> false
        _ -> true
      end,
      %{},
      "must not be empty"
    )
  end

  @doc """
  Checks whether a value is a list of the given size and types at the specified
  positions.
  """
  @spec shape(t, [Vx.t()]) :: t
  def shape(%__MODULE__{} = type \\ t(), shape) when is_list(shape) do
    expected_size = length(shape)

    add_rule(
      type,
      :shape,
      &check_list_shape(&1, shape, expected_size),
      %{shape: shape},
      "does not match expected shape"
    )
  end

  defp check_list_shape(list, structure, expected_size)
       when length(list) == expected_size do
    structure
    |> Enum.with_index()
    |> Enum.reduce_while(:ok, fn {schema_or_value, index}, _ ->
      value = Enum.at(list, index)

      case Vx.Validatable.validate(schema_or_value, value) do
        :ok -> {:cont, :ok}
        error -> {:halt, error}
      end
    end)
  end

  defp check_list_shape(_, _, _), do: :error

  @doc """
  Checks whether a value is a list of the given size.
  """
  @spec size(t, non_neg_integer) :: t
  def size(%__MODULE__{} = type \\ t(), count)
      when is_integer(count) and count >= 0 do
    add_rule(
      type,
      :size,
      &(length(&1) == count),
      %{count: count},
      "does not match expected size of #{count}"
    )
  end
end
