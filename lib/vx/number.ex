defmodule Vx.Number do
  @moduledoc """
  The Number type provides validators for numbers.
  """

  use Vx.Type

  @typedoc """
  All types that can be validated as a number.
  """
  @type num :: t | Vx.Integer.t() | Vx.Float.t()

  @doc """
  Checks whether a value is a number.
  """
  @spec t() :: t
  def t, do: init(&is_number/1)

  @doc """
  Checks whether a value is less than the given value.
  """
  @spec lt(num, number) :: t
  def lt(type \\ t(), value) when is_number(value) do
    validate(type, :lt, &(&1 < value), %{value: value})
  end

  @doc """
  Checks whether a value is less than or equal to the given value.
  """
  @spec lteq(num, number) :: t
  def lteq(type \\ t(), value) when is_number(value) do
    validate(type, :lteq, &(&1 <= value), %{value: value})
  end

  @doc """
  Checks whether a value is greater than the given value.
  """
  @spec gt(num, number) :: t
  def gt(type \\ t(), value) when is_number(value) do
    validate(type, :gt, &(&1 > value), %{value: value})
  end

  @doc """
  Checks whether a value is greater than or equal to the given value.
  """
  @spec gteq(num, number) :: t
  def gteq(type \\ t(), value) when is_number(value) do
    validate(type, :gteq, &(&1 >= value), %{value: value})
  end

  @doc """
  Checks whether a value is within the given range.
  """
  @spec range(num, Range.t(number, number)) :: t
  def range(type \\ t(), range) do
    validate(type, :range, &(&1 in range), %{range: range})
  end

  @doc """
  Checks whether a value is between the given range.
  """
  @spec between(num, number, number) :: t
  def between(type \\ t(), first, last)

  def between(type, min, max)
      when is_number(min) and is_number(max) and min <= max do
    validate(type, :between, &(&1 >= min && &1 <= max), %{min: min, max: max})
  end

  def between(type, first, last)
      when is_number(first) and is_number(last) and first > last do
    between(type, last, first)
  end

  @doc """
  Checks whether a number value is an integer. The check will also match if the
  number is a float but has no decimal places.
  """
  @spec integer(t) :: t
  def integer(%__MODULE__{} = type \\ t()) do
    validate(type, :integer, fn
      value when is_integer(value) -> true
      value when is_float(value) -> Float.floor(value) == value
    end)
  end
end
