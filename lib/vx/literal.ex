defmodule Vx.Literal do
  @moduledoc """
  The List type provides a validator for literals.
  """

  use Vx.Type

  @doc """
  Creates a no-op type.
  """
  @spec t(any) :: t
  def t(value) do
    init(&(&1 == value), %{value: value})
  end
end
