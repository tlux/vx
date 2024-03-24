defmodule Vx.Any do
  @moduledoc """
  The Any type.
  """

  use Vx.Type, :any

  @spec t() :: t
  def t, do: new(fn _ -> :ok end)
end
