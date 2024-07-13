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

      iex> Vx.Optional.t(Vx.String.t()) |> Vx.valid?("foo")
      true

      iex> Vx.Optional.t(Vx.String.t()) |> Vx.valid?(nil)
      true

      iex> Vx.Optional.t(Vx.String.t()) |> Vx.valid?(123)
      false

  In most cases the behavior is the same as using `Vx.Nullable.t/1`.

  Besides that, you can use `Vx.Optional.t/1` to mark map keys as optional.

      iex> schema = Vx.Map.shape(%{
      ...>   :a => Vx.String.t(),
      ...>   Vx.Optional.t(:b) => Vx.Number.t()
      ...> })
      ...> Vx.valid?(schema, %{a: "foo"})
      true

      iex> schema = Vx.Map.shape(%{
      ...>   :a => Vx.String.t(),
      ...>   Vx.Optional.t(:b) => Vx.Number.t()
      ...> })
      ...> Vx.valid?(schema, %{a: "foo", b: "bar"})
      false
  """
  @spec t(Vx.t()) :: Vx.t()
  def t(%Vx.Literal{value: nil} = schema), do: schema

  def t(%Vx.Optional{} = schema), do: schema

  def t(%Vx.Nullable{schema: schema}), do: t(schema)

  def t(schema), do: %__MODULE__{schema: schema}

  defimpl Vx.Validatable do
    def validate(_, nil), do: :ok

    def validate(%{schema: schema} = optional, value) do
      case Vx.validate(schema, value) do
        :ok ->
          :ok

        {:error, errors} ->
          {:error, Enum.map(errors, &Vx.Error.put_schema(&1, optional))}
      end
    end
  end

  defimpl Vx.Humanizable do
    def humanize(%{schema: schema}) do
      "#{Vx.Humanizable.humanize(schema)}??"
    end
  end
end
