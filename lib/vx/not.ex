defmodule Vx.Not do
  @moduledoc """
  The Not type negates the given type or value.
  """

  @enforce_keys [:schema]
  defstruct [:schema]

  @type t :: %__MODULE__{schema: Vx.t()}

  @doc """
  Builds a new type negating the passed one.

  ## Examples

      iex> Vx.Not.t(Vx.Integer.t()) |> Vx.valid?("foo")
      true

      iex> Vx.Not.t(Vx.Integer.t()) |> Vx.valid?(123)
      false
  """
  @spec t(Vx.t()) :: Vx.t()
  def t(schema), do: %__MODULE__{schema: schema}

  defimpl Vx.Validatable do
    def validate(%{schema: schema}, value), do: !Vx.valid?(schema, value)
  end

  defimpl Vx.Printable do
    def print(%{schema: schema}) do
      "not(#{Vx.Printable.print(schema)})"
    end
  end
end
