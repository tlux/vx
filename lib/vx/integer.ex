defmodule Vx.Integer do
  @moduledoc """
  The Integer type provides validators for integers.
  """

  use Vx.Type

  @doc """
  Checks whether a value is an integer.
  """
  @spec t() :: t
  def t, do: new(&is_integer/1)
end
