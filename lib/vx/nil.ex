defmodule Vx.Nil do
  @moduledoc """
  The Nil type.
  """

  @doc """
  Provides an alternative notation for `Vx.Literal.t(nil)`
  """
  def t, do: Vx.Literal.t(nil)
end
