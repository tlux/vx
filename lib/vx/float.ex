defmodule Vx.Float do
  @moduledoc """
  The Float type provides validators for floats.
  """

  use Vx.Type

  @doc """
  Checks whether a value is a float.
  """
  @spec t() :: t
  def t, do: new(&is_float/1)
end
