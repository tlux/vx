defmodule Vx.Literal do
  @moduledoc """
  The Literal type.
  """

  @enforce_keys [:value]
  defstruct [:value]

  @type t :: t(any)
  @opaque t(value) :: %__MODULE__{value: value}

  @spec t(value) :: t(value) when value: var
  def t(value) do
    %__MODULE__{value: value}
  end

  defimpl Vx.Validatable do
    def validate(%{value: value}, actual_value) do
      if value == actual_value do
        :ok
      else
        {:error, "must be #{Kernel.inspect(value)}"}
      end
    end
  end

  defimpl Vx.Inspectable do
    def inspect(%{value: value}), do: Kernel.inspect(value)
  end
end
