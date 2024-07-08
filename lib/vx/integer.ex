defmodule Vx.Integer do
  @moduledoc """
  The Integer type.
  """

  defstruct []

  @type t :: %__MODULE__{}

  @doc """
  Builds a new Integer type.

  ## Examples

      iex> Vx.Integer.t() |> Vx.validate!(1)
      :ok

      iex> Vx.Integer.t() |> Vx.validate!(1.0)
      ** (Vx.Error) must be an integer

      iex> Vx.Integer.t() |> Vx.validate!("foo")
      ** (Vx.Error) must be an integer
  """
  @spec t() :: t
  def t, do: %__MODULE__{}

  defimpl Vx.Validatable do
    def validate(_, value) when is_integer(value), do: []

    def validate(schema, value) do
      [Vx.Error.new(schema, value, "is not an integer")]
    end
  end
end
