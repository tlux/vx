defmodule Vx.Optional do
  defstruct [:type]

  @type t() :: t(any)

  @opaque t(type) :: %__MODULE__{type: type}

  @spec t(Vx.Validatable.t()) :: t
  def t(type) do
    %__MODULE__{type: type}
  end

  defimpl Vx.Validatable do
    def validate(optional, value) do
      [optional.type, nil]
      |> Vx.Union.t()
      |> Vx.Validatable.validate(value)
    end
  end
end
