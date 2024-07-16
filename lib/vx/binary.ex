defmodule Vx.Binary do
  @moduledoc """
  The Binary type.
  """
  @moduledoc since: "1.0.0"

  defstruct []

  @doc """
  Builds a new Binary type.

  ## Examples

      iex> Vx.Binary.t() |> Vx.valid?("foo")
      true

      iex> Vx.Binary.t() |> Vx.valid?(<<0, 1, 2>>)
      true

      iex> Vx.Binary.t() |> Vx.valid?(123)
      false
  """
  @spec t() :: Vx.t()
  def t, do: %__MODULE__{}

  defimpl Vx.Validatable do
    def validate(_, value), do: is_binary(value)
  end

  defimpl Vx.Humanizable do
    def humanize(_), do: "binary"
  end
end
