defmodule Vx.Struct do
  @moduledoc """
  The Struct type.
  """

  use Vx.ContextualConstrain

  alias Vx.Struct.Type

  defstruct []

  @doc """
  Builds a new Struct type matching any type of struct.

  ## Examples

      iex> Vx.Struct.t() |> Vx.valid?(%Address{})
      true

      iex> Vx.Struct.t() |> Vx.valid?(%{})
      false
  """
  @spec t() :: Vx.t()
  def t, do: %__MODULE__{}

  @doc """
  Builds a new Struct type matching a specific type of struct.

  ## Examples

      iex> Vx.Struct.t(Address) |> Vx.valid?(%Address{})
      true

      iex> Vx.Struct.t(Address) |> Vx.valid?(%{})
      false

      iex> Vx.Struct.t(Address) |> Vx.valid?(%Country{})
      false
  """
  @spec t(module) :: Vx.t()
  def t(mod) when is_atom(mod) do
    constrain(t(), %Type{mod: mod})
  end

  defimpl Vx.Validatable do
    def validate(_, %_{}), do: true
    def validate(_, _), do: false
  end
end
