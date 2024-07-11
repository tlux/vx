defmodule Vx.Boolean do
  @moduledoc """
  The Boolean type.
  """

  defstruct []

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
    def validate(_, value) when is_boolean(value), do: []

    def validate(schema, value) do
      [Vx.Error.new(schema, value, "is not a boolean")]
    end
  end
end
