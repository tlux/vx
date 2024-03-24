defmodule Vx.Atom do
  @moduledoc """
  The Atom type.
  """

  use Vx.Type, :atom

  @doc """
  Builds a new Atom type.

  ## Examples

      iex> Vx.Atom.t() |> Vx.validate!(:foo)
      :ok

      iex> Vx.Atom.t() |> Vx.validate!("foo")
      ** (Vx.Error) must be an atom

  As `nil`, booleans and module names are also atoms, all of these are totally
  valid as well:

      iex> Vx.Atom.t() |> Vx.validate!(nil)
      :ok

      iex> Vx.Atom.t() |> Vx.validate!(true)
      :ok

      iex> Vx.Atom.t() |> Vx.validate!(Address)
      :ok
  """
  @spec t() :: t
  def t do
    new(fn
      value when is_atom(value) -> :ok
      _ -> {:error, "must be an atom"}
    end)
  end
end
