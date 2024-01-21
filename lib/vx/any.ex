defmodule Vx.Any do
  @moduledoc """
  The Any type provides validators for any type of value.
  """

  use Vx.Type

  @doc """
  Creates a no-op type.
  """
  @spec t() :: t
  def t, do: init()
end
