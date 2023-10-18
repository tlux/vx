defmodule Vx.Float do
  alias Vx.Schema

  @type t :: Schema.t(:float)

  @spec t() :: t
  def t, do: Schema.new(:float, &is_float/1)
end
