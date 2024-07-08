defmodule Vx.Literal do
  @moduledoc """
  The Literal type.
  """

  @enforce_keys [:value]
  defstruct [:value]

  @doc """
  Builds a new Literal type from a value.

  ## Examples

      iex> Vx.Literal.t(:foo) |> Vx.validate!(:foo)
      :ok

      iex> Vx.Literal.t(:foo) |> Vx.validate!(:bar)
      ** (Vx.Error) must be :foo

  Note that everything not being a type (to be precise anything not implementing
  the `Vx.Validatable` protocol) is automatically considered a literal. So this
  is equivalent to the previous example:

      iex> :foo |> Vx.validate!(:foo)
      :ok

      iex> :foo |> Vx.validate!(:bar)
      ** (Vx.Error) must be :foo
  """
  @spec t(any) :: Vx.t()
  def t(value), do: %__MODULE__{value: value}

  defimpl Vx.Validatable do
    def validate(%{value: value}, value), do: []

    def validate(%{value: value} = schema, actual_value) do
      [Vx.Error.new(schema, actual_value, "is not #{inspect(value)}")]
    end
  end
end
