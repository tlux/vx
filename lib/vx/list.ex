defmodule Vx.List do
  @moduledoc """
  The List type.
  """

  use Vx.ContextualConstrain

  alias __MODULE__.{
    Length,
    Shape,
    Values
  }

  defstruct []

  @doc """
  Builds a new List type.

  ## Examples

      iex> Vx.List.t() |> Vx.valid?([1, 2, 3])
      true

      iex> Vx.List.t() |> Vx.valid?("foo")
      false
  """
  @spec t() :: Vx.t()
  def t, do: %__MODULE__{}

  @doc """
  Builds a new List type with the given inner type.

  ## Examples

      iex> Vx.List.t(Vx.Number.t()) |> Vx.valid?([1, 2, 3])
      true

      iex> Vx.List.t(Vx.String.t()) |> Vx.valid?("foo")
      false

      iex> Vx.List.t(Vx.String.t()) |> Vx.valid?(["foo", 2, "bar"])
      false

  """
  @spec t(Vx.t()) :: Vx.t()
  def t(schema) do
    constrain(t(), %Values{schema: schema})
  end

  @doc """
  Requires the list to have a specific size.
  """
  @spec length(Vx.t(), Keyword.t()) :: Vx.t()
  def length(schema \\ t(), opts) when is_list(opts) do
    constrain(schema, Length.new(opts))
  end

  @doc """
  Requires the list to be non-empty.

  ## Examples

      iex> Vx.List.non_empty() |> Vx.valid?([1, 2, 3])
      true

      iex> Vx.List.non_empty() |> Vx.valid?([])
      false
  """
  @spec non_empty(Vx.t()) :: Vx.t()
  def non_empty(schema \\ t()), do: length(schema, min: 1)

  @doc """
  Requires the list to match the given shape.

  ## Examples

      iex> Vx.List.shape([Vx.Number.t(), Vx.String.t()]) |> Vx.valid?([123, "foo"])
      true

      iex> Vx.List.shape([Vx.Number.t(), Vx.String.t()]) |> Vx.valid?([123])
      false

      iex> Vx.List.shape([Vx.Number.t(), Vx.String.t()]) |> Vx.valid?([123, :foo])
      false
  """
  @spec shape(Vx.t(), [Vx.t()]) :: Vx.t()
  def shape(schema \\ t(), shape) when is_list(shape) do
    constrain(schema, %Shape{shape: shape})
  end

  defimpl Vx.Validatable do
    def validate(_, values), do: is_list(values)
  end

  defimpl Vx.Humanizable do
    def humanize(_), do: "list"
  end
end
