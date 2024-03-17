defmodule Vx.Boolean do
  @moduledoc """
  The Boolean type provides validators for booleans.
  """

  use Vx.Type

  @doc """
  Checks whether a value is a boolean.
  """
  @spec t() :: t
  def t, do: new(&is_boolean/1, %{}, "must be a boolean")
end
