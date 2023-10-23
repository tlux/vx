defmodule Vx.Number do
  use Vx.Type

  @spec t() :: t
  def t, do: init(&is_number/1)

  @spec lt(Vx.t(), number) :: t
  def lt(type \\ t(), value) when is_number(value) do
    validate(type, :lt, &(&1 < value), %{value: value})
  end

  @spec lteq(Vx.t(), number) :: t
  def lteq(type \\ t(), value) when is_number(value) do
    validate(type, :lteq, &(&1 <= value), %{value: value})
  end

  @spec gt(Vx.t(), number) :: t
  def gt(type \\ t(), value) when is_number(value) do
    validate(type, :gt, &(&1 > value), %{value: value})
  end

  @spec gteq(Vx.t(), number) :: t
  def gteq(type \\ t(), value) when is_number(value) do
    validate(type, :gteq, &(&1 >= value), %{value: value})
  end

  @spec range(Vx.t(), Range.t(number, number)) :: t
  def range(type \\ t(), range) do
    validate(type, :range, &(&1 in range), %{range: range})
  end

  @spec between(Vx.t(), number, number) :: t
  def between(type \\ t(), first, last)

  def between(type, min, max)
      when is_number(min) and is_number(max) and min <= max do
    validate(type, :between, &(&1 >= min && &1 <= max), %{min: min, max: max})
  end

  def between(type, first, last)
      when is_number(first) and is_number(last) and first > last do
    between(type, last, first)
  end

  @spec integer(t) :: t
  def integer(%__MODULE__{} = type \\ t()) do
    validate(type, :integer, fn
      value when is_integer(value) -> true
      value when is_float(value) -> Float.floor(value) == value
    end)
  end
end
