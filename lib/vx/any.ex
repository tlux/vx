defmodule Vx.Any do
  @moduledoc """
  The Any type.
  """

  defstruct []

  @doc """
  Builds a new type that matches anything.

  ## Examples

      iex> Vx.Any.t() |> Vx.validate!("foo")
      :ok
  """
  @spec t() :: Vx.t()
  def t, do: %__MODULE__{}

  defimpl Vx.Validatable do
    def validate(_, _), do: []
  end
end
