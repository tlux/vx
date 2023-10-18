defmodule Vx.Number do
  alias Vx.Schema

  @type t :: Schema.t(:number)

  @spec t() :: t
  def t do
    Schema.new(:number, &is_number/1)
  end

  @spec eq(t, number) :: t
  def eq(%Schema{type: :number} = schema \\ t(), value)
      when is_number(value) do
    Vx.Any.is(schema, value)
  end

  def lt(%Schema{type: :number} = schema \\ t(), value) when is_number(value) do
    Schema.validate(schema, {:lt, value}, fn actual_value ->
      actual_value < value
    end)
  end

  def lteq(%Schema{type: :number} = schema \\ t(), value)
      when is_number(value) do
    Schema.validate(schema, {:lteq, value}, fn actual_value ->
      actual_value <= value
    end)
  end

  def gt(%Schema{type: :number} = schema \\ t(), value) when is_number(value) do
    Schema.validate(schema, {:gt, value}, fn actual_value ->
      actual_value > value
    end)
  end

  def gteq(%Schema{type: :number} = schema \\ t(), value)
      when is_number(value) do
    Schema.validate(schema, {:gteq, value}, fn actual_value ->
      actual_value >= value
    end)
  end
end
