defmodule Vx.Float do
  @moduledoc """
  The Float type.
  """

  use Vx.ConstrainContextual

  defstruct []

  @doc """
  Builds a new Float type.

  ## Examples

      iex> Vx.Float.t() |> Vx.validate!(1.0)
      :ok

      iex> Vx.Float.t() |> Vx.validate!(1)
      ** (Vx.Error) must be a float

      iex> Vx.Float.t() |> Vx.validate!("foo")
      ** (Vx.Error) must be a float
  """
  @spec t() :: Vx.t()
  def t, do: %__MODULE__{}

  defimpl Vx.Validatable do
    def validate(_, value) when is_float(value), do: []

    def validate(schema, value) do
      [Vx.Error.new(schema, value, "is not a float")]
    end
  end
end
