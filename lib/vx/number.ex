defmodule Vx.Number do
  @moduledoc """
  The Integer type provides validators for integers.
  """

  defstruct []

  use Vx.ConstrainContextual, also_permit: [Vx.Float, Vx.Integer]

  alias __MODULE__.{
    GreaterThan,
    GreaterThanOrEqualTo,
    InRange,
    LessThan,
    LessThanOrEqualTo,
    NonFractional
  }

  @doc """
  Builds a new Number type.

  ## Examples

      iex> Vx.Number.t() |> Vx.validate!(123)
      :ok

      iex> Vx.Number.t() |> Vx.validate!(123.4)
      :ok

      iex> Vx.Number.t() |> Vx.validate!("foo")
      ** (Vx.Error) must be a number
  """
  @spec t() :: Vx.t()
  def t, do: %__MODULE__{}

  @doc """
  Requires the number to have no decimal places.

  ## Examples

      iex> Vx.Number.non_fractional() |> Vx.validate!(123)
      :ok

      iex> Vx.Number.non_fractional() |> Vx.validate!(123.0)
      :ok

      iex> Vx.Number.non_fractional() |> Vx.validate!(123.4)
      ** (Vx.Error) must have no decimal places

      iex> Vx.Number.non_fractional() |> Vx.validate!("foo")
      ** (Vx.Error) must be a number
  """
  @doc since: "1.0.0"
  @spec non_fractional(Vx.t()) :: Vx.t()
  def non_fractional(schema \\ t()) do
    constrain(schema, %NonFractional{})
  end

  @doc """
  Requires the number to be positive.
  """
  @doc since: "0.3.0"
  @spec positive(Vx.t()) :: Vx.t()
  def positive(schema \\ t()), do: gt(schema, 0)

  @doc """
  Requires the number to be negative.
  """
  @doc since: "0.3.0"
  @spec negative(Vx.t()) :: Vx.t()
  def negative(schema \\ t()), do: lt(schema, 0)

  @doc """
  Requires the number to be greater than the given value.
  """
  @spec gt(Vx.t(), number) :: Vx.t()
  def gt(schema \\ t(), value) when is_number(value) do
    constrain(schema, %GreaterThan{value: value})
  end

  @doc """
  Requires the number to be greater than or equal to the given value.
  """
  @spec gteq(Vx.t(), number) :: Vx.t()
  def gteq(schema \\ t(), value) when is_number(value) do
    constrain(schema, %GreaterThanOrEqualTo{value: value})
  end

  @doc """
  Requires the number to be less than the given value.
  """
  @spec lt(Vx.t(), number) :: Vx.t()
  def lt(schema \\ t(), value) when is_number(value) do
    constrain(schema, %LessThan{value: value})
  end

  @doc """
  Requires the number to be less than or equal to the given value.
  """
  @spec lteq(Vx.t(), number) :: Vx.t()
  def lteq(schema \\ t(), value) when is_number(value) do
    constrain(schema, %LessThanOrEqualTo{value: value})
  end

  @doc """
  Requires the number to be within the given range.
  """
  @spec between(Vx.t(), number, number) :: Vx.t()
  def between(schema \\ t(), first, last)

  def between(schema, last, first)
      when is_number(first) and is_number(last) and last > first do
    range(schema, first..last)
  end

  def between(schema, first, last) when is_number(first) and is_number(last) do
    range(schema, first..last)
  end

  @doc """
  Requires the number to be in the given range.

  ## Example

      iex> Vx.Number.range(1..10) |> Vx.validate!(5)
      :ok

      iex> Vx.Number.range(1..10) |> Vx.validate!(11)
      ** (Vx.Error) must be in 1..10
  """
  @spec range(Vx.t(), Range.t()) :: Vx.t()
  def range(schema \\ t(), _.._ = range) do
    constrain(schema, %InRange{range: range})
  end

  defimpl Vx.Validatable do
    def validate(_, value) when is_number(value), do: []

    def validate(schema, value) do
      Vx.Error.new(schema, value, "is not a number")
    end
  end
end
