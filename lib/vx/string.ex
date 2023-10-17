defmodule Vx.String do
  alias Vx.Common
  alias Vx.Schema

  @spec t() :: Schema.t()
  def t do
    Schema.new(:string, &String.valid?/1)
  end

  @spec eq(Schema.t(:string), String.t()) :: Schema.t()
  def eq(%Schema{type: :string} = schema \\ t(), value) when is_binary(value) do
    Common.eq(schema, value)
  end

  @spec non_empty(Schema.t(:string)) :: Schema.t(:string)
  def non_empty(%Schema{type: :string} = schema \\ t()) do
    Schema.validate(schema, :non_empty, fn
      "" -> false
      _ -> true
    end)
  end

  @spec present(Schema.t(:string)) :: Schema.t(:string)
  def present(%Schema{type: :string} = schema \\ t()) do
    Schema.validate(schema, :present, fn value -> String.trim(value) != "" end)
  end

  @spec min(Schema.t(:string), non_neg_integer) :: Schema.t(:string)
  def min(%Schema{type: :string} = schema \\ t(), length)
      when is_integer(length) and length >= 0 do
    Schema.validate(schema, :min, fn value ->
      String.length(value) >= length
    end)
  end

  @spec max(Schema.t(:string), non_neg_integer) :: Schema.t(:string)
  def max(%Schema{type: :string} = schema \\ t(), length)
      when is_integer(length) and length >= 0 do
    Schema.validate(schema, :max, fn value ->
      String.length(value) <= length
    end)
  end
end
