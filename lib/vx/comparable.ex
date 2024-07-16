defmodule Vx.Comparable do
  @moduledoc """
  A module for creating constraints that verify if a value is comparable to
  another value.
  """
  @moduledoc since: "1.0.0"

  import Vx.Constrain

  alias __MODULE__.{
    EqualTo,
    GreaterThan,
    GreaterThanOrEqualTo,
    LessThan,
    LessThanOrEqualTo
  }

  defstruct []

  @type comparable :: module

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
  A constraint that verifies if a comparable value is equal to another value
  using either a parent schema or a module implementing the `compare/2`
  function.

  ## Examples

      iex> version = Version.parse!("1.2.3")
      ...> Vx.Any.t() |> Vx.Comparable.eq(version) |> Vx.valid?(version)
      true

      iex> version = Version.parse!("1.2.3")
      ...> Version |> Vx.Comparable.eq(version) |> Vx.valid?(version)
      true
  """
  @spec eq(Vx.t() | comparable, any) :: Vx.t()
  def eq(comparable_or_schema, value)

  def eq(comparable, value) when is_atom(comparable) do
    eq(Vx.Any.t(), comparable, value)
  end

  def eq(schema, %comparable{} = value) do
    eq(schema, comparable, value)
  end

  @doc """
  A constraint that verifies if a comparable value is equal to another value
  using a parent schema and a module implementing the `compare/2` function.

  ## Examples

      iex> version = Version.parse!("1.2.3")
      ...> Vx.Any.t()
      ...> |> Vx.Comparable.eq(Version, version)
      ...> |> Vx.valid?(version)
      true
  """
  @spec eq(Vx.t(), comparable, any) :: Vx.t()
  def eq(schema, comparable, value) when is_atom(comparable) do
    constrain(schema, EqualTo, comparable, value)
  end

  @doc """
  A constraint that verifies if a comparable value is greater than another value.

  ## Examples

      iex> Vx.Comparable.gt(Version.parse!("1.2.3"))
      ...> |> Vx.valid?(Version.parse!("1.2.4"))
      true

      iex> Vx.Comparable.gt(Version.parse!("1.2.3"))
      ...> |> Vx.valid?(Version.parse!("1.2.3"))
      false

      iex> Vx.Comparable.gt(Version.parse!("1.2.3"))
      ...>  |> Vx.valid?(Version.parse!("1.2.2"))
      false
  """
  @spec gt(any) :: Vx.t()
  def gt(%comparable{} = value) do
    gt(Vx.Any.t(), comparable, value)
  end

  @doc """
  A constraint that verifies if a comparable value is greater than another value
  using either a parent schema or a module implementing the `compare/2`
  function.

  ## Examples

      iex> Vx.Any.t()
      ...> |> Vx.Comparable.gt(Version.parse!("1.2.3"))
      ...> |> Vx.valid?(Version.parse!("1.2.4"))
      true

      iex> Version
      ...> |> Vx.Comparable.gt(Version.parse!("1.2.3"))
      ...> |> Vx.valid?(Version.parse!("1.2.4"))
      true
  """
  @spec gt(Vx.t() | comparable, any) :: Vx.t()
  def gt(comparable_or_schema, value)

  def gt(comparable, value) when is_atom(comparable) do
    gt(Vx.Any.t(), comparable, value)
  end

  def gt(schema, %comparable{} = value) do
    gt(schema, comparable, value)
  end

  @doc """
  A constraint that verifies if a comparable value is greater than another value
  using a parent schema and a module implementing the `compare/2` function.

  ## Examples

      iex> Vx.Any.t()
      ...> |> Vx.Comparable.gt(Version, Version.parse!("1.2.3"))
      ...> |> Vx.valid?(Version.parse!("1.2.4"))
      true
  """
  @spec gt(Vx.t(), comparable, any) :: Vx.t()
  def gt(schema, comparable, value) when is_atom(comparable) do
    constrain(schema, GreaterThan, comparable, value)
  end

  @doc """
  A constraint that verifies if a comparable value is greater than or equal to
  another value.

  ## Examples

      iex> Vx.Comparable.gteq(Version.parse!("1.2.3"))
      ...> |> Vx.valid?(Version.parse!("1.2.4"))
      true

      iex> Vx.Comparable.gteq(Version.parse!("1.2.3"))
      ...> |> Vx.valid?(Version.parse!("1.2.3"))
      true

      iex> Vx.Comparable.gteq(Version.parse!("1.2.3"))
      ...> |> Vx.valid?(Version.parse!("1.2.2"))
      false
  """
  @spec gteq(any) :: Vx.t()
  def gteq(%comparable{} = value) do
    gteq(Vx.Any.t(), comparable, value)
  end

  @doc """
  A constraint that verifies if a comparable value is greater than or equal to
  another value using either a parent schema or a module implementing the
  `compare/2` function.

  ## Examples

      iex> Vx.Any.t()
      ...> |> Vx.Comparable.gteq(Version.parse!("1.2.3"))
      ...> |> Vx.valid?(Version.parse!("1.2.4"))
      true

      iex> Version
      ...> |> Vx.Comparable.gteq(Version.parse!("1.2.3"))
      ...> |> Vx.valid?(Version.parse!("1.2.4"))
      true
  """
  @spec gteq(Vx.t() | comparable, any) :: Vx.t()
  def gteq(comparable_or_schema, value)

  def gteq(comparable, value) when is_atom(comparable) do
    gteq(Vx.Any.t(), comparable, value)
  end

  def gteq(schema, %comparable{} = value) do
    gteq(schema, comparable, value)
  end

  @doc """
  A constraint that verifies if a comparable value is greater than or equal to
  another value using a parent schema and a module implementing the `compare/2`
  function.

  ## Examples

      iex> Vx.Any.t()
      ...> |> Vx.Comparable.gteq(Version, Version.parse!("1.2.3"))
      ...> |> Vx.valid?(Version.parse!("1.2.4"))
      true
  """
  @spec gteq(Vx.t(), comparable, any) :: Vx.t()
  def gteq(schema, comparable, value) when is_atom(comparable) do
    constrain(schema, GreaterThanOrEqualTo, comparable, value)
  end

  @doc """
  A constraint that verifies if a comparable value is less than another value.

  ## Examples

      iex> Vx.Comparable.lt(Version.parse!("1.2.3"))
      ...> |> Vx.valid?(Version.parse!("1.2.4"))
      false

      iex> Vx.Comparable.lt(Version.parse!("1.2.3"))
      ...> |> Vx.valid?(Version.parse!("1.2.3"))
      false

      iex> Vx.Comparable.lt(Version.parse!("1.2.3"))
      ...>  |> Vx.valid?(Version.parse!("1.2.2"))
      true
  """
  @spec lt(any) :: Vx.t()
  def lt(%comparable{} = value) do
    lt(Vx.Any.t(), comparable, value)
  end

  @doc """
  A constraint that verifies if a comparable value is less than another value
  using either a parent schema or a module implementing the `compare/2`
  function.

  ## Examples

      iex> Vx.Any.t()
      ...> |> Vx.Comparable.lt(Version.parse!("1.2.3"))
      ...> |> Vx.valid?(Version.parse!("1.2.2"))
      true

      iex> Version
      ...> |> Vx.Comparable.lt(Version.parse!("1.2.3"))
      ...> |> Vx.valid?(Version.parse!("1.2.2"))
      true
  """
  @spec lt(Vx.t() | comparable, any) :: Vx.t()
  def lt(comparable_or_schema, value)

  def lt(comparable, value) when is_atom(comparable) do
    lt(Vx.Any.t(), comparable, value)
  end

  def lt(schema, %comparable{} = value) do
    lt(schema, comparable, value)
  end

  @doc """
  A constraint that verifies if a comparable value is greater than another value
  using a parent schema and a module implementing the `compare/2` function.

  ## Examples

      iex> Vx.Any.t()
      ...> |> Vx.Comparable.lt(Version, Version.parse!("1.2.3"))
      ...> |> Vx.valid?(Version.parse!("1.2.2"))
      true
  """
  @spec lt(Vx.t(), comparable, any) :: Vx.t()
  def lt(schema, comparable, value) when is_atom(comparable) do
    constrain(schema, LessThan, comparable, value)
  end

  @doc """
  A constraint that verifies if a comparable value is less than or equal to
  another value.

  ## Examples

      iex> Vx.Comparable.lteq(Version.parse!("1.2.3"))
      ...> |> Vx.valid?(Version.parse!("1.2.4"))
      false

      iex> Vx.Comparable.lteq(Version.parse!("1.2.3"))
      ...> |> Vx.valid?(Version.parse!("1.2.3"))
      true

      iex> Vx.Comparable.lteq(Version.parse!("1.2.3"))
      ...>  |> Vx.valid?(Version.parse!("1.2.2"))
      true
  """
  @spec lteq(any) :: Vx.t()
  def lteq(%comparable{} = value) do
    lteq(Vx.Any.t(), comparable, value)
  end

  @doc """
  A constraint that verifies if a comparable value is less than or equal to
  another value using either a parent schema or a module implementing the
  `compare/2` function.

  ## Examples

      iex> Vx.Any.t()
      ...> |> Vx.Comparable.lteq(Version.parse!("1.2.3"))
      ...> |> Vx.valid?(Version.parse!("1.2.2"))
      true

      iex> Version
      ...> |> Vx.Comparable.lteq(Version.parse!("1.2.3"))
      ...> |> Vx.valid?(Version.parse!("1.2.2"))
      true
  """
  @spec lteq(Vx.t() | comparable, any) :: Vx.t()
  def lteq(comparable_or_schema, value)

  def lteq(comparable, value) when is_atom(comparable) do
    lteq(Vx.Any.t(), comparable, value)
  end

  def lteq(schema, %comparable{} = value) do
    lteq(schema, comparable, value)
  end

  @doc """
  A constraint that verifies if a comparable value is less than or equal to
  another value using a parent schema and a module implementing the `compare/2`
  function.

  ## Examples

      iex> Vx.Any.t()
      ...> |> Vx.Comparable.lteq(Version, Version.parse!("1.2.3"))
      ...> |> Vx.valid?(Version.parse!("1.2.2"))
      true
  """
  @spec lteq(Vx.t(), comparable, any) :: Vx.t()
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
