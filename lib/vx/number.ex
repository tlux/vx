defmodule Vx.Number do
  @moduledoc """
  The Integer type provides validators for integers.
  """

  defstruct []

  use Vx.ContextualConstrain, also_permit: [Vx.Float, Vx.Integer]

  alias __MODULE__.{
    Between,
    GreaterThan,
    GreaterThanOrEqualTo,
    LessThan,
    LessThanOrEqualTo,
    NonFractional
  }

  @doc """
  Builds a new Number type.

  ## Examples

      iex> Vx.Number.t() |> Vx.valid?(123)
      true

      iex> Vx.Number.t() |> Vx.valid?(123.4)
      true

      iex> Vx.Number.t() |> Vx.valid?("foo")
      false
  """
  @spec t() :: Vx.t()
  def t, do: %__MODULE__{}

  @doc """
  Requires the number to have no decimal places.

  ## Examples

      iex> Vx.Number.non_fractional() |> Vx.valid?(123)
      true

      iex> Vx.Number.non_fractional() |> Vx.valid?(123.0)
      true

      iex> Vx.Number.non_fractional() |> Vx.valid?(123.4)
      false

      iex> Vx.Number.non_fractional() |> Vx.valid?("foo")
      false
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
  Requires the number to be non-negative.
  """
  @doc since: "1.0.0"
  @spec non_negative(Vx.t()) :: Vx.t()
  def non_negative(schema \\ t()), do: gteq(schema, 0)

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

  def between(schema, first, last)
      when is_number(first) and is_number(last) and first > last do
    between(schema, last, first)
  end

  def between(schema, first, last) when is_number(first) and is_number(last) do
    constrain(schema, %Between{first: first, last: last})
  end

  defimpl Vx.Validatable do
    def validate(_, value), do: is_number(value)
  end

  defimpl Vx.Humanizable do
    def humanize(_), do: "number"
  end
end
