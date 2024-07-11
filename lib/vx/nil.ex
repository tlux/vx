defmodule Vx.Nil do
  @doc """
  Provides an alternative notation for `Vx.Literal.t(nil)`
  """
  def t, do: Vx.Literal.t(nil)
end
