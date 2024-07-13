defmodule Vx.Nullable do
  @moduledoc """
  The Nullable type modifies a type or value to allow `nil` as a valid value.
  """

  @enforce_keys [:schema]
  defstruct [:schema]

  @type t(schema) :: %__MODULE__{schema: schema}
  @type t :: t(Vx.t())

  @doc """
  Builds a new type that makes the passed type nullable.

  ## Examples

      iex> Vx.Nullable.t(Vx.String.t()) |> Vx.validate!("foo")
      :ok

      iex> Vx.Nullable.t(Vx.String.t()) |> Vx.validate!(nil)
      :ok

      iex> Vx.Nullable.t(Vx.String.t()) |> Vx.validate!(123)
      ** (Vx.Error) must be (string | nil)
  """
  @spec t(Vx.t()) :: Vx.t()
  def t(%Vx.Nullable{} = schema), do: schema

  def t(%Vx.Optional{schema: schema}), do: t(schema)

  def t(schema), do: %__MODULE__{schema: schema}

  defimpl Vx.Validatable do
    def validate(_, nil), do: :ok
    def validate(%{schema: schema}, value), do: Vx.validate(schema, value)
  end

  defimpl Vx.Humanizable do
    def humanize(%{schema: schema}) do
      "#{Vx.Humanizable.humanize(schema)}?"
    end
  end
end
