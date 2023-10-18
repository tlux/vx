defmodule Vx.String do
  alias Vx.Schema

  @type t :: Schema.t(:string)

  @spec t() :: t
  def t do
    Schema.new(:string, &String.valid?/1)
  end

  @spec non_empty(t) :: t
  def non_empty(%Schema{name: :string} = schema \\ t()) do
    Schema.validate(schema, :non_empty, fn
      "" -> false
      _ -> true
    end)
  end

  @spec present(t) :: t
  def present(%Schema{name: :string} = schema \\ t()) do
    Schema.validate(schema, :present, fn value -> String.trim(value) != "" end)
  end

  @spec min(t, non_neg_integer) :: t
  def min(%Schema{name: :string} = schema \\ t(), length)
      when is_integer(length) and length >= 0 do
    Schema.validate(schema, :min, fn value ->
      String.length(value) >= length
    end)
  end

  @spec max(t, non_neg_integer) :: t
  def max(%Schema{name: :string} = schema \\ t(), length)
      when is_integer(length) and length >= 0 do
    Schema.validate(schema, :max, fn value ->
      String.length(value) <= length
    end)
  end

  @spec format(t, Regex.t()) :: t
  def format(%Schema{name: :string} = schema \\ t(), %Regex{} = regex) do
    Schema.validate(schema, :format, fn value ->
      Regex.match?(regex, value)
    end)
  end
end
