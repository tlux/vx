defmodule Vx.Boolean do
  @moduledoc """
  The Boolean type.
  """

  defstruct []

  @type t :: %__MODULE__{}

  @doc """
  Builds a new Boolean type.

  ## Examples

      iex> Vx.Boolean.t() |> Vx.valid?(true)
      true

      iex> Vx.Boolean.t() |> Vx.valid?(false)
      true

      iex> Vx.Boolean.t() |> Vx.valid?("foo")
      false
  """
  @spec t() :: Vx.t()
  def t, do: %__MODULE__{}

  defimpl Vx.Validatable do
    def validate(_, value), do: is_boolean(value)
  end

  defimpl Vx.Printable do
    def print(_), do: "boolean"
  end
end
