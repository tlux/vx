defmodule Vx.Map do
  @moduledoc """
  The Map type.
  """

  use Vx.ContextualConstrain

  alias __MODULE__.{Keys, Shape, Size, Values}

  defstruct []

  @doc """
  Builds a new Map type that matches any map.

  ## Examples

      iex> Vx.Map.t() |> Vx.validate!(%{})
      :ok

      iex> Vx.Map.t() |> Vx.validate!(%{a: "foo", b: 123})
      :ok

      iex> Vx.Map.t() |> Vx.validate!("foo")
      ** (Vx.Error) must be a map
  """
  @spec t() :: Vx.t()
  def t, do: %__MODULE__{}

  @doc """
  Builds a new Map type with a specific shape.

  Convenience for `Vx.Map.shape/1` and `Vx.Map.shape/2`.
  """
  @doc since: "1.0.0"
  @spec t(map) :: Vx.t()
  def t(shape) when is_map(shape), do: shape(shape)

  @doc """
  Builds a new Map type with a specific key and value type.

  ## Examples

      iex> Vx.Map.t(Vx.String.t(), Vx.Number.t()) |> Vx.validate!(%{})
      :ok

      iex> schema = Vx.Map.t(Vx.Atom.t(), Vx.Number.t())
      ...> Vx.validate!(schema, %{a: 123, b: 234.5})
      :ok

      iex> Vx.Map.t(Vx.Atom.t(), Vx.Number.t()) |> Vx.validate!("foo")
      ** (Vx.Error) must be a map<atom, number>

      iex> Vx.Map.t(Vx.Atom.t(), Vx.Number.t()) |> Vx.validate!(%{foo: "bar"})
      ** (Vx.Error) must be a map<atom, number>
      - value of element :foo: must be a number
  """
  @spec t(Vx.t(), Vx.t()) :: Vx.t()
  def t(key_schema, value_schema) do
    t()
    |> constrain(%Keys{schema: key_schema})
    |> constrain(%Values{schema: value_schema})
  end

  @doc """
  Checks the shape of the map.

  ## Examples

      iex> schema = Vx.Map.shape(%{a: Vx.String.t(), b: Vx.Number.t()})
      ...> Vx.validate!(schema, %{a: "foo", b: 123})
      :ok

      iex> schema = Vx.Map.shape(%{a: Vx.String.t(), b: Vx.Number.t()})
      ...> Vx.validate!(schema, %{a: "foo"})
      ** (Vx.Error) must have key(s) :b

      iex> schema = Vx.Map.shape(%{a: Vx.String.t(), b: Vx.Number.t()})
      ...> Vx.validate!(schema, %{a: "foo", b: "bar"})
      ** (Vx.Error) does not match shape
      - key :b: must be a number

  It is also possible to mark certain keys as optional.

      iex> schema = Vx.Map.shape(%{
      ...>   :a => Vx.String.t(),
      ...>   Vx.Optional.t(:b) => Vx.Number.t()
      ...> })
      ...> Vx.validate!(schema, %{a: "foo"})
      :ok

      iex> schema = Vx.Map.shape(%{
      ...>   a: Vx.String.t(),
      ...>   b: Vx.Optional.t(Vx.Number.t())
      ...> })
      ...> Vx.validate!(schema, %{a: "foo"})
      :ok

      iex> schema = Vx.Map.shape(%{
      ...>   :a => Vx.String.t(),
      ...>   Vx.Optional.t(:b) => Vx.Number.t()
      ...> })
      ...> Vx.validate!(schema, %{a: "foo", b: "bar"})
      ** (Vx.Error) does not match shape
      - key :b: must be a number
  """
  @spec shape(Vx.t(), map) :: Vx.t()
  def shape(schema \\ t(), shape) when is_map(shape) do
    constrain(schema, %Shape{shape: shape})
  end

  @doc """
  Checks the size of the map.

  ## Examples

      iex> Vx.Map.size(is: 0) |> Vx.validate!(%{})
      :ok

      iex> Vx.Map.size(is: 1) |> Vx.validate!(%{a: "foo", b: 123})
      ** (Vx.Error) must have a size of 1
  """
  @spec size(Vx.t(), Keyword.t()) :: Vx.t()
  def size(schema \\ t(), opts) when is_list(opts) do
    constrain(schema, Size.new(opts))
  end

  defimpl Vx.Validatable do
    def validate(_, value), do: is_map(value)
  end

  defimpl Vx.Humanizable do
    def humanize(_), do: "map"
  end
end
