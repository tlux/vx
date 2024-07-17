defmodule Vx.Intersect do
  @moduledoc """
  The Intersect type combines multiple types into a single type, validating
  whether all of them are valid.
  """

  @enforce_keys [:a, :b]
  defstruct [:a, :b]

  @type t :: %__MODULE__{a: Vx.t(), b: Vx.t()}

  @doc """
  Builds a new Intersect type.

  ## Examples

      iex> Vx.Intersect.t(Vx.Integer.t(), Vx.Number.t()) |> Vx.valid?(123)
      true

      iex> Vx.Intersect.t(Vx.Integer.t(), Vx.Number.t()) |> Vx.valid?(12.3)
      false
  """
  @doc since: "1.0.0"
  @spec t(Vx.t(), Vx.t()) :: Vx.t()
  def t(a, b), do: %__MODULE__{a: a, b: b}

  @doc """
  Builds a new Intersect type from a list of schemata.
  """
  @spec t(nonempty_list(Vx.t())) :: Vx.t()
  def t([_, _ | _] = schemata) when is_list(schemata) do
    Enum.reduce(schemata, &t(&2, &1))
  end

  defimpl Vx.Validatable do
    def validate(%{a: a, b: b}, value) do
      Vx.valid?(a, value) && Vx.valid?(b, value)
    end
  end

  defimpl Vx.Printable do
    def print(%{a: a, b: b}) do
      "#{Vx.Printable.print(a)} and #{Vx.Printable.print(b)}"
    end
  end
end
