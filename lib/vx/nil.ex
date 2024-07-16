defmodule Vx.Nil do
  @moduledoc """
  The Nil type.
  """
  @moduledoc since: "1.0.0"

  @doc """
  Provides an alternative notation for `Vx.Literal.t(nil)`

  ## Example

      iex> Vx.Nil.t() |> Vx.valid?(nil)
      true

      iex> Vx.Nil.t() |> Vx.valid?("foo")
      false
  """
  @spec t() :: Vx.t()
  def t, do: Vx.Literal.t(nil)
end
