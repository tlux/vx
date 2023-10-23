defmodule Vx.Optional do
  defstruct [:input]

  @type t() :: t(any)

  @opaque t(input) :: %__MODULE__{input: input}

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
