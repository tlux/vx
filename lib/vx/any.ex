defmodule Vx.Any do
  @moduledoc """
  The Any type provides validators for any type of value.
  """

  use Vx.Type

  @doc """
  A no-op validator.
  """
  @spec t() :: t
  def t, do: init()
end
