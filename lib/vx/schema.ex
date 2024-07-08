defmodule Vx.Schema do
  @moduledoc """
  Module that provides reflection functions for `Vx` schemata.
  """

  @doc """
  Gets a list of all constraints added to the passed schema.
  """
  @doc since: "1.0.0"
  @spec constraints(Vx.t()) :: [Vx.t()]
  def constraints(schema)

  def constraints(%Vx.Constrained{constraints: constraints}) do
    Enum.to_list(constraints)
  end

  def constraints(_), do: []
end
