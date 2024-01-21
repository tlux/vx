defmodule Vx.Literal do
  @moduledoc """
  The List type provides a validator for literals.
  """

  defstruct [:value]

  @type t() :: t(any)
  @type t(value) :: %__MODULE__{value: value}

  @doc """
  Defines a literal.
  """
  @spec t(any) :: t
  def t(value), do: %__MODULE__{value: value}

  defimpl Vx.Validatable do
    def validate(literal, value) do
      literal.value
      |> Vx.eq()
      |> Vx.Validatable.validate(value)
    end
  end
end
