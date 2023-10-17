defmodule Vx.TypeError do
  defexception [:type, :validator, :value]

  @type t :: %__MODULE__{
          type: atom,
          validator: atom,
          value: any
        }

  @spec new(atom, atom, any) :: t
  def new(type, validator, value) do
    %__MODULE__{type: type, validator: validator, value: value}
  end

  def message(t) do
    msg = "Type error (#{t.type}) for value: #{inspect(t.value)}"

    case t.validator do
      nil -> msg
      _ -> "#{msg} (validator: #{inspect(t.validator)})"
    end
  end
end
