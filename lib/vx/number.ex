defmodule Vx.Number do
  @moduledoc """
  The Integer type provides validators for integers.
  """

  use Vx.Type, :number

  @type numeric :: t | Vx.Float.t() | Vx.Integer.t()

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
  @spec t() :: t
  def t do
    new(fn
      value when is_number(value) -> :ok
      _ -> {:error, "must be a number"}
    end)
  end

  @doc """
  Requires the number to have no decimal places.

  ## Examples

      iex> Vx.Number.integer() |> Vx.validate!(123)
      :ok

      iex> Vx.Number.integer() |> Vx.validate!(123.0)
      :ok

      iex> Vx.Number.integer() |> Vx.validate!(123.4)
      ** (Vx.Error) must have no decimal places

      iex> Vx.Number.integer() |> Vx.validate!("foo")
      ** (Vx.Error) must be a number
  """
  @spec integer(schema) :: schema when schema: numeric
  def integer(schema \\ t())

  def integer(%Vx.Integer{} = schema), do: schema

  def integer(schema) do
    constrain_num(schema, :integer, fn
      value when is_integer(value) ->
        :ok

      value when is_float(value) ->
        if value == trunc(value) do
          :ok
        else
          {:error, "must have no decimal places"}
        end
    end)
  end

  @doc """
  Requires the number to be positive.
  """
  @doc since: "0.3.0"
  @spec positive(schema) :: schema when schema: numeric
  def positive(schema \\ t()) do
    constrain_num(schema, :positive, fn value ->
      if value > 0 do
        :ok
      else
        {:error, "must be positive"}
      end
    end)
  end

  @doc """
  Requires the number to be negative.
  """
  @doc since: "0.3.0"
  @spec negative(schema) :: schema when schema: numeric
  def negative(schema \\ t()) do
    constrain_num(schema, :negative, fn value ->
      if value < 0 do
        :ok
      else
        {:error, "must be negative"}
      end
    end)
  end

  @doc """
  Requires the number to be greater than the given value.
  """
  @spec gt(schema, number) :: schema when schema: numeric
  def gt(schema \\ t(), value) when is_number(value) do
    constrain_num(schema, :gt, value, fn actual_value ->
      if actual_value > value do
        :ok
      else
        {:error, "must be greater than #{value}"}
      end
    end)
  end

  @doc """
  Requires the number to be greater than or equal to the given value.
  """
  @spec gteq(schema, number) :: schema when schema: numeric
  def gteq(schema \\ t(), value) when is_number(value) do
    constrain_num(schema, :gteq, value, fn actual_value ->
      if actual_value >= value do
        :ok
      else
        {:error, "must be greater than or equal to #{value}"}
      end
    end)
  end

  @doc """
  Requires the number to be less than the given value.
  """
  @spec lt(schema, number) :: schema when schema: numeric
  def lt(schema \\ t(), value) when is_number(value) do
    constrain_num(schema, :lt, value, fn actual_value ->
      if actual_value < value do
        :ok
      else
        {:error, "must be less than #{value}"}
      end
    end)
  end

  @doc """
  Requires the number to be less than or equal to the given value.
  """
  @spec lteq(schema, number) :: schema when schema: numeric
  def lteq(schema \\ t(), value) when is_number(value) do
    constrain_num(schema, :lteq, value, fn actual_value ->
      if actual_value <= value do
        :ok
      else
        {:error, "must be less than or equal to #{value}"}
      end
    end)
  end

  @doc """
  Requires the number to be within the given range.
  """
  @spec between(schema, number, number) :: schema when schema: numeric
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
  @spec range(schema, Range.t()) :: schema when schema: numeric
  def range(schema \\ t(), _.._ = range) do
    constrain_num(schema, :range, range, fn actual_value ->
      if actual_value in range do
        :ok
      else
        {:error, "must be in #{inspect(range)}"}
      end
    end)
  end

  defp constrain_num(%struct{} = schema, name, value \\ nil, fun)
       when struct in [__MODULE__, Vx.Float, Vx.Integer] do
    Vx.Type.constrain(schema, name, value, fun)
  end
end
