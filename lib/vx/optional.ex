defmodule Vx.Optional do
  defstruct [:member]

  @type t() :: t(any)
  @opaque t(member) :: %__MODULE__{member: member}

  @doc false
  def new(member) do
    %__MODULE__{member: member}
  end

  defimpl Vx.Validatable do
    def validate(type, value) do
      [type.member, nil]
      |> Vx.Union.t()
      |> Vx.Validatable.validate(value)
    end
  end
end
