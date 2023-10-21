defmodule Vx.Atom do
  use Vx.Type

  @spec t() :: t
  def t, do: init(&is_atom/1)
end
