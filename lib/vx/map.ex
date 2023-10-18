defmodule Vx.Map do
  alias Vx.Schema

  @type t :: Schema.t(:map)

  @spec t() :: t
  def t do
    Schema.new(:map, &is_map/1)
  end

  @spec pairs(t, Schema.t(), Schema.t()) :: t
  def pairs(
        %Schema{name: :map} = schema \\ t(),
        %Schema{} = key_schema,
        %Schema{} = value_schema
      ) do
    Schema.validate(
      schema,
      :pairs,
      fn map ->
        Enum.reduce_while(map, :ok, fn {key, value}, _ ->
          with :ok <- Schema.eval(key_schema, key),
               :ok <- Schema.eval(value_schema, value) do
            {:cont, :ok}
          else
            error -> {:halt, error}
          end
        end)
      end,
      %{key_schema: key_schema, value_schema: value_schema}
    )
  end

  @spec shape(t, %{optional(any) => Schema.t() | any}) :: t
  def shape(%Schema{name: :map} = schema \\ t(), children) do
    Schema.validate(
      schema,
      :shape,
      fn map ->
        Enum.reduce_while(children, :ok, fn {key, value_schema}, _ ->
          with {:ok, value} <- Map.fetch(map, key),
               :ok <- validate_value(value_schema, value) do
            {:cont, :ok}
          else
            error -> {:halt, error}
          end
        end)
      end,
      %{children: children}
    )
  end

  defp validate_value(%Schema{} = schema, value), do: Schema.eval(schema, value)
  defp validate_value(value, value), do: :ok
  defp validate_value(_, _), do: :error

  @spec size(t, non_neg_integer) :: t
  def size(%Schema{name: :map} = schema \\ t(), count)
      when is_integer(count) and count >= 0 do
    Schema.validate(
      schema,
      :size,
      fn map -> map_size(map) == count end,
      %{count: count}
    )
  end
end
