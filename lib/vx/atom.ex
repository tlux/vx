defmodule Vx.Atom do
  @moduledoc """
  The Atom type.
  """

  use Vx.Constrainable

  defstruct []

  @type t :: %__MODULE__{}

  @doc """
  Builds a new Atom type.

  ## Examples

      iex> Vx.Atom.t() |> Vx.valid?(:foo)
      true

      iex> Vx.Atom.t() |> Vx.valid?("foo")
      false

  As `nil`, booleans and module names are also atoms, all of these are totally
  valid as well:

      iex> Vx.Atom.t() |> Vx.valid?(nil)
      true

      iex> Vx.Atom.t() |> Vx.valid?(true)
      true

      iex> Vx.Atom.t() |> Vx.valid?(Address)
      true
  """
  @spec t() :: Vx.t()
  def t, do: %__MODULE__{}

  @doc """
  Builds a new Atom type that matches any user-defined atom.
  """
  @spec custom() :: Vx.t()
  def custom do
    Vx.Except.t([Vx.Atom.t(), Vx.Boolean.t(), nil])
  end

  defimpl Vx.Validatable do
    def validate(_, value), do: is_atom(value)
  end

  defimpl Vx.Printable do
    def print(_), do: "atom"
  end
end
