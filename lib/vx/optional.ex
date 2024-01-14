defmodule Vx.Optional do
  @moduledoc """
  The Optional type provides validators to mark values optional.
  """

  defstruct [:input]

  @type t() :: t(any)
  @type t(input) :: %__MODULE__{input: input}

  @doc """
  Marks a value optional.
  """
  @spec t(Vx.t()) :: t
  def t(input), do: %__MODULE__{input: input}

  defimpl Vx.Validatable do
    def validate(optional, value) do
      [optional.input, nil]
      |> Vx.Union.t()
      |> Vx.Validatable.validate(value)
    end
  end
end
