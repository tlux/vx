defmodule Vx.Boolean do
  @moduledoc """
  The Boolean type.
  """

  defstruct []

  @doc """
  Builds a new Boolean type.

  ## Examples

      iex> Vx.Boolean.t() |> Vx.validate!(true)
      :ok

      iex> Vx.Boolean.t() |> Vx.validate!(false)
      :ok

      iex> Vx.Boolean.t() |> Vx.validate!("foo")
      ** (Vx.Error) must be a boolean
  """
  @spec t() :: Vx.t()
  def t, do: %__MODULE__{}

  defimpl Vx.Validatable do
    def validate(_, value) when is_boolean(value), do: []

    def validate(schema, value) do
      [Vx.Error.new(schema, value, "is not a boolean")]
    end
  end
end
