defmodule Vx.Any do
  alias Vx.Schema

  @type t :: Schema.t()

  @spec t() :: t
  def t, do: Schema.new(:any)

  @spec non_nil(t) :: t
  def non_nil(%Schema{} = schema \\ t()) do
    not_eq(schema, nil)
  end

  @spec eq(t, any) :: t
  def eq(%Schema{} = schema \\ t(), value) do
    Schema.validate(
      schema,
      :eq,
      fn actual_value ->
        actual_value == value
      end,
      %{value: value}
    )
  end

  @spec not_eq(t, any) :: t
  def not_eq(%Schema{} = schema \\ t(), value) do
    Schema.validate(
      schema,
      :not_eq,
      fn actual_value ->
        actual_value != value
      end,
      %{value: value}
    )
  end

  @spec of(t, [any]) :: t
  def of(%Schema{} = schema \\ t(), values) when is_list(values) do
    Schema.validate(schema, :of, &Enum.member?(values, &1), %{values: values})
  end

  @spec not_of(t, [any]) :: t
  def not_of(%Schema{} = schema \\ t(), values) when is_list(values) do
    Schema.validate(
      schema,
      :not_of,
      fn value -> !Enum.member?(values, value) end,
      %{values: values}
    )
  end

  @spec match(any, any) :: Macro.t()
  defmacro match(schema, pattern) do
    quote do
      Schema.validate(
        unquote(schema),
        :match,
        fn value ->
          match?(unquote(pattern), value)
        end
      )
    end
  end
end
