defmodule Vx.Any do
  @moduledoc """
  The Any type.
  """

  use Vx.Type, :any

  @doc """
  Builds a new type that matches anything.

  ## Examples

      iex> Vx.Any.t() |> Vx.validate!("foo")
      :ok
  """
  @spec t() :: t
  def t, do: new(fn _ -> :ok end)
end
