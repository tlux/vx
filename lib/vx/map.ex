defmodule Vx.Map do
  use Vx.Type

  @spec t() :: t
  def t, do: init(&is_map/1)

  @spec t(Vx.Validatable.t(), Vx.Validatable.t()) :: t
  def t(key_schema, value_schema) do
    init(
      &check_member_types(&1, key_schema, value_schema),
      %{key: key_schema, value: value_schema}
    )
  end

  defp check_member_types(map, key_schema, value_schema) when is_map(map) do
    Enum.reduce_while(map, :ok, fn {key, value}, _ ->
      with :ok <- Vx.Validatable.validate(key_schema, key),
           :ok <- Vx.Validatable.validate(value_schema, value) do
        {:cont, :ok}
      else
        error -> {:halt, error}
      end
    end)
  end

  defp check_member_types(_, _, _), do: :error

  @spec shape(t, %{optional(any) => Vx.Validatable.t()}) :: t
  def shape(%__MODULE__{} = type \\ t(), structure) do
    validate(
      type,
      :shape,
      &check_map_shape(&1, structure),
      %{structure: structure}
    )
  end

  defp check_map_shape(map, structure) do
    Enum.reduce_while(structure, :ok, fn {key, value_schema}, _ ->
      with {:ok, value} <- Map.fetch(map, key),
           :ok <- Vx.Validatable.validate(value_schema, value) do
        {:cont, :ok}
      else
        error -> {:halt, error}
      end
    end)
  end

  @spec size(t, non_neg_integer) :: t
  def size(%__MODULE__{} = type \\ t(), count)
      when is_integer(count) and count >= 0 do
    validate(type, :size, &(map_size(&1) == count), %{count: count})
  end
end
