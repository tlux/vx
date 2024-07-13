defmodule Vx.Not do
  @moduledoc """
  The Not type negates the given type or value.
  """

  @enforce_keys [:schema]
  defstruct [:schema]

  @doc """
  Builds a new type negating the passed one.

  ## Examples

      iex> Vx.Not.t(Vx.Integer.t()) |> Vx.validate!("foo")
      :ok

      iex> Vx.Not.t(Vx.Integer.t()) |> Vx.validate!(123)
      ** (Vx.Error) must not be integer
  """
  @spec t(Vx.t()) :: Vx.t()
  def t(schema), do: %__MODULE__{schema: schema}

  defimpl Vx.Validatable do
    def validate(%{schema: schema}, value), do: !Vx.valid?(schema, value)
  end

  defimpl Vx.Humanizable do
    def humanize(%{schema: schema}) do
      "not (#{Vx.Humanizable.humanize(schema)})"
    end
  end
end
