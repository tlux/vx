defmodule Vx.String do
  alias Vx.Schema

  @spec t() :: Schema.t()
  def t do
    Schema.new(:string, &String.valid?/1)
  end

  @spec nonempty(Schema.t(:string)) :: Schema.t(:string)
  def nonempty(%Schema{type: :string} = schema \\ t()) do
    Schema.validate(schema, :nonempty, fn
      "" -> false
      _ -> true
    end)
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
