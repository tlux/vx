defmodule Vx.List do
  use Vx.Type

  @spec t() :: t
  def t, do: init(&is_list/1)

  @spec t(Vx.Validatable.t() | [Vx.Validatable.t()]) :: t
  def t(types_or_values) when is_list(types_or_values) do
    types_or_values
    |> Vx.Union.t()
    |> t()
  end

  def t(type_or_value) do
    init(
      &check_member_type(&1, type_or_value),
      %{of: type_or_value}
    )
  end

  defp check_member_type(values, type_or_value) when is_list(values) do
    Enum.reduce_while(values, :ok, fn value, _ ->
      case Vx.Validatable.validate(type_or_value, value) do
        :ok -> {:cont, :ok}
        {:error, error} -> {:halt, error}
      end
    end)
  end

  defp check_member_type(_, _), do: :error

  @spec non_empty(t) :: t
  def non_empty(%__MODULE__{} = type \\ t()) do
    validate(type, :non_empty, fn
      [] -> false
      _ -> true
    end)
  end

  @spec shape(t, [Vx.Validatable.t()]) :: t
  def shape(%__MODULE__{} = type \\ t(), structure)
      when is_list(structure) do
    expected_size = length(structure)

    validate(
      type,
      :shape,
      &check_list_shape(&1, structure, expected_size),
      %{structure: structure}
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

  @spec size(t, non_neg_integer) :: t
  def size(%__MODULE__{} = type \\ t(), count)
      when is_integer(count) and count >= 0 do
    validate(type, :size, &(length(&1) == count), %{count: count})
  end
end
