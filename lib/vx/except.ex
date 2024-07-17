defmodule Vx.Except do
  @moduledoc """
  The Except type subtracts one type from another.
  """
  @moduledoc since: "1.0.0"

  @enforce_keys [:a, :b]
  defstruct [:a, :b]

  @type t :: %__MODULE__{a: Vx.t(), b: Vx.t()}

  @doc """
  Builds a new Except type.

  # Examples

    iex> Vx.Except.t(Vx.Number.t(), Vx.Integer.t()) |> Vx.valid?(123.4)
    true

    iex> Vx.Except.t(Vx.Number.t(), Vx.Integer.t()) |> Vx.valid?(123)
    false
  """
  @spec t(Vx.t(), Vx.t()) :: Vx.t()
  def t(a, b), do: %__MODULE__{a: a, b: b}

  @doc """
  Builds a new Except type from a list of schemata.
  """
  @doc since: "1.0.0"
  @spec t(nonempty_list(Vx.t())) :: Vx.t()
  def t([_, _ | _] = schemata) when is_list(schemata) do
    Enum.reduce(schemata, &t(&2, &1))
  end

  defimpl Vx.Validatable do
    def validate(%{a: a, b: b}, value) do
      Vx.valid?(a, value) && !Vx.valid?(b, value)
    end
  end

  defimpl Vx.Printable do
    def print(%{a: a, b: b}) do
      "#{Vx.Printable.print(a)} except #{Vx.Printable.print(b)}"
    end
  end
end
