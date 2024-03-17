defmodule Vx.Literal do
  @moduledoc """
  The List type provides a validator for literals.
  """

  use Vx.Type

  @doc """
  Creates a literal type.
  """
  @spec t(any) :: t
  def t(value) do
    new(&(&1 == value), %{value: value}, "must be #{inspect(value)}")
  end
end
