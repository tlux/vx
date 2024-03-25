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
      ** (Vx.Error) must be an integer

      iex> Vx.Number.integer() |> Vx.validate!("foo")
      ** (Vx.Error) must be a number

  """
  @spec integer(type) :: type when type: numeric
  def integer(type \\ t())

  def integer(%Vx.Integer{} = type), do: type

  def integer(type) do
    constrain_num(type, :integer, fn
      value when is_integer(value) ->
        :ok

      value when is_float(value) ->
        if value == trunc(value) do
          :ok
        else
          {:error, "must be an integer"}
        end
    end)
  end

  @doc """
  Requires the number to be positive.
  """
  @spec positive(type) :: type when type: numeric
  def positive(type \\ t()) do
    constrain_num(type, :positive, fn value ->
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
  @spec negative(type) :: type when type: numeric
  def negative(type \\ t()) do
    constrain_num(type, :negative, fn value ->
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
  @spec gt(type, number) :: type when type: numeric
  def gt(type \\ t(), value) when is_number(value) do
    constrain_num(type, :gt, value, fn actual_value ->
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
  @spec gteq(type, number) :: type when type: numeric
  def gteq(type \\ t(), value) when is_number(value) do
    constrain_num(type, :gteq, value, fn actual_value ->
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
  @spec lt(type, number) :: type when type: numeric
  def lt(type \\ t(), value) when is_number(value) do
    constrain_num(type, :lt, value, fn actual_value ->
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
  @spec lteq(type, number) :: type when type: numeric
  def lteq(type \\ t(), value) when is_number(value) do
    constrain_num(type, :lteq, value, fn actual_value ->
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
  @spec between(type, number, number) :: type when type: numeric
  def between(type \\ t(), first, last)

  def between(type, last, first)
      when is_number(first) and is_number(last) and last > first do
    range(type, first..last)
  end

  def between(type, first, last) when is_number(first) and is_number(last) do
    range(type, first..last)
  end

  @doc """
  Requires the number to be in the given range.

  ## Example

      iex> Vx.Number.range(1..10) |> Vx.validate!(5)
      :ok

      iex> Vx.Number.range(1..10) |> Vx.validate!(11)
      ** (Vx.Error) must be in 1..10
  """
  @spec range(type, Range.t()) :: type when type: numeric
  def range(type \\ t(), _.._ = range) do
    constrain_num(type, :range, range, fn actual_value ->
      if actual_value in range do
        :ok
      else
        {:error, "must be in #{inspect(range)}"}
      end
    end)
  end

  defp constrain_num(%struct{} = type, name, value \\ nil, fun)
       when struct in [__MODULE__, Vx.Float, Vx.Integer] do
    Vx.Type.constrain(type, name, value, fun)
  end
end
