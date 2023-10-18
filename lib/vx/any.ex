defmodule Vx.Any do
  alias Vx.Schema

  def t, do: Schema.new(:any)

  @spec is(Schema.t(), [any]) :: Schema.t()
  def is(%Schema{} = schema \\ t(), value) do
    Schema.validate(schema, {:is, value}, fn
      ^value -> true
      _ -> false
    end)
  end

  @spec of(Schema.t(), [any]) :: Schema.t()
  def of(%Schema{} = schema \\ t(), values) when is_list(values) do
    Schema.validate(schema, {:of, values}, &Enum.member?(values, &1))
  end
end
