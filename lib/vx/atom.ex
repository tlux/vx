defmodule Vx.Atom do
  @moduledoc """
  The Atom type provides validators for atoms.
  """

  use Vx.Type

  @doc """
  Checks whether a value is an atom.
  """
  @spec t() :: t
  def t, do: new(&is_atom/1, %{}, "must be an atom")
end
