defmodule Vx.Any do
  @moduledoc """
  The Any type.
  """

  defstruct []

  @type t :: %__MODULE__{}

  @doc """
  Builds a new type that matches anything.

  ## Examples

      iex> Vx.Any.t() |> Vx.valid?("foo")
      true
  """
  @spec t() :: Vx.t()
  def t, do: %__MODULE__{}

  defimpl Vx.Validatable do
    def validate(_, _), do: true
  end

  defimpl Vx.Printable do
    def print(_), do: "any"
  end
end
