defmodule Vx.Atom do
  alias Vx.Schema

  @type t :: Schema.t(:atom)

  @spec t() :: t
  def t, do: Schema.new(:atom, &is_atom/1)
end
