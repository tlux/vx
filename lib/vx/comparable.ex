defmodule Vx.Comparable do
  @moduledoc """
  A module for creating constraints that verify if a value is comparable to
  another value.
  """
  @moduledoc since: "1.0.0"

  import Vx.Constrain

  alias Vx.Comparable.{
    EqualTo,
    GreaterThan,
    GreaterThanOrEqualTo,
    LessThan,
    LessThanOrEqualTo
  }

  defstruct []

  @doc """
  A constraint that verifies if a comparable value is equal to another value.

  ## Examples

      iex> version = Version.parse!("1.2.3")
      ...> Vx.Comparable.eq(version) |> Vx.valid?(version)
      true

      iex> Vx.Comparable.eq(Version.parse!("1.2.3")) |> Vx.valid?(Version.parse!("1.2.4"))
      false
  """
  @spec eq(any) :: Vx.t()
  def eq(%comparable{} = value) do
    eq(Vx.Any.t(), comparable, value)
  end

  @doc """
  A constraint that verifies if a comparable value is equal to another value.

  """
  @spec eq(Vx.t() | module, any) :: Vx.t()
  def eq(comparable_or_schema, value)

  def eq(comparable, value) when is_atom(comparable) do
    eq(Vx.Any.t(), comparable, value)
  end

  def eq(schema, %comparable{} = value) do
    eq(schema, comparable, value)
  end

  @spec eq(Vx.t(), module, any) :: Vx.t()
  def eq(schema, comparable, value) when is_atom(comparable) do
    constrain(schema, EqualTo, comparable, value)
  end

  @spec gt(any) :: Vx.t()
  def gt(%comparable{} = value) do
    gt(Vx.Any.t(), comparable, value)
  end

  @spec gt(Vx.t() | module, any) :: Vx.t()
  def gt(comparable_or_schema, value)

  def gt(comparable, value) when is_atom(comparable) do
    gt(Vx.Any.t(), comparable, value)
  end

  def gt(schema, %comparable{} = value) do
    gt(schema, comparable, value)
  end

  @spec gt(Vx.t(), module, any) :: Vx.t()
  def gt(schema, comparable, value) when is_atom(comparable) do
    constrain(schema, GreaterThan, comparable, value)
  end

  @spec gteq(any) :: Vx.t()
  def gteq(%comparable{} = value) do
    gteq(Vx.Any.t(), comparable, value)
  end

  @spec gteq(Vx.t() | module, any) :: Vx.t()
  def gteq(comparable_or_schema, value)

  def gteq(comparable, value) when is_atom(comparable) do
    gteq(Vx.Any.t(), comparable, value)
  end

  def gteq(schema, %comparable{} = value) do
    gteq(schema, comparable, value)
  end

  @spec gteq(Vx.t(), module, any) :: Vx.t()
  def gteq(schema, comparable, value) when is_atom(comparable) do
    constrain(schema, GreaterThanOrEqualTo, comparable, value)
  end

  @spec lt(any) :: Vx.t()
  def lt(%comparable{} = value) do
    lt(Vx.Any.t(), comparable, value)
  end

  @spec lt(Vx.t() | module, any) :: Vx.t()
  def lt(comparable_or_schema, value)

  def lt(comparable, value) when is_atom(comparable) do
    lt(Vx.Any.t(), comparable, value)
  end

  def lt(schema, %comparable{} = value) do
    lt(schema, comparable, value)
  end

  @spec lt(Vx.t(), module, any) :: Vx.t()
  def lt(schema, comparable, value) when is_atom(comparable) do
    constrain(schema, LessThan, comparable, value)
  end

  @spec lteq(any) :: Vx.t()
  def lteq(%comparable{} = value) do
    lteq(Vx.Any.t(), comparable, value)
  end

  @spec lteq(Vx.t() | module, any) :: Vx.t()
  def lteq(comparable_or_schema, value)

  def lteq(comparable, value) when is_atom(comparable) do
    lteq(Vx.Any.t(), comparable, value)
  end

  def lteq(schema, %comparable{} = value) do
    lteq(schema, comparable, value)
  end

  @spec lteq(Vx.t(), module, any) :: Vx.t()
  def lteq(schema, comparable, value) when is_atom(comparable) do
    constrain(schema, LessThanOrEqualTo, comparable, value)
  end

  defp constrain(schema, constraint, comparable, value)
       when is_atom(constraint) and is_atom(comparable) do
    if Code.ensure_loaded?(comparable) &&
         function_exported?(comparable, :compare, 2) do
      constrain_any(
        schema,
        struct!(constraint, comparable: comparable, value: value)
      )
    else
      raise ArgumentError, "#{inspect(comparable)} does not implement compare/2"
    end
  end
end
