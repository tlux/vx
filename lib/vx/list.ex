defmodule Vx.List do
  alias Vx.Schema

  @type t :: Schema.t(:list)

  def t do
    Schema.new(:list, &is_list/1)
  end

  def of(schema \\ t(), element_schema_or_schemata)

  def of(%Schema{type: :list} = schema, element_schemata)
      when is_list(element_schemata) do
    of(schema, Vx.any_of(element_schemata))
  end

  def of(%Schema{type: :list} = schema, %Schema{} = element_schema) do
    Schema.validate(schema, {:of, element_schema}, fn values ->
      Enum.reduce_while(values, :ok, fn value, _ ->
        case Schema.eval(schema, value) do
          :ok -> {:cont, :ok}
          {:error, error} -> {:halt, error}
        end
      end)
    end)
  end

  def non_empty(%Schema{type: :list} = schema \\ t()) do
    Schema.validate(schema, :non_empty, fn
      [] -> false
      _ -> true
    end)
  end
end
