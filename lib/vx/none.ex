defmodule Vx.None do
  @moduledoc """
  The None type.
  """
  @moduledoc since: "1.0.0"

  defstruct []

  @type t :: %__MODULE__{}

  @doc """
  Builds a new type that matches anything.

  ## Examples

      iex> Vx.None.t() |> Vx.valid?("foo")
      false
  """
  @spec t() :: Vx.t()
  def t, do: %__MODULE__{}

  defimpl Vx.Validatable do
    def validate(_, _), do: false
  end

  defimpl Vx.Printable do
    def print(_), do: "none"
  end
end
