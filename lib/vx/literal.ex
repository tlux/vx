defmodule Vx.Literal do
  @moduledoc """
  The Literal type.
  """

  @enforce_keys [:value]
  defstruct [:value]

  @doc """
  Builds a new Literal type from a value.

  ## Examples

      iex> Vx.Literal.t(:foo) |> Vx.valid?(:foo)
      true

      iex> Vx.Literal.t(:foo) |> Vx.valid?(:bar)
      false

  Note that everything not being a type (to be precise anything not implementing
  the `Vx.Validatable` protocol explicitly) is automatically considered a
  literal. So the following code is equivalent to the previous example:

      iex> :foo |> Vx.valid?(:foo)
      true

      iex> :foo |> Vx.valid?(:bar)
      false
  """
  @spec t(any) :: Vx.t()
  def t(value), do: %__MODULE__{value: value}

  defimpl Vx.Validatable do
    def validate(%{value: value}, value), do: true
    def validate(_, _), do: false
  end

  defimpl Vx.Humanizable do
    def humanize(%{value: value}), do: inspect(value)
  end
end
