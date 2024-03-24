defmodule Vx.Integer do
  @moduledoc """
  The Integer type.
  """

  use Vx.Type, :integer

  @doc """
  Builds a new Integer type.

  ## Examples

      iex> Vx.Integer.t() |> Vx.validate!(1)
      :ok

      iex> Vx.Integer.t() |> Vx.validate!(1.0)
      ** (Vx.Error) must be an integer

      iex> Vx.Integer.t() |> Vx.validate!("foo")
      ** (Vx.Error) must be an integer
  """
  @spec t() :: t
  def t do
    new(fn
      value when is_integer(value) -> :ok
      _ -> {:error, "must be an integer"}
    end)
  end
end
