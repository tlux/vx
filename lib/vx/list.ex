defmodule Vx.List do
  @moduledoc """
  The List type.
  """

  use Vx.ConstrainContextual

  alias __MODULE__.{
    Length,
    Shape,
    ValueSchema
  }

  defstruct []

  @doc """
  Builds a new List type.

  ## Examples

      iex> Vx.List.t() |> Vx.validate!([1, 2, 3])
      :ok

      iex> Vx.List.t() |> Vx.validate!("foo")
      ** (Vx.Error) must be a list
  """
  @spec t() :: Vx.t()
  def t, do: %__MODULE__{}

  @doc """
  Builds a new List type with the given inner type.

  ## Examples

      iex> Vx.List.t(Vx.Number.t()) |> Vx.validate!([1, 2, 3])
      :ok

      iex> Vx.List.t(Vx.String.t()) |> Vx.validate!("foo")
      ** (Vx.Error) must be a list

      iex> Vx.List.t(Vx.String.t()) |> Vx.validate!(["foo", 2, "bar"])
      ** (Vx.Error) must be a list<string>
      - element 1: must be a string

  """
  @spec t(Vx.t()) :: Vx.t()
  def t(schema) do
    constrain(t(), %ValueSchema{schema: schema})
  end

  @doc """
  Requires the list to have a specific size.
  """
  @spec length(Vx.t(), Keyword.t()) :: Vx.t()
  def length(schema \\ t(), opts) do
    constrain(schema, Length.new(opts))
  end

  @doc """
  Requires the list to be non-empty.

  ## Examples

      iex> Vx.List.non_empty() |> Vx.validate!([1, 2, 3])
      :ok

      iex> Vx.List.non_empty() |> Vx.validate!([])
      ** (Vx.Error) must not be empty
  """
  @spec non_empty(Vx.t()) :: Vx.t()
  def non_empty(schema \\ t()), do: length(schema, min: 1)

  @doc """
  Requires the list to match the given shape.

  ## Examples

      iex> Vx.List.shape([Vx.Number.t(), Vx.String.t()]) |> Vx.validate!([123, "foo"])
      :ok

      iex> Vx.List.shape([Vx.Number.t(), Vx.String.t()]) |> Vx.validate!([123])
      ** (Vx.Error) must match [number, string]
      - element 1 is missing

      iex> Vx.List.shape([Vx.Number.t(), Vx.String.t()]) |> Vx.validate!([123, :foo])
      ** (Vx.Error) must match [number, string]
      - element 1: must be a string
  """
  @spec shape(Vx.t(), [Vx.t()]) :: Vx.t()
  def shape(schema \\ t(), shape) when is_list(shape) do
    constrain(schema, %Shape{shape: shape})
  end

  defimpl Vx.Validatable do
    def validate(_, values) when is_list(values), do: []

    def validate(schema, value) do
      [Vx.Error.new(schema, value, "is not a list")]
    end
  end
end
