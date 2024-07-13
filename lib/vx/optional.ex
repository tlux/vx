defmodule Vx.Optional do
  @moduledoc """
  The Optional type provides validators for optional keys in a map. When used in
  other places, it behaves like `Vx.Nullable`.
  """

  @enforce_keys [:schema]
  defstruct [:schema]

  @type t(schema) :: %__MODULE__{schema: schema}
  @type t :: t(Vx.t())

  @doc """
  Builds a new type that makes the passed type optional.

  ## Examples

      iex> Vx.Optional.t(Vx.String.t()) |> Vx.validate!("foo")
      :ok

      iex> Vx.Optional.t(Vx.String.t()) |> Vx.validate!(nil)
      :ok

      iex> Vx.Optional.t(Vx.String.t()) |> Vx.validate!(123)
      ** (Vx.Error) must be string?

  In most cases the behavior is the same as using `Vx.Nullable.t/1`.

  Besides that, you can use `Vx.Optional.t/1` to mark map keys as optional.

      iex> schema = Vx.Map.shape(%{
      ...>   :a => Vx.String.t(),
      ...>   Vx.Optional.t(:b) => Vx.Number.t()
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
  @spec t(Vx.t()) :: Vx.t()
  def t(%Vx.Optional{} = schema), do: schema

  def t(%Vx.Nullable{schema: schema}), do: t(schema)

  def t(schema), do: %__MODULE__{schema: schema}

  defimpl Vx.Validatable do
    def validate(_, nil), do: :ok
    def validate(%{schema: schema}, value), do: Vx.validate(schema, value)
  end

  defimpl Vx.Humanizable do
    def humanize(%{schema: schema}) do
      "#{Vx.Humanizable.humanize(schema)}*"
    end
  end
end
