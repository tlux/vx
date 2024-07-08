defmodule Vx.Binary do
  @moduledoc """
  The Binary type.
  """

  defstruct []

  @doc """
  Builds a new Binary type.

  ## Examples

      iex> Vx.Binary.t() |> Vx.validate!("foo")
      :ok
  """
  @spec t() :: Vx.t()
  def t, do: %__MODULE__{}

  defimpl Vx.Validatable do
    def validate(_, value) when is_binary(value), do: []

    def validate(schema, value) do
      [Vx.Error.new(schema, value, "is not a binary")]
    end
  end
end
