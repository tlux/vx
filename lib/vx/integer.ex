defmodule Vx.Integer do
  use Vx.Type

  @spec t() :: t
  def t, do: init(&is_integer/1)
end
