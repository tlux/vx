defmodule Vx.Float do
  @moduledoc """
  The Float type.
  """

  use Vx.Constrainable

  defstruct []

  @type t :: %__MODULE__{}

  @doc """
  Builds a new Float type.

  ## Examples

      iex> Vx.Float.t() |> Vx.valid?(1.0)
      true

      iex> Vx.Float.t() |> Vx.valid?(1)
      false

      iex> Vx.Float.t() |> Vx.valid?("foo")
      false
  """
  @spec t() :: Vx.t()
  def t, do: %__MODULE__{}

  defimpl Vx.Validatable do
    def validate(_, value) when is_float(value), do: :ok
    def validate(_, _), do: :error
  end

  defimpl Vx.Printable do
    def print(_), do: "float"
  end
end
