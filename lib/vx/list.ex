defmodule Vx.List do
  alias Vx.Schema

  @type t :: Schema.t(:list)

  @spec t() :: t
  def t, do: Schema.new(:list, &is_list/1)

  @spec of(t, Schema.t() | [Schema.t()]) :: t
  def of(schema \\ t(), element_schema_or_schemata)

  def of(%Schema{name: :list} = schema, element_schemata)
      when is_list(element_schemata) do
    of(schema, Schema.union(element_schemata))
  end

  def of(%Schema{name: :list} = schema, %Schema{} = element_schema) do
    Schema.validate(
      schema,
      :of,
      fn values ->
        Enum.reduce_while(values, :ok, fn value, _ ->
          case Schema.eval(element_schema, value) do
            :ok -> {:cont, :ok}
            {:error, error} -> {:halt, error}
          end
        end)
      end,
      %{element_schema: element_schema}
    )
  end

  @spec non_empty(t) :: t
  def non_empty(%Schema{name: :list} = schema \\ t()) do
    Schema.validate(schema, :non_empty, fn
      [] -> false
      _ -> true
    end)
  end
end
