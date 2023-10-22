defmodule Vx.Optional do
  defstruct [:inner]

  @type t() :: t(any)
  @opaque t(inner) :: %__MODULE__{inner: inner}

  @spec t(Vx.Validatable.t()) :: t
  def t(inner) do
    %__MODULE__{inner: inner}
  end

  defimpl Vx.Validatable do
    def validate(type, value) do
      [type.inner, nil]
      |> Vx.Union.t()
      |> Vx.Validatable.validate(value)
    end
  end
end
