defmodule Vx do
  defdelegate non_nil(), to: Vx.Any
  defdelegate non_nil(schema), to: Vx.Any

  defdelegate eq(value), to: Vx.Any
  defdelegate eq(schema, value), to: Vx.Any

  defdelegate not_eq(value), to: Vx.Any
  defdelegate not_eq(schema, value), to: Vx.Any

  defdelegate union(schemata), to: Vx.Schema
  defdelegate union(schema, other), to: Vx.Schema
end
