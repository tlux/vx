defmodule Vx.Tuple do
  @moduledoc """
  The Tuple type.
  """

  use Vx.ContextualConstrain

  alias __MODULE__.{Shape, Size}

  defstruct []

  @doc """
  Builds a new Tuple type.

  ## Examples

      iex> Vx.Tuple.t() |> Vx.valid?({:foo, :bar})
      true

      iex> Vx.Tuple.t() |> Vx.valid?(123)
      false
  """
  @spec t() :: Vx.t()
  def t, do: %__MODULE__{}

  @doc """
  Builds a new Tuple type with a specific shape.

  Convenience for `Vx.Tuple.shape/1` and `Vx.Tuple.shape/2`.
  """
  @doc since: "1.0.0"
  @spec t(tuple) :: Vx.t()
  def t(tuple) when is_tuple(tuple), do: shape(tuple)

  @doc """
  Requires a tuple to have a specific size.

  ## Examples

      iex> Vx.Tuple.t() |> Vx.Tuple.size(is: 2) |> Vx.valid?({:foo, :bar})
      true

      iex> Vx.Tuple.t() |> Vx.Tuple.size(is: 2) |> Vx.valid?({:foo})
      false
  """
  @spec size(Vx.t(), Keyword.t()) :: Vx.t()
  def size(schema \\ t(), opts) when is_list(opts) do
    constrain(schema, Size.new(opts))
  end

  @doc """
  Requires a tuple to match a specific shape.

  ## Examples

      iex> Vx.Tuple.shape({:foo, :bar}) |> Vx.valid?({:foo, :bar})
      true

      iex> Vx.Tuple.shape({Vx.Atom.t(), Vx.String.t()}) |> Vx.valid?({:ok, "result"})
      true

      iex> Vx.Tuple.shape({Vx.Atom.t(), Vx.String.t()}) |> Vx.valid?({:ok, 123})
      false
  """
  @spec shape(Vx.t(), tuple) :: Vx.t()
  def shape(schema \\ t(), shape) when is_tuple(shape) do
    constrain(schema, %Shape{shape: shape})
  end

  defimpl Vx.Validatable do
    def validate(_, value), do: is_tuple(value)
  end

  defimpl Vx.Humanizable do
    def humanize(_), do: "tuple"
  end
end
