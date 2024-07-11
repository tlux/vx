defmodule Vx.Atom do
  @moduledoc """
  The Atom type.
  """

  defstruct []

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
  @spec custom(Vx.t()) :: Vx.t()
  def custom(schema \\ t()) do
    Vx.Except.t([schema, Vx.Boolean.t(), Vx.Literal.t(nil)])
  end

  defimpl Vx.Validatable do
    def validate(_, value) when is_atom(value), do: []

    def validate(schema, value) do
      [Vx.Error.new(schema, value, "is not an atom")]
    end
  end
end
