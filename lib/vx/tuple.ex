defmodule Vx.Tuple do
  @moduledoc """
  The Tuple type.
  """

  use Vx.ContextualConstrain

  defstruct []

  alias __MODULE__.{Shape, Size}

  @doc """
  Builds a new Tuple type.

  ## Examples

      iex> Vx.Tuple.t() |> Vx.validate!({:foo, :bar})
      :ok

      iex> Vx.Tuple.t() |> Vx.validate!(123)
      ** (Vx.Error) must be a tuple
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

      iex> Vx.Tuple.t() |> Vx.Tuple.size(is: 2) |> Vx.validate!({:foo, :bar})
      :ok

      iex> Vx.Tuple.t() |> Vx.Tuple.size(is: 2) |> Vx.validate!({:foo})
      ** (Vx.Error) must have a size of 2
  """
  @spec size(Vx.t(), Keyword.t()) :: Vx.t()
  def size(schema \\ t(), opts) when is_list(opts) do
    constrain(schema, Size.new(opts))
  end

  @doc """
  Requires a tuple to match a specific shape.

  ## Examples

      iex> Vx.Tuple.shape({:foo, :bar}) |> Vx.validate!({:foo, :bar})
      :ok

      iex> Vx.Tuple.shape({Vx.Atom.t(), Vx.String.t()}) |> Vx.validate!({:ok, "result"})
      :ok

      iex> Vx.Tuple.shape({Vx.Atom.t(), Vx.String.t()}) |> Vx.validate!({:ok, 123})
      ** (Vx.Error) must match {atom, string}
      - element 1: must be a string
  """
  @spec shape(Vx.t(), tuple) :: Vx.t()
  def shape(schema \\ t(), shape) when is_tuple(shape) do
    constrain(schema, %Shape{shape: shape})
  end

  defimpl Vx.Validatable do
    def validate(_, value), do: is_tuple(value)
  end
end
