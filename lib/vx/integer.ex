defmodule Vx.Integer do
  @moduledoc """
  The Integer type.
  """

  use Vx.ContextualConstrain

  defstruct []

  @type t :: %__MODULE__{}

  @doc """
  Builds a new Integer type.

  ## Examples

      iex> Vx.Integer.t() |> Vx.valid?(1)
      true

      iex> Vx.Integer.t() |> Vx.valid?(1.0)
      false

      iex> Vx.Integer.t() |> Vx.valid?("foo")
      false
  """
  @spec t() :: t
  def t, do: %__MODULE__{}

  @doc """
  Requires the integer to be in the given range.

  ## Example

      iex> Vx.Integer.range(1..10) |> Vx.valid?(5)
      true

      iex> Vx.Integer.range(1..10) |> Vx.valid?(11)
      false
  """
  @spec range(Vx.t(), Range.t()) :: Vx.t()
  def range(schema \\ t(), _.._ = range) do
    constrain(schema, %Vx.Integer.Range{range: range})
  end

  defimpl Vx.Validatable do
    def validate(_, value), do: is_integer(value)
  end

  defimpl Vx.Humanizable do
    def humanize(_), do: "integer"
  end
end
