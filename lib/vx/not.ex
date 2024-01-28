defmodule Vx.Not do
  @moduledoc """
  The Not type is a special type that allows you to negate a type.
  """

  use Vx.Type

  @spec t(Vx.t()) :: t
  def t(type) do
    new(fn value ->
      match?({:error, _}, Vx.Validatable.validate(type, value))
    end)
  end
end
