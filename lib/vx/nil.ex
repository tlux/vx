defmodule Vx.Nil do
  @moduledoc """
  The Nil type.
  """

  @doc """
  Provides an alternative notation for `Vx.Literal.t(nil)`

  ## Example

      iex> Vx.Nil.t() |> Vx.valid?(nil)
      true

      iex> Vx.Nil.t() |> Vx.valid?("foo")
      false
  """
  def t, do: Vx.Literal.t(nil)
end
