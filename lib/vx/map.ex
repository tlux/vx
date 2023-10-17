defmodule Vx.Map do
  alias Vx.Schema

  def t do
    Schema.new(:map, &is_map/1)
  end

  def shape(%Schema{type: :map} = schema \\ t(), target) do
    Schema.validate(schema, :shape, fn map ->
      Enum.reduce_while(target, :ok, fn {key, value_schema}, _ ->
        with {:ok, value} <- Map.fetch(map, key),
             :ok <- validate_value(value_schema, value) do
          {:cont, :ok}
        else
          error -> {:halt, error}
        end
      end)
    end)
  end

  defp validate_value(%Schema{} = schema, value),
    do: Schema.eval(schema, value)

  defp validate_value(value, value), do: :ok

  defp validate_value(_, _), do: :error
end
