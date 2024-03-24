defmodule Vx.Struct do
  @moduledoc """
  The Struct type.
  """

  use Vx.Type, :struct

  @doc """
  Builds a new Struct type matching any type of struct.

  ## Examples

      iex> Vx.Struct.t() |> Vx.validate!(%Address{})
      :ok

      iex> Vx.Struct.t() |> Vx.validate!(%{})
      ** (Vx.Error) must be a struct
  """
  @spec t() :: t
  def t do
    new(fn
      %_{} -> :ok
      _ -> {:error, "must be a struct"}
    end)
  end

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
  def t(struct) when is_atom(struct) do
    new([struct], fn
      %^struct{} -> :ok
      _ -> {:error, "must be a struct of type #{inspect(struct)}"}
    end)
  end
end
