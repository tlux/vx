defmodule Vx.Integer do
  alias Vx.Schema

  @type t :: Schema.t(:integer)

  @spec t() :: t
  def t, do: Schema.new(:integer, &is_integer/1)
end
