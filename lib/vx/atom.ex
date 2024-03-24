defmodule Vx.Atom do
  @moduledoc """
  The Atom type.
  """

  use Vx.Type, :atom

  @spec t() :: t
  def t do
    new(fn
      value when is_atom(value) -> :ok
      _ -> {:error, "must be an atom"}
    end)
  end
end
