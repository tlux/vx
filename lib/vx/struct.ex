defmodule Vx.Struct do
  @moduledoc """
  The Struct type.
  """

  defstruct [:of]

  @doc """
  Builds a new Struct type matching any type of struct.

  ## Examples

      iex> Vx.Struct.t() |> Vx.validate!(%Address{})
      :ok

      iex> Vx.Struct.t() |> Vx.validate!(%{})
      ** (Vx.Error) must be a struct
  """
  @spec t() :: Vx.t()
  def t, do: %__MODULE__{}

  @doc """
  Builds a new Struct type matching a specific type of struct.

  ## Examples

      iex> Vx.Struct.t(Address) |> Vx.validate!(%Address{})
      :ok

      iex> Vx.Struct.t(Address) |> Vx.validate!(%{})
      ** (Vx.Error) must be a struct of type Address

      iex> Vx.Struct.t(Address) |> Vx.validate!(%Country{})
      ** (Vx.Error) must be a struct of type Address
  """
  @spec t(module) :: Vx.t()
  def t(mod) when is_atom(mod), do: %__MODULE__{of: mod}

  defimpl Vx.Validatable do
    def validate(%{of: %mod{}}, mod), do: []

    def validate(%{of: of} = schema, value) do
      [
        Vx.Error.new(schema, value, "must be a struct of type #{inspect(of)}")
      ]
    end
  end
end
