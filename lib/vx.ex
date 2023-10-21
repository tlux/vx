defmodule Vx do
  defdelegate t(), to: Vx.Any

  defdelegate non_nil(), to: Vx.Any
  defdelegate non_nil(schema), to: Vx.Any

  defdelegate eq(value), to: Vx.Any
  defdelegate eq(schema, value), to: Vx.Any

  defdelegate not_eq(value), to: Vx.Any
  defdelegate not_eq(schema, value), to: Vx.Any

  defdelegate of(values), to: Vx.Any
  defdelegate of(schema, values), to: Vx.Any

  defdelegate not_of(values), to: Vx.Any
  defdelegate not_of(schema, values), to: Vx.Any

  defdelegate intersect(schemata), to: Vx.Schema
  defdelegate intersect(schema, other), to: Vx.Schema

  defdelegate union(schemata), to: Vx.Schema
  defdelegate union(schema, other), to: Vx.Schema

  defdelegate eval(schema, value), to: Vx.Schema
  defdelegate eval!(schema, value), to: Vx.Schema
  defdelegate valid?(schema, value), to: Vx.Schema
end
