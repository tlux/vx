defmodule Vx.Map do
  alias Vx.Schema

  @type t :: Schema.t(:map)

  @spec t() :: t
  def t do
    Schema.new(:map, &is_map/1)
  end

  @spec t(Schema.t(), Schema.t()) :: t
  def t(%Schema{} = key_schema, %Schema{} = value_schema) do
    Schema.new(
      :map,
      &validate_map(&1, key_schema, value_schema),
      %{key: key_schema, value: value_schema}
    )
  end

  defp validate_map(map, key_schema, value_schema) when is_map(map) do
    Enum.reduce_while(map, :ok, fn {key, value}, _ ->
      with :ok <- Schema.eval(key_schema, key),
           :ok <- Schema.eval(value_schema, value) do
        {:cont, :ok}
      else
        error -> {:halt, error}
      end
    end)
  end

  defp validate_map(_, _, _), do: :error

  @spec shape(t, %{optional(any) => Schema.t() | any}) :: t
  def shape(%Schema{name: :map} = schema \\ t(), structure) do
    Schema.validate(
      schema,
      :shape,
      &check_map_shape(&1, structure),
      %{structure: structure}
    )
  end

  defp check_map_shape(map, structure) do
    Enum.reduce_while(structure, :ok, fn {key, value_schema}, _ ->
      with :ok <- validate_key(key),
           {:ok, value} <- Map.fetch(map, key),
           :ok <- Schema.eval(value_schema, value) do
        {:cont, :ok}
      else
        error -> {:halt, error}
      end
    end)
  end

  defp validate_key(%Schema{} = schema) do
    {:error,
     %Vx.UnexpectedSchemaError{
       message: "Schema unexpectedly used as map key",
       schema: schema
     }}
  end

  defp validate_key(_), do: :ok

  @spec size(t, non_neg_integer) :: t
  def size(%Schema{name: :map} = schema \\ t(), count)
      when is_integer(count) and count >= 0 do
    Schema.validate(
      schema,
      :size,
      &(map_size(&1) == count),
      %{count: count}
    )
  end
end
