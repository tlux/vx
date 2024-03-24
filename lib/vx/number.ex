defmodule Vx.Number do
  @moduledoc """
  The Integer type provides validators for integers.
  """

  use Vx.Type, :number

  @type numeric :: t | Vx.Float.t() | Vx.Integer.t()

  @spec t() :: t
  def t do
    new(fn
      value when is_number(value) -> :ok
      _ -> {:error, "must be a number"}
    end)
  end

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

  @spec gt(type, number) :: type when type: numeric
  def gt(type \\ t(), value) do
    constrain_num(type, :gt, value, fn actual_value ->
      if actual_value > value do
        :ok
      else
        {:error, "must be greater than #{value}"}
      end
    end)
  end

  @spec gteq(type, number) :: type when type: numeric
  def gteq(type \\ t(), value) do
    constrain_num(type, :gteq, value, fn actual_value ->
      if actual_value >= value do
        :ok
      else
        {:error, "must be greater than or equal to #{value}"}
      end
    end)
  end

  @spec lt(type, number) :: type when type: numeric
  def lt(type \\ t(), value) do
    constrain_num(type, :lt, value, fn actual_value ->
      if actual_value < value do
        :ok
      else
        {:error, "must be less than #{value}"}
      end
    end)
  end

  @spec lteq(type, number) :: type when type: numeric
  def lteq(type \\ t(), value) do
    constrain_num(type, :lteq, value, fn actual_value ->
      if actual_value <= value do
        :ok
      else
        {:error, "must be less than or equal to #{value}"}
      end
    end)
  end

  @spec between(type, number, number) :: type when type: numeric
  def between(type \\ t(), first, last)

  def between(type, last, first) when last > first do
    range(type, first..last)
  end

  def between(type, first, last) do
    range(type, first..last)
  end

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
