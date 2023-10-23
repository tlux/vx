defmodule Vx.Not do
  use Vx.Type

  @spec t(Vx.t()) :: t
  def t(type) do
    init(fn value ->
      match?({:error, _}, Vx.Validatable.validate(type, value))
    end)
  end
end
