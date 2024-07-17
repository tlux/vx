defmodule Vx.Struct do
  @moduledoc """
  The Struct type.
  """

  defstruct [:mod]

  @type t :: %__MODULE__{mod: module | nil}

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
  def t(mod) when is_atom(mod), do: %__MODULE__{mod: mod}

  defimpl Vx.Validatable do
    def validate(%{mod: nil}, %_{}), do: true
    def validate(%{mod: mod}, %mod{}), do: true
    def validate(_, _), do: false
  end

  defimpl Vx.Printable do
    def print(%{mod: nil}), do: "struct"
    def print(%{mod: mod}), do: inspect(mod)
  end
end
