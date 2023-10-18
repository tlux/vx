defmodule Vx.Number do
  alias Vx.Schema

  @type t :: Schema.t(:number)

  @spec t() :: t
  def t, do: Schema.new(:number, &is_number/1)

  @spec lt(Schema.t(), number) :: Schema.t()
  def lt(%Schema{} = schema \\ t(), value) when is_number(value) do
    Schema.validate(
      schema,
      :lt,
      fn actual_value ->
        actual_value < value
      end,
      %{value: value}
    )
  end

  @spec lteq(Schema.t(), number) :: Schema.t()
  def lteq(%Schema{} = schema \\ t(), value)
      when is_number(value) do
    Schema.validate(
      schema,
      :lteq,
      fn actual_value ->
        actual_value <= value
      end,
      %{value: value}
    )
  end

  @spec gt(Schema.t(), number) :: Schema.t()
  def gt(%Schema{} = schema \\ t(), value) when is_number(value) do
    Schema.validate(
      schema,
      :gt,
      fn actual_value ->
        actual_value > value
      end,
      %{value: value}
    )
  end

  @spec gteq(Vx.Schema.t(), number) :: Schema.t()
  def gteq(%Schema{} = schema \\ t(), value)
      when is_number(value) do
    Schema.validate(
      schema,
      :gteq,
      fn actual_value ->
        actual_value >= value
      end,
      %{value: value}
    )
  end

  @spec range(Schema.t(), Range.t(number, number)) :: Schema.t()
  def range(%Schema{} = schema \\ t(), _min.._max = range) do
    Schema.validate(
      schema,
      :range,
      fn value ->
        value in range
      end,
      %{range: range}
    )
  end

  @spec between(Schema.t(), number, number) :: Schema.t()
  def between(%Schema{} = schema \\ t(), min, max)
      when is_number(min) and is_number(max) and min <= max do
    Schema.validate(
      schema,
      :between,
      fn value -> value >= min && value <= max end,
      %{min: min, max: max}
    )
  end
end
