defmodule Vx.Float do
  use Vx.Type

  @spec t() :: t
  def t, do: init(&is_float/1)
end
