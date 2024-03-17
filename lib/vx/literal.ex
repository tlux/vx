defmodule Vx.Literal do
  @moduledoc """
  The Literal type provides validators for literals.
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
