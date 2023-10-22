defmodule Vx.Not do
  use Vx.Type

  @spec t(Vx.Validatable.t()) :: t
  def t(inner) do
    init(fn value ->
      match?({:error, _}, Vx.Validatable.validate(inner, value))
    end)
  end
end
