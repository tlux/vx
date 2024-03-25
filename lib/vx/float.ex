defmodule Vx.Float do
  @moduledoc """
  The Float type.
  """

  use Vx.Type, :float

  @doc """
  Builds a new Float type.

  ## Examples

      iex> Vx.Float.t() |> Vx.validate!(1.0)
      :ok

      iex> Vx.Float.t() |> Vx.validate!(1)
      ** (Vx.Error) must be a float

      iex> Vx.Float.t() |> Vx.validate!("foo")
      ** (Vx.Error) must be a float
  """
  @spec t() :: t
  def t do
    new(fn
      value when is_float(value) -> :ok
      _ -> {:error, "must be a float"}
    end)
  end

  @doc """
  Requires the float to have no decimal places.

  ## Examples
      iex> Vx.Float.integer() |> Vx.validate!(123.0)
      :ok

      iex> Vx.Float.integer() |> Vx.validate!(123.4)
      ** (Vx.Error) must have no decimal places

      iex> Vx.Float.integer() |> Vx.validate!("foo")
      ** (Vx.Error) must be a float
  """
  @spec integer(t) :: t
  def integer(%__MODULE__{} = type \\ t()) do
    Vx.Number.integer(type)
  end
end
